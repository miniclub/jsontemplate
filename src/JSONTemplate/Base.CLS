Include %occErrors

Class JSONTemplate.Base Extends %RegisteredObject [ Abstract, DependsOn = JSONTemplate.Generator ]
{

/// タブ
Parameter TABSIZE = 4;

/// JSON出力する際のテンプレート
/// JSONの値に#(..プロパティ名)#または#(..#パラメータ名)#を指定することで
/// プロパティの値をJSON形式で出力できます。
/// #(..プロパティ名(テンプレート名))#を指定すると、特定のプロパティに対して
/// テンプレートとして使用するクラスを指定できます。
/// プロパティの型がJSONTemplate.Baseを継承したクラスの場合、
/// そのクラスのテンプレートからJSON出力します。
XData Template [ MimeType = application/json ]
{
{}
}

Parameter %JSONENABLED = 1;

/// 標準デバイスへの出力
Method OutputToDevice() As %Status
{
        set ret=$$$OK
        set json=..FormattedOutput($this,.ret)
        if $$$ISOK(ret) {
            set out=##class(%JSON.Formatter).%New()
            set out.indent=4
            do out.Format(json)
        }
        quit ret
}

/// ファイルへの出力
Method OutputToFile(filename As %String, charset As %String = "UTF8") As %Status
{
    set ret=$$$OK
    open filename:("WNS"_$select(charset'="":"K\"_charset_"\",1:"")):5
    if '$test {
        quit $$$ERROR($$$FileCanNotOpen,filename)
    }
    try {
        set tpl=..FormattedOutput($this,.ret)
        quit:$$$ISERR(ret)

        #dim out as %JSON.Formatter
        set out=##class(%JSON.Formatter).%New()
        set out.Indent=1

        use filename
        set ret=out.Format(tpl)
        do:$$$ISERR(ret) $SYSTEM.OBJ.DisplayError(ret)
        //do tpl.%ToJSON()
    } catch err {
        set ret=err.AsStatus()
    }
    close filename
    quit ret
}

Property %Indent As %Integer [ InitialExpression = 0 ];

/// テンプレートからJSONデータを出力
ClassMethod FormattedOutput(obj As %RegisteredObject, ByRef ret As %Status) As %DynamicAbstractObject [ CodeMode = objectgenerator ]
{
    // Abstractクラスの場合は生成しない
    if %class.Abstract {
        do %code.WriteLine(" set ret=$$$NotImplemented quit """"")
        quit $$$OK
    }
    set ret=$$$OK,lineno=0
    try {
        // プロパティの一覧と型を取得
        set key="" for {
            set pdef=%compiledclass.Properties.GetNext(.key)
            quit:key=""
            set tdef=##class(%CompiledClass).%OpenId(pdef.Type)
            set display=$select(pdef.Parameters.GetAt("DISPLAYLIST")'=""||(pdef.Parameters.GetAt("FORMAT")'=""):1,1:0)
            set props(pdef.Name)=$lb(pdef.Type,tdef.ClassType,pdef.Required,pdef.Collection,display)
        }
        // パラメータの一覧を取得
        set key="" for {
            set pdef=%compiledclass.Parameters.GetNext(.key)
            quit:key=""
            set params(pdef.Name)=$lb(pdef.Default)
        }
        do %code.WriteLine(" set ret=$$$OK try {")

        // テンプレートを読み込む
        Set compiledXdata=##class(%Dictionary.CompiledXData).%OpenId(%class.Name_"||Template")
        set tplstm=compiledXdata.Data
        do tplstm.Rewind()

        // JSONからオブジェクトを作成
        set tpl={}.%FromJSON(tplstm)
        if 'tpl.%IsA("%DynamicObject") {
            set ret=$$$ERROR(5001,"テンプレートがJSON objectではありません")
            quit
        }
        // JSON出力処理の生成
        set code=##class(%Stream.TmpCharacter).%New()
        //set code.TranslateTable="UTF8"
        set ret=##class(JSONTemplate.Generator).GenerateObject(code, "object",tpl,"tpl",.params,.props)
        quit:$$$ISERR(ret)
        do %code.WriteLine(" set tpl="_tpl.%ToJSON())
        do code.Rewind()
        while 'code.AtEnd {
            do %code.WriteLine("   "_code.ReadLine())
        }

        do %code.WriteLine(" } catch err { set ret=err.AsStatus() }")
        do %code.WriteLine(" quit $select($$$ISOK(ret):tpl,1:"""")")

    } catch err {
        set ret=$SYSTEM.Status.AppendStatus($$$ERROR(5001,"エラーが発生しました"),err.AsStatus())
    }
    quit ret
}

}

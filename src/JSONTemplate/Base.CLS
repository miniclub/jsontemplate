Include %occErrors

Class JSONTemplate.Base Extends %RegisteredObject [ Abstract, DependsOn = JSONTemplate.Generator ]
{

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
        set json=..Process($this,.ret)
        if $$$ISOK(ret) {
            set out=##class(%JSON.Formatter).%New()
            set out.Indent=1
            set ret=out.Format(json)
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
        set tpl=..Process($this,.ret)
        quit:$$$ISERR(ret)

        #dim out as %JSON.Formatter
        set out=##class(%JSON.Formatter).%New()
        set out.Indent=1

        use filename
        set ret=out.Format(tpl)
    } catch err {
        set ret=err.AsStatus()
    }
    close filename
    quit ret
}

/// ストリームへの出力
Method OutputToStream(stream As %Stream) As %Status
{
    set ret=$$$OK
    try {
        set tpl=..Process($this,.ret)
        quit:$$$ISERR(ret)
        do tpl.%ToJSON(stream)
    } catch err {
        set ret=err.AsStatus()
    }
    quit ret
}

/// テンプレートからJSONデータを出力
/// テンプレートを元にプロパティを挿入したJSONオブジェクトを返す
ClassMethod Process(obj As %RegisteredObject, ByRef ret As %Status) As %DynamicAbstractObject [ CodeMode = objectgenerator ]
{
    // Abstractクラスの場合は生成しない
    if %class.Abstract {
        do %code.WriteLine(" set ret=$$$NotImplemented quit """"")
        quit $$$OK
    }
    set ret=$$$OK,lineno=0
    try {
        set %debug=$get(%debug,0)
        // プロパティの一覧と型を取得
        set key="" for {
            set pdef=%compiledclass.Properties.GetNext(.key)
            quit:key=""
            set tdef=##class(%Dictionary.ClassDefinition).%OpenId(pdef.Type,,.ret)
            //quit:$$$ISERR(ret)
            set display=$select(pdef.Parameters.GetAt("DISPLAYLIST")'=""||(pdef.Parameters.GetAt("FORMAT")'=""):1,1:0)
            set classtype=$select($isobject(tdef)&&(tdef.ClassType="datatype"):tdef.ClientDataType,$extract(pdef.Type)="%":tdef.ClientDataType,1:"")

            set props(pdef.Name)=$lb(pdef.Type,classtype,pdef.Required,pdef.Collection,display)
        }
        quit:$$$ISERR(ret)

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
        do ##class(Generator).InitJSONString()
        set objstr=##class(Generator).SetJSONString(code,tpl)
        set ret=##class(JSONTemplate.Generator).GenerateObject(code, "object",tpl,objstr,.params,.props)
        quit:$$$ISERR(ret)
        do code.Rewind()
        while 'code.AtEnd {
            set line=code.ReadLine()
            if $zstrip(line,"<>W")?1"$tpl"1.N {
                // $tplで始まる行があれば、JSON文字列出力
                write "line "_line,!
                do %code.WriteLine("  set "_$piece(line,"$",2)_"="_%jsonstring(+$piece(line,"$tpl",2)).%ToJSON())
            } else {
                do %code.WriteLine("   "_line)
            }
        }

        do %code.WriteLine(" } catch err { set ret=err.AsStatus() }")
        do %code.WriteLine(" quit $select($$$ISOK(ret):"_objstr_",1:"""")")

    } catch err {
        set ret=$SYSTEM.Status.AppendStatus($$$ERROR(5001,"エラーが発生しました"),err.AsStatus())
    }
    quit ret
}

Method %OnNew(initvalue As %DynamicObject = "") As %Status
{
    quit:initvalue="" $$$OK
    quit:'$isobject(initvalue)||('initvalue.%IsA("%DynamicObject")) $$$ERROR(5001,"%DynamicObjectを継承したインスタンスを指定してください")
    set ret=$$$OK
    try {
        set iter=initvalue.%GetIterator()
        while iter.%GetNext(.mkey,.value) {
            set mtype=$select($isobject(value):$select(value.%IsA("%DynamicArray"):"object",1:"array"),1:"string")
            set $property($this,mkey)=value
        }
    } catch err {
        set ret=err.AsStatus()
    }
    quit ret
}

/// コード文字列からインスタンスを取得
/// 継承先にて実装
ClassMethod GetByCode(code As %String) As JSONTemplate.Base [ Abstract ]
{
	quit ""
}

}

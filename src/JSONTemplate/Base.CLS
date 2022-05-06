Include %occErrors

Class JSONTemplate.Base Extends %RegisteredObject [ Abstract, DependsOn = JSONTemplate.Generator ]
{

/// タブ
Parameter TABSIZE = 4;

/// JSON出力する際のテンプレート
/// JSONの値に#(..プロパティ名)#または#(..#パラメータ名)#を指定することで
/// プロパティの値をJSON形式で出力できます。
/// プロパティの型がJSONTemplate.Baseを継承したクラスの場合、
/// そのクラスのテンプレートからJSON出力します。
XData Template [ MimeType = application/json ]
{
{}
}

/// 標準デバイスへの出力
Method OutputToDevice(indent As %Integer = 0) As %Status
{
        quit ..FormattedOutput(indent)
}

/// ファイルへの出力
Method OutputToFile(filename As %String, charset As %String = "") As %Status
{
    set ret=$$$OK
    open filename:("WNS"_$select(charset'="":"K\"_charset_"\",1:"")):5
    if '$test {
        quit $$$ERROR($$$FileCanNotOpen,filename)
    }
    try {
        use filename
        set ret=..FormattedOutput()
    } catch err {
        set ret=err.AsStatus()
    }
    close filename
    quit ret
}

/// テンプレートからJSONデータを出力
Method FormattedOutput(indent As %Integer = 0) As %Status [ CodeMode = objectgenerator ]
{
    // Abstractクラスの場合は生成しない
    if %class.Abstract {
        do %code.WriteLine(" quit $$$OK")
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
        set ret=##class(JSONTemplate.Generator).GenerateObject(%code, "object",tpl,0,.params,.props)
        quit:$$$ISERR(ret)
        do %code.WriteLine(" } catch err { set ret=err.AsStatus() }")
        do %code.WriteLine(" quit ret")

    } catch err {
        set ret=$SYSTEM.Status.AppendStatus($$$ERROR(5001,"エラーが発生しました"),err.AsStatus())
    }
    quit ret
}

}

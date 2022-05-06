Class JSONTemplate.Generator Extends %RegisteredObject
{

/// JSON出力する処理の生成
/// JSONの値の文字列に#(..プロパティ名)#または#(..#パラメータ名)#を指定することで
/// プロパティの値をJSON形式で出力できます。
/// プロパティの型がJSONTemplate.Baseを継承したクラスの場合、
/// そのクラスのテンプレートからJSON出力します。
ClassMethod GenerateObject(outstream As %Stream, type As %String, template As %DynamicAbstractObject, indent As %Integer, ByRef params, ByRef props) As %Status
{
    set ret=$$$OK
    try {
        set indent=indent+1
        // TABSIZEパラメータの取得
        set pdef=##class(%CompiledParameter).%OpenId(%class.Name_":TABSIZE")
        set tabsize=$select($isobject(pdef):pdef.Default,1:"4")

        // オブジェクト、Arrayの括弧を出力
        do outstream.WriteLine(" write """_$select(type="array":"[",1:"{")_""",!")
        do outstream.WriteLine(" set cnt"_indent_"=0")

        // templateのメンバーを順に取り出す
        set iter=template.%GetIterator(),delimiter=0
        while iter.%GetNext(.mkey,.value,.mtype) {

            if mtype="object" {
                // メンバーがオブジェクトの場合
                // キーを出力する
                do ..OutputKey(outstream, $select(type="object":mkey,1:""), indent, delimiter)
                // オブジェクト部分の生成
                set ret=..GenerateObject(outstream, "object",value,indent,.params,.props)
                quit:$$$ISERR(ret)
                set delimiter=1 // 要素として出力されるので、次の要素は必ずデリミタを出力
                continue
            } elseif mtype="array" {
                // メンバーがarray の場合
                // デリミタを出力する
                do ..OutputKey(outstream, $select(type="object":mkey,1:""), indent, delimiter)
                // Array部分の生成
                set ret=..GenerateObject(outstream, "array", value, indent, .params, .props)
                quit:$$$ISERR(ret)
                set delimiter=1 // 要素として出力されるので、次の要素は必ずデリミタを出力
                continue
            } elseif value'["#("&&(value'[")#") {
                // 固定文字列の場合
                // キーがあれば、出力する
                do ..OutputKey(outstream, $select(type="object":mkey,1:""), indent, delimiter)
                do ..OutputValue(outstream, value)
                set delimiter=1 // 要素として出力されるので、次の要素は必ずデリミタを出力
                continue
            } elseif value?1"#("2"."1E1A.AN1")#" {
                // objectやarray形式の置き換え
                set token=$piece($piece(value,")#"),"#(",2)
                set ret=..GetParamInfo(token,.info,.params,.props)
                quit:$$$ISERR(ret)
                //zw info
                if $lg(info)="param" {
                    do ..OutputKey(outstream, $select(type="object":mkey,1:""), indent, delimiter)
                    do ..OutputValue(outstream,$lg(info,3))
                    set delimiter=1 // 要素として出力されるので、次の要素は必ずデリミタを出力
                    continue
                }
                if $lg(info)="prop" {
                    // オブジェクト参照がNULLの可能性がある場合、キーも表示させないよう条件式を生成
                    if $lg(info,4)'="datatype"&&($lg(info,5)=0) {
                        do outstream.WriteLine(" if .."_$lg(info,2)_"'="""" {")                    
                    }
                    // キーの生成
                    do ..OutputKey(outstream, $select(type="object":mkey,1:""), indent, delimiter)
                    if $lg(info,4)'="datatype" {
                        do ..OutputObject(outstream, info, indent)
                    } else {
                        do ..OutputProperty(outstream, info, indent)
                    }
                    if $lg(info,4)'="datatype"&&($lg(info,5)=0) {
                        do outstream.WriteLine(" }")
                    }
                    continue
                }
                continue
            }
            // 文字列、数字の置き換え
            // 最初に#)がないかをチェック
            set code=""
            set literal=$piece(value,"#(")
            if $length(literal,")#")>1 {
                set ret=$$$ERROR(5001,"「#(」が見つかりません")
                quit
            }
            set code="""""""",codeopen=1
            set:literal'="" code=""""""""_$replace(literal,"""",""""""),codeopen=1

            // プロパティ、パラメータを抽出
            for v=2:1:$length(value,"#(") {
                set var=$piece(value,"#(",v)
                // )#があることをチェック
                set l=$length(var,")#")
                if l'=2 {
                    set ret=$$$ERROR(5001,"「)#」が"_$select(l>2:"多すぎます",1:"見つかりません"))
                    quit
                }
                set literal=$piece(var,")#",2)
                set var=$piece(var,")#")
                quit:$$$ISERR(ret)
                set ret=..GetParamInfo(var,.info,.params,.props)
                quit:$$$ISERR(ret)
                if $lg(info)="param" {
                    set code=code_$select(code'=""&&codeopen:"",code'="":"_""",1:"""")_$replace($lg(info,3),"""",""""""),codeopen=1
                } elseif $lg(info)="prop" {
                    set code=code_$select(code'=""&&codeopen:"""_",code'="":"_",1:"")_".."_$lg(info,2),codeopen=0
                }
                set:literal'="" code=code_$select(code'=""&&codeopen:"",code'="":"_""",1:"""")_$replace(literal,"""",""""""),codeopen=1
            }
            set code=code_$select(codeopen:"""""""",1:"_""""""""")
            // 出力
            do ..OutputKey(outstream, $select(type="object":mkey,1:""), indent, delimiter)
            do outstream.WriteLine(" write "_code_",!")
            quit:$$$ISERR(ret)
        }
        // オブジェクト、Arrayの括弧を出力
        do outstream.WriteLine(" write ?((indent+"_(indent-1)_")*"_tabsize_"),"""_$select(type="array":"]",1:"}")_""",!")
    } catch err {
        set ret=$SYSTEM.Status.AppendStatus($$$ERROR(5001,"エラーが発生しました"),err.AsStatus())
    }
    quit ret
}

/// 変数の構文解析
/// パラメータやプロパティの属性を取得する
/// info ... $lb("param",default)
///          $lb("ref",propname,proptype,classtype,required,collection,$lb(classlist))
///          $lb("prop",propname,proptype,classtype,required,collection,$lb(classlist))
ClassMethod GetParamInfo(token As %String, ByRef info, ByRef params, ByRef props) As %Status
{
    set info=""
    set ret=$$$OK
    try {
        if $extract(token,1,3)="..#" {
            // パラメータ値代入
            set token=$extract(token,4,*)
            write "パラメータ:",token,!
            // パラメータチェック
            if token="" {
                set ret=$$$ERROR(5001,"パラメータ名が存在しません")
                quit
            }
            if '$data(params(token),val) {
                set ret=$$$ERROR(5001,"パラメータ「"_token_"」が存在しません")
                quit
            }
            set info=$lb("param",token)_val
        } elseif $extract(token,1,3)="..@" {
            // オブジェクト参照形式
            set token=$extract(token,4,*)
            set classlist=""
            write "参照オブジェクト:",token,!
            if token["(" {
                set refclslist=$piece($piece(token,")"),"(",2)
                set token=$piece(token,"(")
                // 制約クラスのリスト作成
                for r=1:1:$length(refclslist,"|") {
                    set refclass=$piece(refclslist,"|",r)
                    if refclass'["." {
                        set classlist=classlist_$lb($piece(%class.Name,".",1,*-1)_"."_refclass)
                    } else {
                        set classlist=classlist_$lb(refclass)
                    }
                }
            }
            // プロパティチェック
            if token="" {
                set ret=$$$ERROR(5001,"プロパティ名が存在しません")
                quit
            }
            if '$data(props(token),val) {
                set ret=$$$ERROR(5001,"プロパティ「"_token_"」が存在しません")
                quit
            }
            set info=$lb("ref",token)_val_$select(classlist'="":$lb(classlist),1:"")
            
        } elseif $extract(token,1,2)=".." {
            set token=$extract(token,3,*)
            // パラメータチェック
            write "オブジェクト:",token,!
            if token="" {
                set ret=$$$ERROR(5001,"プロパティ名が存在しません")
                quit
            }
            if '$data(props(token),val) {
                set ret=$$$ERROR(5001,"プロパティ「"_token_"」が存在しません")
                quit
            }
            set info=$lb("prop",token)_val
        } else {
            set ret=$$$ERROR(5001,"パラメータ、プロパティの指定が誤っています 値:"_token)
            quit
        }
    } catch err {
        set ret=err.AsStatus()
    }
    quit ret
}

/// 固定値の出力
ClassMethod OutputValue(outstream As %Stream, value As %String, cr As %Boolean = 1) As %Status
{
    write "outputvalue",!
    do outstream.WriteLine(" write """""""_$replace(value,"""","""""")_""""""""_$select(cr:",!",1:""))
    quit $$$OK
}

/// プロパティ出力
ClassMethod OutputKey(outstream As %Stream, key As %String, indent As %Integer, delimiter As %Boolean = 0) As %Status
{
    write "outputKey:"_key_":"_delimiter,!
    set pdef=##class(%CompiledParameter).%OpenId(%class.Name_":TABSIZE")
    set tabsize=$select($isobject(pdef):pdef.Default,1:"4")
    do outstream.WriteLine(" write ?((indent+"_indent_")*"_(tabsize)_"),"_$select(delimiter:""",""",1:"$select(cnt"_indent_">0:"","",1:"""")")_$select(key'="":"_"""""""_key_""""": """,1:"")_" set cnt"_indent_"=cnt"_indent_"+1")
    quit $$$OK
}

/// オブジェクトへのリファレンス出力
ClassMethod OutputReference(outstream As %Stream, prop As %String, type As %String, indent As %Integer) As %Status
{
    set tdef=##class(%CompiledClass).%OpenId(type)
    if '$isobject(tdef)||('tdef.%IsA("FHIRTemplate.Resource")) {
        quit $$$ERROR(5001,"クラス"_type_"はFHIRTemplate.Resourceクラスを継承していません")
    }
    do outstream.WriteLine(" if .."_prop_".%IsA("""_type_""") { set ret=.."_prop_".OutputRefernce(indent) } else { set ret=$$$ERROR(5001,""プロパティ"_prop_"の型が誤っています class=""_.."_prop_".%ClassName(1)) } quit:$$$ISERR(ret) ret")
    quit $$$OK
}

/// オブジェクト出力
ClassMethod OutputObject(outstream As %Stream, info As %List, indent As %Integer) As %Status
{
    write "outputObject",!
    set pdef=##class(%CompiledParameter).%OpenId(%class.Name_":TABSIZE")
    set tabsize=$select($isobject(pdef):pdef.Default,1:"4")

    // 値の型チェック
    do outstream.WriteLine(" if '.."_$lg(info,2)_".%IsA("""_$lg(info,3)_""") { set ret=$$$ERROR(5001,""プロパティ"_$lg(info,2)_"の型が誤っています class=""_.."_$lg(info,2)_".%ClassName(1)) quit }")

    if $lg(info,6)'="" {
        do outstream.WriteLine(" write !,?((indent+"_indent_")*"_tabsize_"+2),""["",!")
        do outstream.WriteLine(" if .."_$lg(info,2)_".%IsA(""%Library.DynamicArray"") {")
        do outstream.WriteLine("   set iter=.."_$lg(info,2)_".%GetIterator() for loop=1:1 { quit:'iter.%GetNext(.k,.v,.t) write:loop>1 "","" set ret=##class("_$lg(info,3)_").OutputByParams(v,indent+1) quit:$$$ISERR(ret) } quit:$$$ISERR(ret)")
        do outstream.WriteLine(" } else {")
        do outstream.WriteLine("   set key="""" for loop=1:1 { set obj=.."_$lg(info,2)_".GetNext(.key) quit:key=""""  write:loop>1 "","" set ret=obj.FormattedOutput(indent+1) quit:$$$ISERR(ret) } quit:$$$ISERR(ret)")
        do outstream.WriteLine(" } write ?((indent+"_indent_")*"_tabsize_"+2),""]"",!")
    } else {
        if $lg(info,4)="datatype" {
            // プロパティがデータ型の場合、出力コードにプロパティを代入
            do outstream.WriteLine(" write """"""""_.."_$lg(info,2)_"_""""""""")
        } else {
            // プロパティがオブジェクトの場合、
            do outstream.WriteLine(" write ! if .."_$lg(info,2)_".%IsA(""%Library.DynamicArray"") {")
            do outstream.WriteLine("   set ret=##class("_$lg(info,3)_").OutputByParams(.."_$lg(info,2)_",indent+1) quit:$$$ISERR(ret)")
            do outstream.WriteLine(" } elseif .."_$lg(info,2)_".%IsA("""_$lg(info,2)_""") {")
            do outstream.WriteLine("   set ret=.."_$lg(info,2)_".FormattedOutput(indent+1) quit:$$$ISERR(ret)")
            do outstream.WriteLine(" } else {")
            do outstream.WriteLine("   set ret=$$$ERROR(5001,""プロパティ"_$lg(info,2)_"の型が誤っています class=""_.."_$lg(info,2)_".%ClassName(1)) quit")
            do outstream.WriteLine(" }")
        }
    }
    quit $$$OK
}

/// プロパティ値の出力
ClassMethod OutputProperty(outstream As %Stream, info As %List, indent As %Integer, cr As %Boolean = 1) As %Status
{
    write "outputProperty",!
    set pdef=##class(%CompiledParameter).%OpenId(%class.Name_":TABSIZE")
    set tabsize=$select($isobject(pdef):pdef.Default,1:"4")

    // リストの場合
    if $lg(info,6)'="" {
        do outstream.WriteLine(" write ""["",!")
        do outstream.WriteLine(" if .."_$lg(info,2)_".%IsA(""%Library.DynamicArray"") {")
        do outstream.WriteLine("   set iter=.."_$lg(info,2)_".%GetIterator() for loop=1:1 { quit:'iter.%GetNext(.k,.v,.t) write:loop>1:"","" write """"""_v_"""""""_$select(cr:",!",1:"")_"}")
        do outstream.WriteLine(" } else {")
        do outstream.WriteLine("   set key="""" for loop=1:1 { set obj=.."_$lg(info,2)_".GetNext(.key) quit:key=""""  write:loop>1:"","" set ret=obj.FormattedOutput(indent+1) quit:$$$ISERR(ret) } quit:$$$ISERR(ret)")
        do outstream.WriteLine(" } write ?((indent+"_indent_")*"_tabsize_"+2),""]"",!")
    } else {
        // プロパティがデータ型の場合、出力コードにプロパティを代入
        do outstream.WriteLine(" write """"""""_$replace(.."_$lg(info,2)_$select($lg(info,7):"LogicalToDisplay(.."_$lg(info,2)_")",1:"")_","""""""","""""""""""")_"""""""""_$select(cr:",!",1:""))
    }
    quit $$$OK
}

}

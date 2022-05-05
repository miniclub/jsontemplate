Class JSONTemplate.Base Extends %RegisteredObject [ Abstract ]
{

/// JSON出力する際のテンプレート
/// JSONの値の文字列に#(..プロパティ名)#または#(..#パラメータ名)#を指定することで
/// プロパティの値をJSON形式で出力できます。
/// プロパティの型がJSONTemplate.Baseを継承したクラスの場合、
/// そのクラスのテンプレートからJSON出力します。
XData Template [ MimeType = application/json ]
{
{}
}

Method OutputToDevice(indent As %Integer = 0) As %Status
{
        quit ..FormattedOutput(indent)
}

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
                set props(pdef.Name)=pdef.Type_"^"_pdef.Collection
            }
            // パラメータの一覧を取得
            set key="" for {
                set pdef=%compiledclass.Parameters.GetNext(.key)
                quit:key=""
                set params(pdef.Name)=pdef.Default
            }
            do %code.WriteLine(" set ret=$$$OK try {")

            // テンプレートを読み込む
            Set compiledXdata=##class(%Dictionary.CompiledXData).%OpenId(%class.Name_"||Template")
            set tpl=compiledXdata.Data
            do tpl.Rewind()
            //１行ずつ読み込み、#()#があるかをチェック
            for lineno=1:1 {
                quit:tpl.AtEnd
                set line=tpl.ReadLine()
                write "line:",line,!
                if line'["""#("&&(line'[")#""") { // #(、)#を含まない場合
                    // その行をそのまま出力 ( ただしコード生成のためダブルクオートは２文字でエスケープさせる)
                    do %code.WriteLine(" write ?indent,"""_$replace(line,"""","""""")_""",!") 
                    continue
                }
                // 最初に#)がないかをチェック
                set literal=$piece(line,"""#(")
                if $length(literal,")#""")>1 {
                    set ret=$$$ERROR(5001,lineno_"行目: 「#(」が見つかりません")
                    quit
                }
                set outputcode=" write ?indent,"""_$replace(literal,"""","""""")_""""
                set lineindent=$zwidth(literal)

                // プロパティ、パラメータを抽出
                for v=2:1:$length(line,"""#(") {
                    set vsec=$piece(line,"""#(",v)
                    // )#があることをチェック
                    set l=$length(vsec,")#""")
                    if l'=2 {
                        set ret=$$$ERROR(5001,lineno_"行目: 「)#」が"_$select(l>2:"多すぎます",1:"見つかりません"))
                        quit
                    }
                    set literal=$piece(vsec,")#""",2)
                    set vsec=$piece(vsec,")#""")
                    if $extract(vsec,1,3)="..#" {
                        // パラメータ値代入
                        set vsec=$extract(vsec,4,*)

                        write "パラメータ:",vsec,!
                        // パラメータチェック
                        if vsec="" {
                            set ret=$$$ERROR(5001,lineno_"行目: パラメータ名が存在しません")
                            quit
                        }
                        if '$data(params(vsec),val) {
                            set ret=$$$ERROR(5001,lineno_"行目: パラメータ「"_vsec_"」が存在しません")
                            quit
                        }
                        // 出力コードにパラメータ値と次のパラメータまでの文字列を代入
                        set outputcode=outputcode_","""""""_$replace(val,"""","""""")_""""""_$replace(literal,"""","""""")_""""
                        set lineindent=lineindent+$zwidth(val_literal)
                        write "output:"_outputcode,!
                        continue
                    } elseif $extract(vsec,1,3)="..@" {
                        kill ref
                        // オブジェクト参照形式
                        set vsec=$extract(vsec,4,*)
                        write "参照オブジェクト:",vsec,!
                        if vsec["(" {
                            set refclslist=$piece($piece(vsec,")"),"(",2)
                            set vsec=$piece(vsec,"(")
                            // 制約クラスが存在するかをチェック
                            for r=1:1:$length(refclslist,"|") {
                                set refclass=$piece(refclslist,"|",r)
                                if refclass'["." {
                                    set ref($piece($classname($this),".",1,*-1)_"."_refclass)=""
                                } else {
                                    set ref(refclass)=""
                                }
                            }
                        }
                        // プロパティチェック
                        if vsec="" {
                            set ret=$$$ERROR(5001,lineno_"行目: プロパティ名が存在しません")
                            quit
                        }
                        if '$data(props(vsec),val) {
                            set ret=$$$ERROR(5001,lineno_"行目: プロパティ「"_vsec_"」が存在しません")
                            quit
                        }
                        set type=$piece(val,"^"),collection=$piece(val,"^",2)
                        do %code.WriteLine(outputcode_",!")
                        if $data(ref)>1 {
                            // リソース制約アリの場合
                            set cond="",r="" for {
                                set r=$order(ref(r))
                                quit:r=""
                                set cond=$select(cond="":"",1:cond_"||")_".."_vsec_".%IsA("""_r_""")"
                            }
                            do %code.WriteLine(" if "_cond_" { set ret=.."_vsec_".OutputRefernce("_lineindent_") } else { ret=$$$ERROR(5001,""プロパティ"_vsec_"の制約条件を満たしていません class=""_.."_vsec_".%ClassName(1)) } quit:$$$ISERR(ret) ret")
                        } else {
                            // リソース制約無しの場合
                            do %code.WriteLine(" if .."_vsec_".%IsA("""_type_""") { set ret=.."_vsec_".OutputRefernce("_lineindent_") } else { ret=$$$ERROR(5001,""プロパティ"_vsec_"の型が誤っています class=""_.."_vsec_".%ClassName(1)) } quit:$$$ISERR(ret) ret")
                        }
                        set outputcode=" write ?indent,"""""_$replace(literal,"""","""""")_""""
                        set lineindent=$zwidth(literal)
                        
                    } elseif $extract(vsec,1,2)=".." {
                        set vsec=$extract(vsec,3,*)
                        // パラメータチェック
                        write "オブジェクト:",vsec,!
                        if vsec="" {
                            set ret=$$$ERROR(5001,lineno_"行目: プロパティ名が存在しません")
                            quit
                        }
                        if '$data(props(vsec),val) {
                            set ret=$$$ERROR(5001,lineno_"行目: プロパティ「"_vsec_"」が存在しません")
                            quit
                        }
                        set type=$piece(val,"^"),collection=$piece(val,"^",2)
                        do %code.WriteLine(outputcode)
                        if collection'="" {
                            do %code.WriteLine(" write !,?(indent+2),""["",!")
                            do %code.WriteLine(" if .."_vsec_".%IsA(""%Library.DynamicArray"") {")
                            do %code.WriteLine("   set iter=.."_vsec_".%GetIterator() for loop=1:1 { quit:'iter.%GetNext(.k,.v,.t) write:loop>1:"","" set ret=##class("_type_").OutputByParams(v,indent+4) quit:$$$ISERR(ret) } quit:$$$ISERR(ret) ret")
                            do %code.WriteLine(" } else {")
                            do %code.WriteLine("   set key="""" for loop=1:1 { set obj=.."_vsec_".GetNext(.key) quit:key=""""  write:loop>1:"","" set ret=obj.FormatedOutput(indent+4) quit:$$$ISERR(ret) } quit:$$$ISERR(ret) ret")
                            do %code.WriteLine(" } write ?(indent+2),""]"",!")
                        } else {
                            set tdef=##class(%Dictionary.CompiledClass).%OpenId(type)
                            if tdef.ClassType="datatype" {
                                // プロパティがデータ型の場合、出力コードにプロパティを代入
                                do %code.WriteLine(" write """"""""_$replace(.."_vsec_","""""""","""""""""""")_""""""""")
                             } else {
                                // プロパティがオブジェクトの場合、
                                do %code.WriteLine(" write ! if .."_vsec_".%IsA(""%Library.DynamicArray"") {")
                                do %code.WriteLine("   set ret=##class("_type_").OutputByParams(.."_vsec_",indent+4) quit:$$$ISERR(ret) ret")
                                do %code.WriteLine(" } elseif .."_vsec_".%IsA("""_type_""") {")
                                do %code.WriteLine("   set ret=.."_vsec_".FormatedOutput(indent+4) quit:$$$ISERR(ret) ret")
                                do %code.WriteLine(" } else {")
                                do %code.WriteLine("   set ret=$$$ERROR(5001,""プロパティ"_vsec_"の型が誤っています class=""_.."_vsec_".%ClassName(1)) quit ret")
                                do %code.WriteLine(" }")
                            }
                        }
                        set outputcode=" write """_$replace(literal,"""","""""")_""""
                        set lineindent=$zwidth(literal)
                    } else {
                        set ret=$$$ERROR(5001,lineno_"行目: パラメータ、プロパティの指定が誤っています 値:"_vsec)
                        quit
                    }
                    quit:$$$ISERR(ret)
                }
                quit:$$$ISERR(ret)
                do %code.WriteLine(outputcode_",!")
            }
            do %code.WriteLine(" } catch err { set ret=err.AsStatus() } quit ret")
        } catch err {
            set ret=$SYSTEM.Status.AppendStatus($$$ERROR(5001,lineno_"行目: エラーが発生しました"),err.AsStatus())
        }
        quit ret
}

}

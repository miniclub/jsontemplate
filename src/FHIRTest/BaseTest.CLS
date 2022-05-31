Class FHIRTest.BaseTest Extends JSONTemplate.Base
{

/// JSON出力する際のテンプレート
XData Template [ MimeType = application/json ]
{
{
    "p1":"123456",
    "p2":"#(..Param1)#",
    "p3":"#(..Param1)# #(..Param2)#",
    "p4":"#(..Param2)#",
    "p5":"aaaaaa#(..Param1)#",
    "o1":"#(..Obj1)#",
    "o2":"#(..CodeObj)#",
    "a1":[
        {
            "p1":"1234",
            "o2":"#(..Obj2)#"
        },
        "#(..Obj1)#",
        "#(..List1)#"
    ],
    "a2":[
        "#(..List2)#",
        {
            "p1":5678,
            "o2":"#(..Obj2)#"
        },
        "#(..Obj1)#"
    ]
}
}

Property Param1 As %String;

Property Param2 As %Numeric;

Property CodeObj As BaseCodeTest;

Property Obj1 As BaseTest2;

Property Obj2 As BaseTest2;

Property List1 As list Of %String;

Property List2 As list Of BaseTest2;

ClassMethod Test1()
{
    set obj=..%New()
    set obj.Param1="gggggg"
    set obj.Param2=1234.5
    set obj.CodeObj=##class(BaseCodeTest).GetByCode(1)
    set obj.Obj1=##class(BaseTest2).%New({
        "Param1":"qqqqq",
        "Param2":1111
    })
    set obj.Obj2=##class(BaseTest2).%New()
    set obj.Obj2.Param1="wwwwwww"
    set obj.Obj2.Param2=22222

    do obj.List1.Insert("list1")
    do obj.List1.Insert("list2")
    set obj1=##class(BaseTest2).%New()
    set obj1.Param1="list2 param1"
    set obj1.Param2=4444    
    do obj.List2.Insert(obj1)
    set obj1=##class(BaseTest2).%New()
    set obj1.Param1="list2 param1"
    set obj1.Param2=4444    
    do obj.List2.Insert(obj1)

    set a=##class(%Stream.FileCharacter).%New()
    set a.Filename="c:\temp\basetest2.json"
    set ret=obj.OutputToStream(a)
    if $$$ISOK(ret) {
        do a.%Save()
        use 0 write "正常終了",!
    }else {
        use 0 write "エラー発生",!
        do $SYSTEM.OBJ.DisplayError(ret)
    }
}

}

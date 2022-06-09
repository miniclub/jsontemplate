Class FHIRTest.BaseTest3 Extends BaseTest2
{

/// JSON出力する際のテンプレート
XData Template [ MimeType = application/json ]
{
{
    "xxx1":"BaseTest3",
    "xxx2":"#(..Param1)#",
    "xxx3":"#(..Param1)# #(..Param2)#"
}
}

Property Param1 As %String;

Property Param2 As %Numeric;

}

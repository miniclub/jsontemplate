Class FHIRTemplate.DataType.CodingBase Extends JSONTemplate.Base
{

Parameter CodeSystem;

XData Template [ MimeType = application/json ]
{
{
        "system":"#(..#CodeSystem)#",
        "code": "#(..code)#",
        "display":"#(..display)#"
}
}

Property display As %String;

Property code As %String;

}

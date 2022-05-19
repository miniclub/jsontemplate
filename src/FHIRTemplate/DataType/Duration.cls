Class FHIRTemplate.DataType.Duration Extends JSONTemplate.Base
{

Parameter SYSTEM = "http://unitsofmeasure.org";

Property value As %Integer;

Property unit As %String;

Property system As %String;

Property code As %String;

XData Template [ MimeType = application/json ]
{
{
        "value":"#(..value)#",
        "unit": "#(..unit)#",
        "system":"#(..#SYSTEM)#",
        "code": "#(..code)#"
}
}

}

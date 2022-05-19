Class FHIRTemplate.DataType.Age Extends JSONTemplate.Base
{

Parameter SYSTEM = "http://unitsofmeasure.org";

Property value As %Integer;

Property unit As %String;

Property system As %String;

Property code As %String(DISPLAYLIST = ",minutes,hours,days,weeks,months,years", VALUELIST = ",min,h,d,wk,mo,a");

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

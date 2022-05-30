Class FHIRTemplate.DataType.Period Extends JSONTemplate.Base
{

Property start As %Date(FORMAT = 3);

Property end As %Date(FORMAT = 3);

XData Template [ MimeType = application/json ]
{
{
        "start":"#(..start)#",
        "end": "#(..end)#"
}
}

}

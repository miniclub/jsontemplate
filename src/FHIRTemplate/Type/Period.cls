Class FHIRTemplate.Type.Period Extends JSONTemplate.Base
{

Property start As %String;

Property end As %String;

XData Template [ MimeType = application/json ]
{
{
        "start":"#(..start)#",
        "end": "#(..end)#"
}
}

}

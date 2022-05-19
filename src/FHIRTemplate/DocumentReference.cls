Class FHIRTemplate.DocumentReference Extends FHIRTemplate.Resource
{

Parameter ResourceType = "DocumentReference";

Property CreationTime As FHIRTemplate.DataType.TimeStamp;

Property PDFStream As %String(MAXLEN = 3000000);

XData Template [ MimeType = application/json ]
{
{
    "resource":{
        "resourceType": "#(..#ResourceType)#",
        "meta": {
            "profile": ["http://jpfhir.jp/fhir/eClinicalSummary/StructureDefinition/JPDocumentReference_eClinicalSummary"]
        },
        "status":"current",
        "description":"退院時サマリー",
        "content":[
            {
                "attachment":{
                    "creation":"#(..CreationTime)#",
                    "contentType":"text/html",
                    "data":"#(..PDFStream)#",
                    "url":""
                }
            }
        ]
    }
}
}

}

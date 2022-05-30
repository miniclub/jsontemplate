/// 文書構成リソース
Class FHIRTemplate.Composition Extends FHIRTemplate.Resource
{

/// JSON出力する際のテンプレート
XData Template [ MimeType = application/json ]
{
{
  "resourceType": "#(..#ResourceType)#",
  "meta": {
    "profile": [
      "#(..#Profile)#"
    ]
  },
  "extension":[
    {
    "url":"http://hl7.org/fhir/StructureDefinition/composition-clinicaldocumentversionNumber",
    "valueString":"#(..docVer)#"
    }
  ],
  "identifier":{
    "system":"http://jpfhir.jp/fhir/Common/CodeSystem/resourceInstanceidentifier",
    "value":"#(..docId)#"
  },
  "status":"#(..status)#",
  "type":{
      "coding":[
          "#(..docType)#"
      ]
  },
  "category":[
      {
        "coding":[
            "#(..docCategory)#"
        ]
      }
  ],
  "subject": "#(..subject(Reference))#",
  "encounter": "#(..encounter(Reference))#",
  "date":"#(..date)#",
  "author":[
    "#(..author(Reference))#",
    "#(..authorOrg(Reference))#"
  ],
  "title": "#(..title)#",
  "custodian": "#(..custodian)#",
  "event": {
    "code": "#(..eventCode)#",
    "period": "#(..eventPeriod)#"
  },
  "section": [
    "#(..section)#"
  ]
}
}

Parameter ResourceType = "Composition";

Parameter Profile = "http://jpfhir.jp/fhir/eDischargeSummary/StructureDefinition/JP_Composition_eDischargeSummary";

Property status As %Integer(DISPLAYLIST = ",preliminary,final,amended,entered-in-error", VALUELIST = ",0,1,-1,-2");

Property docId As %String;

Property docVer As %String;

Property docType As FHIRTemplate.Examples.DocType;

Property docCategory As FHIRTemplate.Examples.DocCategory;

Property subject As Patient;

Property encounter As Encounter;

Property date As FHIRTemplate.DataType.TimeStamp(FORMAT = 1);

Property author As Practitioner;

Property authorOrg As Organization;

Property title As %String;

Property custodian As Organization;

Property eventCode As FHIRTemplate.DataType.Coding;

Property eventPeriod As FHIRTemplate.DataType.Period;

Property section As list Of FHIRTemplate.Composition.section;

}

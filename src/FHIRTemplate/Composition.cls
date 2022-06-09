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

Property author As Practitioner;

Property attester As Practitioner;

Property authorOrg As Organization;

Property custodian As Organization;

Property encounter As Encounter;

Property date As FHIRTemplate.DataType.TimeStamp(FORMAT = 1);

Property title As %String;

Property eventCode As FHIRTemplate.DataType.Coding;

Property eventPeriod As FHIRTemplate.DataType.Period;

Property section As list Of FHIRTemplate.Composition.section;

Method GetResources(br As FHIRTemplate.Util.BundleResource)
{
  // 自分自身を登録
  do br.AddResource($this)
  do br.AddResource(..subject)
  do br.AddResource(..author)
  do br.AddResource(..attester)
  do br.AddResource(..authorOrg)
  do br.AddResource(..custodian)
  do br.AddResource(..encounter)
  set key="" for {
    set section=..section.GetNext(.key)
    quit:key=""

    do section.GetResources(br)
  }
  quit
}

}

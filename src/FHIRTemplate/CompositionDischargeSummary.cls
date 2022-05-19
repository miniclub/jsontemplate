Class FHIRTemplate.CompositionDischargeSummary Extends FHIRTemplate.Resource
{

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
    "valueString":"#(..DocVersionNum)#"
    }
  ],
  "identifier":{
    "system":"http://jpfhir.jp/fhir/Common/CodeSystem/resourceInstanceidentifier",
    "value":"#(..IdentifierValue)#"
  },
  "status":"final",
  "type":{
      "coding":[
          {
          "system":"http://jpfhir.jp/fhir/Common/CodeSystem/doc-typecodes",
          "code":"18842-5",
          "display":"退院時サマリー"
          }
      ]
  },
  "category":[
      {
        "coding":[
            {
            "system":"http://jpfhir.jp/fhir/eClinicalSummary/CodeSystem/eClinicalSummary-category",
            "code":"18842-5",
            "display":"退院時サマリー"
            }
        ]
      }
  ],
  "subject":{
    "reference":"urn:uuid:#(..Patient)#"
  },
  "encounter":{
    "reference":"urn:uuid:#(..Encounter)#"
  },
  "date":"#(..CreationDate)#",
  "author":[
    {
        "reference":"urn:uuid:#(..Practitioner)#"
    },
    {
        "reference":"urn:uuid:#(..Organization)#"
    }
  ],
  "title":"退院時サマリー",
  "custodian":{
    "reference":"urn:uuid:#(..Organization)#"
  },
  "section":[
      {
        "title":"構造情報",
        "code":{
          "coding":[
            {
            "system":"http://jpfhir.jp/fhir/eClinicalSummary/CodeSystem/document-section",
            "code":"300",
            "display":"構造情報"
            }
          ]
        },
        "text":{
          "status":"additional",
          "div":"#(..SectionText)#"
        },
        "section":[
          {
            "title":"入院詳細",
            "code":{
                "coding":[
                    {
                    "system":"http://jpfhir.jp/fhir/eClinicalSummary/CodeSystem/document-section",
                    "code":"322",
                    "display":"入院詳細"
                    }
                ]
            },
            "text":{
                "status":"additional",
                "div":"#(..SectionText322)#"
            },
            "entry":[
                {
                  "reference": "urn:uuid:#(..Encounter)#"
                }
            ]
          },
          {
            "title":"入院時診断",
            "code":{
                "coding":[
                    {
                    "system":"http://jpfhir.jp/fhir/eClinicalSummary/CodeSystem/document-section",
                    "code":"342",
                    "display":"入院時診断"
                    }
                ]
            },
            "text":{
                "status":"additional",
                "div":"#(..SectionText342)#"
            },
            "entry":[
                {
                  "reference": "urn:uuid:#(..Condition)#"
                }
            ]
          },
          {
            "title":"アレルギー・不耐性反応",
            "code":{
                "coding":[
                    {
                    "system":"http://jpfhir.jp/fhir/eClinicalSummary/CodeSystem/document-section",
                    "code":"510",
                    "display":"アレルギー・不耐性反応"
                    }
                ]
            },
            "text":{
                "status":"additional",
                "div":"#(..SectionText510)#"
            },
            "entry":[
                {
                    "reference": "urn:uuid:#(..AllergyIntolerance)#"
                }
            ]
          },
          {
            "title":"入院時主訴",
            "code":{
                "coding":[
                    {
                    "system":"http://jpfhir.jp/fhir/eClinicalSummary/CodeSystem/document-section",
                    "code":"352",
                    "display":"入院時主訴"
                    }
                ]
            },
            "text":{
                "status":"additional",
                "div":"#(..SectionText352)#"
            },
            "entry":[
                {
                    "reference": "urn:uuid:#(..Condition)#"
                }
            ]
          },
          {
            "title":"入院理由",
            "code":{
                "coding":[
                    {
                    "system":"http://jpfhir.jp/fhir/eClinicalSummary/CodeSystem/document-section",
                    "code":"312",
                    "display":"入院理由"
                    }
                ]
            },
            "text":{
                "status":"additional",
                "div":"#(..SectionText312)#"
            },
            "entry":[
                {
                    "reference": "urn:uuid:#(..Encounter)#"
                }
            ]
          },
          {
            "title":"入院時現病歴",
            "code":{
                "coding":[
                    {
                    "system":"http://jpfhir.jp/fhir/eClinicalSummary/CodeSystem/document-section",
                    "code":"362",
                    "display":"入院時現病歴"
                    }
                ]
            },
            "text":{
                "status":"additional",
                "div":"#(..SectionText362)#"
            },
            "entry":[
                {
                    "reference": "urn:uuid:#(..Condition)#"
                }
            ]
          },
          {
            "title":"入院中経過",
            "code":{
                "coding":[
                    {
                    "system":"http://jpfhir.jp/fhir/eClinicalSummary/CodeSystem/document-section",
                    "code":"333",
                    "display":"入院中経過"
                    }
                ]
            },
            "text":{
                "status":"additional",
                "div":"#(..SectionText333)#"
            },
            "entry":[
                {
                    "reference": "urn:uuid:#(..DocumentReference)#"
                }
            ]
          },
          {
            "title":"退院時詳細",
            "code":{
                "coding":[
                    {
                    "system":"http://jpfhir.jp/fhir/eClinicalSummary/CodeSystem/document-section",
                    "code":"324",
                    "display":"退院時詳細"
                    }
                ]
            },
            "text":{
                "status":"additional",
                "div":"#(..SectionText324)#"
            },
            "entry":[
                {
                    "reference": "urn:uuid:#(..Encounter)#"
                }
            ]
          },
          {
            "title":"退院時投薬指示",
            "code":{
                "coding":[
                    {
                    "system":"http://jpfhir.jp/fhir/eClinicalSummary/CodeSystem/document-section",
                    "code":"444",
                    "display":"退院時投薬指示"
                    }
                ]
            },
            "text":{
                "status":"additional",
                "div":"#(..SectionText444)#"
            },
            "entry":[
                {
                    "reference": "urn:uuid:#(..MedicationRequest)#"
                }
            ]
          },
          {
          "title":"退院時方針指示",
          "code":{
              "coding":[
                  {
                  "system":"http://jpfhir.jp/fhir/eClinicalSummary/CodeSystem/document-section",
                  "code":"424",
                  "display":"退院時方針指示"
                  }
              ]
          },
          "text":{
              "status":"additional",
              "div":"#(..SectionText424)#"
          },
          "entry":[
            {
                "reference": "urn:uuid:#(..CarePlan)#"
            }
          ]
        }
        ]
      }
  ]
}
}

Parameter ResourceType = "Composition";

/// JSON出力する際のテンプレート
/// JSONの値の文字列に#(..プロパティ名)#または#(..#パラメータ名)#を指定することで
/// プロパティの値をJSON形式で出力できます。
/// プロパティの型がJSONTemplate.Baseを継承したクラスの場合、
/// そのクラスのテンプレートからJSON出力します。
Parameter Profile = "http://jpfhir.jp/fhir/eDischargeSummary/StructureDefinition/JP_Composition_eDischargeSummary";

Property DocVersionNum As %String;

Property IdentifierValue As %String;

/// PatientのUUID
Property Patient As %String;

/// EncounterのUUID
Property Encounter As %String;

Property CreationDate As FHIRTemplate.DataType.TimeStamp;

/// PractitionerのUUID
Property Practitioner As %String;

/// OrganizationのUUID
Property Organization As %String;

/// ConditionのUUID
Property Condition As %String;

/// AllergyIntoleranceのuuid
Property AllergyIntolerance As %String;

/// DocumentReferenceのUUID
Property DocumentReference As %String;

/// MedicationRequestのUUID
Property MedicationRequest As %String;

/// CarePlanのUUID
Property CarePlan As %String;

/// 構造情報のsection.text
Property SectionText As %String(MAXLEN = 10000) [ InitialExpression = "<div xmlns='http://www.w3.org/1999/xhtml'>こんな状況でした</div>" ];

/// 322入院詳細のsection.text
Property SectionText322 As %String(MAXLEN = 10000) [ InitialExpression = "<div xmlns='http://www.w3.org/1999/xhtml'>入院詳細の状況</div>" ];

/// 342入院時診断のsection.text
Property SectionText342 As %String(MAXLEN = 10000) [ InitialExpression = "<div xmlns='http://www.w3.org/1999/xhtml'>入院時診断の状況</div>" ];

/// 510アレルギー・不耐性反応のsection.text
Property SectionText510 As %String(MAXLEN = 10000) [ InitialExpression = "<div xmlns='http://www.w3.org/1999/xhtml'>アレルギー・不耐性反応の状況</div>" ];

/// 352入院時主訴のsection.text
Property SectionText352 As %String(MAXLEN = 10000) [ InitialExpression = "<div xmlns='http://www.w3.org/1999/xhtml'>入院時主訴の状況</div>" ];

/// 312入院理由のsection.text
Property SectionText312 As %String(MAXLEN = 10000) [ InitialExpression = "<div xmlns='http://www.w3.org/1999/xhtml'>入院理由の状況</div>" ];

/// 362入院時現病歴のsection.text
Property SectionText362 As %String(MAXLEN = 10000) [ InitialExpression = "<div xmlns='http://www.w3.org/1999/xhtml'>入院時現病歴の状況</div>" ];

/// 333入院中経過のsection.text
Property SectionText333 As %String(MAXLEN = 10000) [ InitialExpression = "<div xmlns='http://www.w3.org/1999/xhtml'>入院中経過の状況</div>" ];

/// 324退院時詳細のsection.text
Property SectionText324 As %String(MAXLEN = 10000) [ InitialExpression = "<div xmlns='http://www.w3.org/1999/xhtml'>退院時詳細の状況</div>" ];

/// 444退院時投薬指示のsection.text
Property SectionText444 As %String(MAXLEN = 10000) [ InitialExpression = "<div xmlns='http://www.w3.org/1999/xhtml'>退院時投薬指示の状況</div>" ];

/// 424退院時方針指示のsection.text
Property SectionText424 As %String(MAXLEN = 10000) [ InitialExpression = "<div xmlns='http://www.w3.org/1999/xhtml'>退院時方針指示の状況</div>" ];

Property Status As %Integer(DISPLAYLIST = ",preliminary,final,amended,entered-in-error", VALUELIST = ",0,1,-1,-2");

}

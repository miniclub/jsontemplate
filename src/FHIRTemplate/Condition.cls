Class FHIRTemplate.Condition Extends Resource
{

Parameter ResourceType = "Condition";

Parameter ClinicalStatusSystem = "http://hl7.org/fhir/ValueSet/condition-clinical";

Parameter ClinicalStatusDisplay = "Lv0 active,Lv1 recurrence,Lv1 relapse,Lv0 inactive,Lv1 remission,Lv1 resolved";

Parameter ClinicalStatusCode = "active,recurrence,relapse,inactive,remission,resolved";

Parameter VerificationStatusSystem = "http://hl7.org/fhir/ValueSet/condition-ver-status";

Parameter VerificationStatusCode = "unconfirmed,provisional,differential,confirmed,refuted,entered-in-error";

Parameter VerificationStatusDisplay = "Lv0 unconfirmed,Lv1 provisional,Lv1 differential,Lv0 confirmed,Lv0 refuted,Lv0 entered-in-error";

Property TextDiv As %String(MAXLEN = 10000);

/// identifier.valueの値
Property PatientStatusValue As %String;

Property ClinicalStatus As FHIRTemplate.Type.CodeableConcept;

Property VerificationStatus As FHIRTemplate.Type.CodeableConcept;

Property Code As FHIRTemplate.Type.CodeableConcept;

Property BodySite As FHIRTemplate.Type.CodeableConcept;

/// Patientリソースのuuidを入れる
Property Patient As %String;

Property PatientDisplayName As %String;

/// Encounterリソースのuuidを入れる
Property Encounter As %String;

Property Age As FHIRTemplate.Type.Age;

Property RecordedDate As %String;

Property EvidenceCode As FHIRTemplate.Type.CodeableConcept;

/// リソースへのリファレンス
Property EvidenceDetail As %String;

/// 固定値
/// meta.profile/
XData Template [ MimeType = application/json ]
{
{
    "resourceType" : "#(..#ResourceType)#",
    "meta":{
        "profile":["http://jpfhir.jp/fhir/eClinicalSummary/StructureDefinition/JP_Condition_eClinicalSummary"]
    },
    "text" : {
        "status" : "generated",
        "div" : "#(..TextDiv)#"
    },
    "identifier":[
        {
            "system":"http://jpfhir.jp/fhir/Common/CodeSystem/resourceInstance-identifier",
            "value":"#(..PatientStatusValue)#"
        }
    ],
    "clinicalStatus":"#(..ClinicalStatus(FHIRTemplate.Type.CodeableConcept))#",
    "verificationStatus" : "#(..VerificationStatus(FHIRTemplate.Type.CodeableConcept))#",
    "code": "#(..Code(FHIRTemplate.Type.CodeableConcept))#",
    "bodySite": [ "#(..BodySite(FHIRTemplate.Type.CodeableConcept))#" ],
    "subject" : {
        "reference" : "urn:uuid:#(..Patient)#",
        "display" : "#(..PatientDisplayName)#"
    },
    "encounter":{
        "reference":"urn:uuid:#(..Encounter)#"
    },
    "onsetAge": "#(..Age(FHIRTemplate.Type.Age))#",
    "recordedDate": "#(..RecordedDate)#",
    "evidence": [
        {
            "code": [ "#(..EvidenceCode(FHIRTemplate.Type.CodeableConcept))#"],
            "detail":[
                {
                    "reference": "urn:uuid:#(..EvidenceDetail)#"
                }
            ]
        }
    ]
}
}

}

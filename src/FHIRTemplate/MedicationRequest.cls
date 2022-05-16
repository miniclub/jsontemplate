Class FHIRTemplate.MedicationRequest Extends FHIRTemplate.Resource
{

Parameter ResourceType = "MedicationRequest";

Parameter TimingCodeSystem = "urn:oid:1.2.392.200250.2.2.20";

Parameter RouteSystem = "http://jpfhir.jp/fhir/ePrescription/CodeSystem/route-codes";

Parameter MethodSystem = "urn:oid:1.2.392.200250.2.2.20.30";

Parameter DoseAndRateTypeSystem = "urn:oid:1.2.392.100495.20.2.22";

Parameter DispenseRequestValueCodeableConceptSystem = "urn:oid:1.2.392.200250.2.2.30.10";

Parameter DispenceRequestQuantitySystem = "urn:oid:1.2.392.200119.4.403.1";

Property TextDiv As %String(MAXLEN = 10000);

Property MedicationCodeableConcept As FHIRTemplate.Type.CodeableConcept;

Property AuthoredOn As FHIRTemplate.Type.TimeStamp;

/// Patient のUUID
Property Patient As %String;

Property DosageInstructionPeriod As FHIRTemplate.Type.PeriodNoEnd;

Property DosageInstructionDuration As FHIRTemplate.Type.Duration;

/// YYYY-MM-DD
Property TimingEvent As %String;

Property TimingRepetDuration As FHIRTemplate.Type.Duration;

Property TimingCode As FHIRTemplate.Type.CodeableConcept;

Property Route As FHIRTemplate.Type.CodeableConcept;

Property Method As FHIRTemplate.Type.CodeableConcept;

Property DoseAndRateType As FHIRTemplate.Type.CodeableConcept;

Property DoseQuantity As FHIRTemplate.Type.SimpleQuantity;

Property RateRatio As FHIRTemplate.Type.Quantity;

Property Denominator As FHIRTemplate.Type.Quantity;

Property DispenseRequestValueCodeableConcept As FHIRTemplate.Type.CodeableConcept;

Property DispenseRequestQuantity As FHIRTemplate.Type.SimpleQuantity;

Property ExpectedSupplyDuration As FHIRTemplate.Type.Duration;

XData Template [ MimeType = application/json ]
{
{
    "resourceType":"#(..#ResourceType)#",
    "meta":{
        "profile":["http://jpfhir.jp/fhir/ePrescription/StructureDefinition/JP_MedicationRequest_ePrescription"]
    },
    "text":{
        "status":"generated",
        "div":"#(..TextDiv)#"
    },
    "identifier":[
        {
            "system":"urn:oid:1.2.392.100495.20.3.81",
            "value":"1"
        },
        {
            "system":"urn:oid:1.2.392.100495.20.3.82",
            "value":"1"
        }
    ],
    "status":"completed",
    "intent":"order",
    "medicationCodeableConcept":"#(..MedicationCodeableConcept(FHIRTemplate.Type.CodeableConcept))#",
    "subject":{
        "reference":"urn:uuid:#(..Patient)#"
    },
    "authoredOn":"#(..AuthoredOn)#",
    "dosageInstruction": [
        {
        "extension": [
            {
                "url":"http://jpfhir.jp/fhir/core/StructureDefinition/JP_MedicationRequest_DosageInstruction_PeriodOfUse",
                "valuePeriod": "#(..DosageInstructionPeriod(FHIRTemplate.Type.PeriodNoEnd))#"
            },
            {
                "url":"http://jpfhir.jp/fhir/core/StructureDefinition/JP_MedicationRequest_DosageInstruction_UsageDuration",
                "valueDuration":"#(..DosageInstructionDuration(FHIRTemplate.Type.Duration))#"
            }
        ],
        "text": "内服・経口・１日２回朝夕食後 １回２錠 7日分",
        "timing": {
            "event":["#(..TimingEvent)#"],
            "repeat":{
                "boundsDuration":"#(..TimingRepetDuration(FHIRTemplate.Type.Duration))#"
            },
            "code": "#(..TimingCode(FHIRTemplate.Type.CodeableConcept))#"
        },
        "route": "#(..Route(FHIRTemplate.Type.CodeableConcept))#",
        "method":"#(..Method(FHIRTemplate.Type.CodeableConcept))#",
        "doseAndRate": [
            {
                "type":"#(..DoseAndRateType(FHIRTemplate.Type.CodeableConcept))#",
                "doseQuantity": "#(..DoseQuantity(FHIRTemplate.Type.SimpleQuantity))#",
                "rateRatio": {
                    "numerator":"#(..RateRatio(FHIRTemplate.Type.Quantity))#",
                    "denominator": "#(..Denominator(FHIRTemplate.Type.Quantity))#"
                }        
            }
        ]
        }
    ],
    "dispenseRequest":{
        "extension":[
            {
                "url":"http://jpfhir.jp/fhir/core/Extension/StructureDefinition/JP_MedicationRequest_DispenseRequest_InstructionForDispense",
                "valueCodeableConcept":"#(..DispenseRequestValueCodeableConcept(FHIRTemplate.Type.CodeableConcept))#"
            }
        ],
        "quantity":"#(..DispenseRequestQuantity(FHIRTemplate.Type.SimpleQuantity))#",
        "expectedSupplyDuration": "#(..ExpectedSupplyDuration(FHIRTemplate.Type.Duration))#"            
    }
}
}

}

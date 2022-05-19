Class FHIRTemplate.Encounter Extends Resource
{

Parameter ResourceType = "Encounter";

Parameter ClassSystem = "http://terminology.hl7.org/CodeSystem/v3-ActCode";

/// 入院管理番号の名前空間の指定に使う。
Parameter IdentifierSystem = "http://jpfhir.jp/fhir/Common/CodeSystem/resourceInstance-identifier";

Parameter ClassHistorClassSystem = "http://terminology.hl7.org/CodeSystem/v3-ActCode";

/// 入院はIMP、外来はAMB、退院時サマリーはIMPらしい
Parameter ClassHistoryClassCode = "IMP,AMB";

Parameter ClassHistoryClassDisplay = "入院,外来";

/// 入院経路　例
Parameter AdmitSourceSystem = "http://jpfhir.jp/fhir/Common/CodeSystem/admit-Source";

/// AdmitSourceCodeの並びに対応する表示名がAdmitSourceDisplay
Parameter AdmitSourceCode = "0,1,3,4,8,9";

/// AdmitSourceDisplayの並びに対応するコードがAdmitSourceCode
Parameter AdmitSourceDisplay = "院内の他病棟からの転棟,家庭からの入院,他の病院・診療所の病棟からの転院,介護施設・福祉施設に入所中,院内で出生,その他";

/// 退院時転帰コード（コード表は暫定らしい）
Parameter DischargeDispositionSystem = "http://jpfhir.jp/fhir/Common/CodeSystem/discharge-disposition";

/// DischargeDispositionCodeの並びに対応する表示名がDischargeDispositionDisplay
Parameter DischargeDispositionCode = "1,3,4,5,6,7,9";

/// DischargeDispositionDisplayの並びに対応するコードがDischargeDispositionCode
Parameter DischargeDispositionDisplay = "傷病が治癒・軽快,傷病（白血病、潰瘍性大腸炎、クローン病等）が寛解,傷病が不変,傷病が憎悪,傷病による死亡,その他（検査入院、正常分娩および人間ドックを含む）";

Property Identifier As FHIRTemplate.DataType.Identifier;

Property ClassHistoryClass As FHIRTemplate.DataType.Coding;

Property ClassHistoryPeriod As FHIRTemplate.DataType.Period;

Property Period As FHIRTemplate.DataType.Period;

Property Length As FHIRTemplate.DataType.Duration;

Property ReasonCode As FHIRTemplate.DataType.CodeableConcept;

/// reasonCode.coding.0.systemが記入できる場合コードで。MEDIS：標準病名マスター病名交換用コードが例にある（urn:oid:1.2.392.200119.4.101.6）
/// Conditionリソースのuuidを入れる
Property DiagnosisCondition As %String;

/// Organizationリソースのuuidを入れる
Property HospitalizationOrigin As %String;

Property AdmitSource As FHIRTemplate.DataType.CodeableConcept;

Property DischargeDisposition As FHIRTemplate.DataType.CodeableConcept;

/// 固定値にしたもの
/// meta.profile/status/class以下/diagnosis.use.coding/diagnosis.rank
XData Template [ MimeType = application/json ]
{
{
    "resourceType": "#(..#ResourceType)#",
    "meta": {
        "profile": ["http://jpfhir.jp/fhir/eClinicalSummary/StructureDefinition/JP_Encounter_eClinicalSummary"]   
    },
    "identifier":["#(..Identifier(FHIRTemplate.DataType.Identifier))#"],        
    "status": "finished",
    "class": {
        "system": "http://terminology.hl7.org/CodeSystem/v3-ActCode",
        "code": "IMP",
        "display":"入院"
    },
    "classHistory":[
        {
            "class":"#(..ClassHistoryClass(FHIRTemplate.DataType.Coding))#",
            "period":"#(..ClassHistoryPeriod(FHIRTemplate.DataType.Period))#"
        }
    ],
    "period":"#(..Period(FHIRTemplate.DataType.Period))#",
    "length":"#(..Length(FHIRTemplate.DataType.Duration))#",
    "reasonCode": ["#(..ReasonCode(FHIRTemplate.DataType.CodeableConcept))#"],
    "diagnosis":[
        {
            "condition":{
                "reference":"urn:uuid:#(..DiagnosisCondition)#"
            },
            "use":{
                "coding":[
                    {
                        "system": "http://terminology.hl7.org/CodeSystem/diagnosisrole",
                        "code": "DD",
                        "display": "退院時診断"                        
                    }
                ]
            },
            "rank":1
        }
    ],
    "hospitalization":{
        "origin":{
            "reference":"urn:uuid:#(..HospitalizationOrigin)#"
        },
        "admitSource":"#(..AdmitSource(FHIRTemplate.DataType.CodeableConcept))#",
        "dischargeDisposition":"#(..DischargeDisposition(FHIRTemplate.DataType.CodeableConcept))#"
    }
}
}

}

Class FHIRTest.CompositionTest
{

/// 各リソース生成時にResourceId採番される
ClassMethod Test1()
{
    // Patient リソース
    set patient=..Patient()

    //Encounterリソース
    set encounter=..Encounter()

    //Organizationリソース
    set organization=..Organization()    

    //Practitionerリソース
    set practitioner=..Practitioner()

    //Conditionリソース
    set condition=..Condition(patient)

    //CarePlanリソース
    set careplan=..CarePlan()

    //MedicationRequestリソース
    set medicationrequest=..MedicationRequest()

    //AllergyIntoleranceリソース
    set allergyintolerance=..AllergyIntolerance()

    /*　リファレンスを設定する */ 

    /*
    Encounter referenceの設定
        Condision: DiagnosisCondition
        Organization: HospitalizationOrigin
    */
    set encounter.DiagnosisCondition=condition.ResourceId
    set encounter.HospitalizationOrigin=organization.ResourceId
    
    /*
    Condition reference の設定
        subject: Patientリソース
        encounter: Encounterリソース
        evidence: Encounterリソース
    */
    set condition.Patient=patient.ResourceId
    set condition.Encounter=encounter.ResourceId
    set condition.EvidenceDetail=encounter.ResourceId

    /*
    CarePlan referenceの設定
        subject: Patientリソース
        encounter: Encounterリソース
        author: Practitionerリソース
    */
    set careplan.Patient=patient.ResourceId
    set careplan.Encounter=encounter.ResourceId
    set careplan.Practitioner=practitioner.ResourceId

    /*
    MedicationRequest reference の設定
        subject: Patient リソース
    */
    set medicationrequest.Patient=patient.ResourceId

    /*
    AllertyIntolerance referenceの設定
    */
    set allergyintolerance.Patient=patient.ResourceId
    set allergyintolerance.Encounter=encounter.ResourceId

    //Compositionリソース
    set composition=..Composition()
    /*
    Composition reference の設定
        subject: Patientリソース
        encounter: Encounterリソース
        author : Practitionerリソース
        author : Organizationリソース
        残り構造情報のリソースたち
    */
    set composition.Patient=patient.ResourceId
    set composition.Encounter=encounter.ResourceId
    set composition.Practitioner=practitioner.ResourceId
    set composition.Organization=organization.ResourceId
    set composition.Condition=condition.ResourceId
    set composition.CarePlan=careplan.ResourceId
    set composition.MedicationRequest=medicationrequest.ResourceId
    set composition.AllergyIntolerance=allergyintolerance.ResourceId

    /*
    // bundleへの追加
    set bundle.Composition=composition
    set bundle.Patient=patient
    set bundle.Practitioner=practitioner
    set bundle.Organization=organization
    set bundle.Encounter=encounter
    set bundle.Condition=condition
    set bundle.CarePlan=careplan
    set bundle.MedicationRequest=medicationrequest
    set bundle.AllergyIntolerance=allergyintolerance

    set bundle.When=$ZDATETIMEH("2021-08-21",3)
    set bundle.PractitionerResourceId=practitioner.ResourceId

    set ret=bundle.OutputToFile("bundle.json")
    */
    if $$$ISOK(ret) {
        use 0 write "正常終了",!
    }else {
        use 0 write "エラー発生",!
        do $SYSTEM.OBJ.DisplayError(ret)
    }
}

ClassMethod Patient() As FHIRTemplate.Patient
{
    set patient=##class(FHIRTemplate.Patient).%New()
    set patient.PostalCode="185-0012"
    set patient.Address="国分寺市本町3-7-20-102"
    set patient.DOB=$zdh("1976-02-25")
    set patient.Gender=2
    set patient.MedInstCode="1311223" // 医療機関コード
    set patient.PatientId="P0101"
    set patient.LastName="飯島"
    set patient.FirstName="美穂子"
    set patient.LastNameKana="イイジマ"
    set patient.FirstNameKana="ミホコ"
    set patient.Phone="080-5644-6480"
    return patient
}

ClassMethod Encounter() As FHIRTemplate.Encounter
{
    set encounter=##class(FHIRTemplate.Encounter).%New()
    //Encounter.Identifier
    set encounter.Identifier=##class(FHIRTemplate.Examples.CommonIdentifier).GetById(12345678)
    //Encounter.classHistory.class
    set encounter.ClassHistoryClass=##class(FHIRTemplate.Examples.ActCode).GetByCode("IMP")
    //Encounter.classHisotry.period
    set encounter.ClassHistoryPeriod=##class(FHIRTemplate.DataType.Period).%New({"start":($zdh("2021-08-21",3)),"end":($zdh("2021-08-22",3))})
    //Encounter.period
    set encounter.Period=##class(FHIRTemplate.DataType.Period).%New({"start":($zdh("2021-09-01",3)),"end":($zdh("2021-09-18",3))})
    //Encounter.Length
    set encounter.Length=##class(FHIRTemplate.DataType.Duration).%New({"code":"d","unit":"日","value":7})
    //Encounter.reasonCode
    do encounter.ReasonCode.Insert(##class(FHIRTemplate.Examples.ByomeiCode).GetByCode("B0EF"))
    // Encounter.diagnosis
    set diagnosis=##class(FHIRTemplate.Encounter.diagnosis).%New()
    do diagnosis.role.Insert(##class(FHIRTemplate.Examples.DiagnosisRoleCode).GetByCode("DD"))
    set diagnosis.rank=1
    do encounter.Diagnosis.Insert(diagnosis)

    //Encounter.hospitalization.admitSource
    set encounter.AdmitSource=##class(FHIRTemplate.Examples.AdmitSourceCode).GetByCode(1)
    //Encounter.hospitalizationdischargeDisposition
    set encounter.DischargeDisposition=##class(FHIRTemplate.Examples.DischargeCode).GetByCode(1)
    return encounter
}

ClassMethod Organization() As FHIRTemplate.Organization
{
    set organization=##class(FHIRTemplate.Organization).%New()
    set organization.TextDiv="<div xmlns='http://www.w3.org/1999/xhtml'>テスト組織です</div>"
    set organization.PrefNum="13" //都道府県番号らしい
    set organization.TensuCode="1"
    set organization.HokenNum7="1234567"
    set organization.HokenNum10="1234567890"
    set organization.HospitalName="厚生労働省第一病院"
    set organization.Phone="0120-012-0123"
    set organization.AddressText="神奈川県横浜市港区１－２－３"
    set organization.AddressZip="111-2222"
    return organization
}

ClassMethod Practitioner() As FHIRTemplate.Practitioner
{
    set practitioner=##class(FHIRTemplate.Practitioner).%New()
    set practitioner.FirstName="花子"
    set practitioner.LastName="神奈川"
    set practitioner.FirstNameKana="ハナコ"
    set practitioner.LastNameKana="カナガワ"
    return practitioner
}

ClassMethod Condition(patient As FHIRTemplate.Patient) As FHIRTemplate.Condition
{
    set condition=##class(FHIRTemplate.Condition).%New()
    set condition.TextDiv="<div xmlns='http://www.w3.org/1999/xhtml'>こんな状況でした</div>"
    set condition.PatientStatusValue="1311234567-2020-00123456"
    set clinicalstatus=##class(FHIRTemplate.DataType.CodeableConcept).%New()
    set clinicalstatus.system=condition.#ClinicalStatusSystem
    set clinicalstatus.code=$piece(condition.#ClinicalStatusCode,",",1)  //active
    set clinicalstatus.display=$piece(condition.#ClinicalStatusDisplay,",",1)  //このディスプレイでいいのか不明
    set condition.ClinicalStatus=clinicalstatus
    set verificationStatus=##class(FHIRTemplate.DataType.CodeableConcept).%New()
    set verificationStatus.system=condition.#VerificationStatusSystem
    set verificationStatus.code=$piece(condition.#VerificationStatusCode,",",2) //provisional
    set verificationStatus.display=$piece(condition.#VerificationStatusDisplay,",",2) //このディスプレイでいいのか不明

    set condition.Code=##class(FHIRTemplate.DataType.CodeableConcept).GetByCode("B0EF")
    set bodysite=##class(FHIRTemplate.DataType.CodeableConcept).%New()
    set bodysite.system="urn:oid:1.2.392.200119.4.201.5"
    set bodysite.code="1244"
    set bodysite.display="腹部"
    set condition.BodySite=bodysite
    set condition.PatientDisplayName=patient.LastName_patient.FirstName
    set age=##class(FHIRTemplate.DataType.Age).%New()
    set age.value=10
    set age.unit="歳"
    set age.code="a"
    set condition.Age=age
    set condition.RecordedDate="2020-09-01"
    return condition
}

ClassMethod Composition() As FHIRTemplate.CompositionDischargeSummary
{
    set composition=##class(FHIRTemplate.CompositionDischargeSummary).%New()
    set composition.DocVersionNum="1.0"
    set composition.IdentifierValue="1311234567-2020-00123456"
    set composition.CreationDate=$ZDATETIMEH("2020-09-18",3)
    return composition
}

ClassMethod CarePlan() As FHIRTemplate.CarePlan
{
    set careplan=##class(FHIRTemplate.CarePlan).%New()
    set careplan.TextDiv="<div xmlns='http://www.w3.org/1999/xhtml'>こんな計画です</div>"
    set careplan.IdentifierValue="1311234567-2020-00123456"
    set careplan.Status="active"
    set careplan.Intent="plan"
    set category=##class(FHIRTemplate.DataType.CodeableConcept).%New()
    set category.system=careplan.#CategorySystem
    set category.code="736285004"
    set category.display=careplan.#CategoryDisplay
    set careplan.Category=category
    set careplan.Description="2020/9/30に循環器内科Dr笹田外来受診、その後○×クリニックへ逆紹介の予定"
    //set period=##class(FHIRTemplate.DataType.Period).%New()
    //set period.start="2020-09-18T15:25:16+09:00"
    //set careplan.Period=period
    set careplan.CreationTime=$ZDATETIMEH("2020-09-15",3)
    return careplan
}

ClassMethod MedicationRequest() As FHIRTemplate.MedicationRequest
{
    set medicationrequest=##class(FHIRTemplate.MedicationRequest).%New()
    set medicationrequest.TextDiv="<div xmlns='http://www.w3.org/1999/xhtml'>退院後に飲んでもらうお薬です</div>"
    set medicationrequest.AuthoredOn=$ZDATETIMEH("2020-09-15",3)
    set MedicationCodeableConcept=##class(FHIRTemplate.DataType.CodeableConcept).%New()
    //Hot9のコードを入れる
    set MedicationCodeableConcept.system="urn:oid:1.2.392.200119.4.403.1"
    set MedicationCodeableConcept.code="103831601"
    set MedicationCodeableConcept.display="カルボシステイン錠２５０ｍｇ"
    set medicationrequest.MedicationCodeableConcept=MedicationCodeableConcept
    set DosageInstructionPeriod=##class(FHIRTemplate.DataType.PeriodNoEnd).%New()
    set DosageInstructionPeriod.start="2020-09-21"
    set medicationrequest.DosageInstructionPeriod=DosageInstructionPeriod
    set DosageInstructionDuration=##class(FHIRTemplate.DataType.Duration).%New()
    set DosageInstructionDuration.value=7
    set DosageInstructionDuration.unit="日"
    set DosageInstructionDuration.code="d"
    set medicationrequest.DosageInstructionDuration=DosageInstructionDuration
    set medicationrequest.TimingEvent="2020-09-15"
    set TimingRepetDuration=##class(FHIRTemplate.DataType.Duration).%New()
    set TimingRepetDuration.value=7
    set TimingRepetDuration.unit="日"
    set TimingRepetDuration.code="d"
    set medicationrequest.TimingRepetDuration=TimingRepetDuration
    set TimingCode=##class(FHIRTemplate.DataType.CodeableConcept).%New()
    set TimingCode.system=medicationrequest.#TimingCodeSystem
    set TimingCode.code="1012040400000000"
    set TimingCode.display="内服・経口・１日２回朝夕食後"
    set medicationrequest.TimingCode=TimingCode
    set Route=##class(FHIRTemplate.DataType.CodeableConcept).%New()
    set Route.system=medicationrequest.#RouteSystem
    set Route.code="PO"
    set Route.display="経口"
    set medicationrequest.Route=Route
    set method=##class(FHIRTemplate.DataType.CodeableConcept).%New()
    set method.system=medicationrequest.#MethodSystem
    set method.code=1
    set method.display="内服"
    set DoseAndRateType=##class(FHIRTemplate.DataType.CodeableConcept).%New()
    set DoseAndRateType.system=medicationrequest.#DoseAndRateTypeSystem
    set DoseAndRateType.code="1"
    set DoseAndRateType.display="製剤量"
    set medicationrequest.DoseAndRateType=DoseAndRateType
    set DoseQuantity=##class(FHIRTemplate.DataType.SimpleQuantity).%New()
    set DoseQuantity.value=2
    set DoseQuantity.unit="錠"
    set DoseQuantity.system="urn:oid:1.2.392.100495.20.2.101"
    set DoseQuantity.code="TAB"
    set medicationrequest.DoseQuantity=DoseQuantity
    set RateRatio=##class(FHIRTemplate.DataType.Quantity).%New()
    set RateRatio.value=4
    set RateRatio.unit="錠"
    set RateRatio.system="urn:oid:1.2.392.100495.20.2.101"
    set RateRatio.code="TAB"
    set medicationrequest.RateRatio=RateRatio
    set Denominator=##class(FHIRTemplate.DataType.Quantity).%New()
    set Denominator.value=1
    set Denominator.unit="日"
    set Denominator.system="http://unitsofmeasure.org"
    set Denominator.code="d"
    set medicationrequest.Denominator=Denominator
    set DispenseRequestValueCodeableConcept=##class(FHIRTemplate.DataType.CodeableConcept).%New()
    set DispenseRequestValueCodeableConcept.system=medicationrequest.#DispenseRequestValueCodeableConceptSystem
    set DispenseRequestValueCodeableConcept.code="c"
    set DispenseRequestValueCodeableConcept.display="粉砕指示"
    set medicationrequest.DispenseRequestValueCodeableConcept=DispenseRequestValueCodeableConcept
    set DispenseRequestQuantity=##class(FHIRTemplate.DataType.SimpleQuantity).%New()
    set DispenseRequestQuantity.value=28
    set DispenseRequestQuantity.unit="錠"
    set DispenseRequestQuantity.system=medicationrequest.#DispenceRequestQuantitySystem
    set DispenseRequestQuantity.code="TAB"
    set medicationrequest.DispenseRequestQuantity=DispenseRequestQuantity
    set ExpectedSupplyDuration=##class(FHIRTemplate.DataType.Duration).%New()
    set ExpectedSupplyDuration.value=7
    set ExpectedSupplyDuration.unit="日"
    set ExpectedSupplyDuration.system="http://unitsofmeasure.org"
    set ExpectedSupplyDuration.code="d"
    set medicationrequest.ExpectedSupplyDuration=ExpectedSupplyDuration
    return medicationrequest
}

ClassMethod AllergyIntolerance() As FHIRTemplate.AllergyIntolerance
{
    set allergy=##class(FHIRTemplate.AllergyIntolerance).%New()
    set allergy.TextDiv="<div xmlns='http://www.w3.org/1999/xhtml'>申告されたアレルギーです</div>"
    set allergy.IdentifierValue="1311234567-2020-00123456"
    set ClinicalStatus=##class(FHIRTemplate.DataType.CodeableConcept).%New()
    set ClinicalStatus.system="http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical"
    set ClinicalStatus.code=$piece(allergy.#ClinicalStatusCode,",",1)
    set ClinicalStatus.display=$piece(allergy.#ClinicalStatusDisplay,",",1)
    set allergy.ClinicalStatus=ClinicalStatus
    set VerificationStatus=##class(FHIRTemplate.DataType.CodeableConcept).%New()
    set VerificationStatus.system="http://terminology.hl7.org/CodeSystem/allergyintolerance-verification"
    set VerificationStatus.code=$piece(allergy.#VerificationStatusCode,",",1)
    set VerificationStatus.display=$piece(allergy.#VerificationStatusDisplay,",",1)
    set allergy.VerificationStatus=VerificationStatus
    set allergy.Type="allergy"
    set allergy.Category="food"
    set allergy.Criticality="high"
    set Code=##class(FHIRTemplate.DataType.CodeableConcept).%New()
    set Code.system="http://jpfhir.jp/fhir/AllergyIntolerance/CodeSystem/allergy-substance"
    set Code.code="J7F7111190"
    set Code.display="さば類"
    set allergy.Code=Code
    return allergy
}

}

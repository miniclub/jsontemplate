Class FHIRTemplate.Examples.CommonIdentifier Extends FHIRTemplate.DataType.Identifier
{

/// IDからIdentifierオブジェクトを取得
ClassMethod GetById(code As %String) As CommonIdentifier
{
    set year=$piece($zdate($horolog,3),"-")
    set medinstcode=##class(FHIRTemplate.Examples.Config).GetConfigData("MedicalInstituteCode")
    set obj=..%New()
    set obj.system="http://jpfhir.jp/fhir/Common/CodeSystem/resourceInstance-identifier"
    set obj.value=medinstcode_"-"_year_"-"_$translate($justify(+code,8)," ","0")
    quit obj
}

}

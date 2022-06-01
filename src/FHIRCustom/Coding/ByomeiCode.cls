Class FHIRCustom.Coding.ByomeiCode Extends FHIRTemplate.DataType.CodingBase
{

Parameter CodeSystem = "urn:oid:1.2.392.200119.4.101.6";

/// コードからインスタンスを取得
ClassMethod GetByCode(code As %String) As FHIRTemplate.DataType.CodingBase
{
        set display=""
        &SQL(SELECT Name INTO :display FROM FHIRCustom_DB.ByomeiCode WHERE code = :code)
        if SQLCODE=0 {
                set obj=..%New()
                set obj.code=code
                set obj.display=display
                quit obj
        }
        quit ""
}

}

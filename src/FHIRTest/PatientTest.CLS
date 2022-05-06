Class FHIRTest.PatientTest
{

ClassMethod Test1()
{
    #dim obj as FHIRTemplate.Patient
    set obj=##class(FHIRTemplate.Patient).%New()
    set obj.PatientId="11122"
    set obj.LastName="皆本",obj.FirstName="稔彦"
    set obj.LastNameKana="ミナモト",obj.FirstNameKana="トシヒコ"
    set obj.DOB=$zdateh("1968-10-02",3)
    set obj.Gender=1
    set obj.Address="大阪府大阪市北区堂島2-1-31"
    set obj.PostalCode="5300003"
    set obj.Phone="06-4797-3388"
    set ret=obj.OutputToFile("c:\temp\patient.json")
    if $$$ISOK(ret) {
        use 0 write "正常終了",!
    }else {
        use 0 write "エラー発生",!
        do $SYSTEM.OBJ.DisplayError(ret)
    }
}

}

Class FHIRTest.BundleTest2
{

ClassMethod Test1()
{
    #dim obj as FHIRTemplate.Bundle
    set obj=##class(FHIRTemplate.Bundle2).%New()
    set obj.TimeStamp=$horolog

    #dim pobj as FHIRTemplate.Patient
    set pobj=##class(FHIRTemplate.Patient).%New()
    
    set pobj.PatientId="11122"
    set pobj.LastName="皆本",pobj.FirstName="稔彦"
    set pobj.LastNameKana="ミナモト",pobj.FirstNameKana="トシヒコ"
    set pobj.DOB=$zdateh("1968-10-02",3)
    set pobj.Gender=1
    set pobj.Address="大阪府大阪市北区堂島2-1-31"
    set pobj.PostalCode="5300003"
    set pobj.Phone="06-4797-3388"

    set obj.Patient=pobj

    #dim p1obj as FHIRTemplate.Practitioner
    set p1obj=##class(FHIRTemplate.Practitioner).%New()

    set p1obj.LastName="山田",p1obj.FirstName="太郎"
    set p1obj.LastNameKana="ヤマダ",p1obj.FirstNameKana="タロウ"

    do obj.Practitioner.Insert(p1obj)

    set p1obj=##class(FHIRTemplate.Practitioner).%New()

    set p1obj.LastName="山本",p1obj.FirstName="次郎"
    set p1obj.LastNameKana="ヤマモト",p1obj.FirstNameKana="ジロウ"

    do obj.Practitioner.Insert(p1obj)

    set ret=obj.OutputToFile("c:\temp\bundle-2.json")
    if $$$ISOK(ret) {
        use 0 write "正常終了",!
    }else {
        use 0 write "エラー発生",!
        do $SYSTEM.OBJ.DisplayError(ret)
    }
}

}

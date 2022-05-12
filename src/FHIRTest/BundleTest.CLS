Class FHIRTest.BundleTest
{

ClassMethod Test1()
{
    #dim obj as FHIRTemplate.Bundle
    set obj=##class(FHIRTemplate.Bundle).%New()
    set obj.TimeStamp=$horolog

    #dim cobj as FHIRTemplate.Composition
    set cobj=##class(FHIRTemplate.Composition).%New()
    set cobj.type={
        "system": "http://jpfhir.jp/fhir/Common/CodeSystem/doc-typecodes"
        ,"code": "18842-5"
        ,"display":"退院時サマリー" }
    set cobj.status=1 // final

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

    set obj.Composition=cobj
    set obj.Patient=pobj

    set ret=obj.OutputToFile("c:\temp\bundle.json")
    if $$$ISOK(ret) {
        use 0 write "正常終了",!
    }else {
        use 0 write "エラー発生",!
        do $SYSTEM.OBJ.DisplayError(ret)
    }
}

}

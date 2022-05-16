Class FHIRTemplate.Type.TimeStamp Extends %DataType [ ClientDataType = TIMESTAMP, OdbcType = TIMESTAMP, SqlCategory = TIMESTAMP ]
{

Parameter FORMAT = 1;

ClassMethod LogicalToDisplay(%val) As %String [ CodeMode = generator, ServerOnly = 1 ]
{
	If ($$$getClassType(%class)=$$$cCLASSCLASSTYPEDATATYPE) || $$$comMemberKeyGet(%class,$$$cCLASSparameter,"XMLENABLED",$$$cPARAMdefault) || $$$comMemberKeyGet(%class,$$$cCLASSparameter,"%JSONENABLED",$$$cPARAMdefault) {
        $$$GENERATE(" quit $translate($zdatetime(%val,3),"" "",""T"")_"".""_($ztimezone\60*100+($ztimezone#60)*(-1))_""Z""")
    }
}

}

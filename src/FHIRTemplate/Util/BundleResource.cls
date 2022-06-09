Class FHIRTemplate.Util.BundleResource
{

Property Resource [ MultiDimensional ];

Method AddResource(resource As FHIRTemplate.Resource) As %Status
{
        set resourceid = resource.ResourceId
        if '$data(..Resource("rindex",resourceid)) {
            set rid=$increment(..Resource("resource"))
            set ..Resource("resource",rid)=resource
            set ..Resource("rindex",resourceid)=rid
        }
        quit $$$OK
}

Method ExportResources(resources As %ListOfObjects) As %Status
{
        set rid="" for {
            set rid=$order(..Resource("resource",rid),1,res)
            quit:rid=""

            do resources.Insert(res)
        }
        quit $$$OK
}

}

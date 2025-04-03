global class PicklistPopulationExample implements vlocity_cmt.VlocityOpenInterface {
    public Boolean invokeMethod(String methodName, Map < String, Object > input, Map < String, Object > outMap, Map < String, Object > options) {
        if (methodName.equals('PopulateDependentPicklist')) {
            PopulateDependentPicklist(input, outMap, options);
        }
        else if (methodName.equals('PopulatePicklist')) {
            PopulatePicklist(input, outMap, options);
        }
        return true;
    }
    
    // add the map under options to populate the picklist
    public void PopulatePicklist(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options)
    {
        // hard coded list, these options could be results from a remote call/3rd party api
        List<Map<String,String>> picklist = new List<Map<String, String>>();

        Map<String, String> picklistOption = new Map<String, String>();
        picklistOption.put('name', 'Licensing & Permitting');
        picklistOption.put('value','Licensing & Permitting');
        picklist.add(picklistOption);
            
        picklistOption = new Map<String, String>();
        picklistOption.put('name', 'Contract');
        picklistOption.put('value','Contract');
        picklist.add(picklistOption);
        
        outMap.put('options', picklist);
    }
    
    // add the map of all possible picklists that will be chosen given the "controllingElement"
    // note that the "controllingElement" is an element name that gets passed in from omniscript
    public void PopulateDependentPicklist(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options)
    {
        // Map of List where the Key is the Potential Values in the Other Picklist
        Map<String, List<Map<String, String>>> dependency = new Map<String, List<Map<String, String>>>();
                
        List<String> controlValList = new List<String>();
        // note that these are listed (above)
        controlValList.add('Licensing & Permitting');
        controlValList.add('Contract');

        // generating arbitrary entries for each of the above keys
        for(Integer i=0; i<2; i++)
        {
            List<Map<String, String>> optionList = new List<Map<String, String>>();

            for(Integer j=0; j<2; j++) {
                Map<String, String> tempMap = new Map<String, String>();
                tempMap.put('name', controlValList[i] + ' Child'); 
                tempMap.put('value', controlValList[i] + ' ChildV'); 

                optionList.add(tempMap);
            }
            dependency.put(controlValList[i], optionList);
        }
        
        outMap.put('dependency',dependency);
   }
    
    
}
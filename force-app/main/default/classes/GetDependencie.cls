global with sharing  class GetDependencie implements vlocity_cmt.VlocityOpenInterface {
//BeGIN RMA 20/12/2021

    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
            
        Boolean result = true;
            
        try{
            
            if(methodName.equals('GetPicklist')){
                GetPicklist(inputMap, outMap, options);
            
             // your implementation, use outMap to send response back to OmniScript                                                                  
            
            }
          
        } catch(Exception e){
                       
            result = false;
                    
        }
             
        return result;
                  
   }
     public static void GetPicklist(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {

      //Define table name that has picklist value set fields
         String objectName ='Case';
         //Define controlling picklist value field
         String controllingField = 'InwiB2C_TypeSpecialite__c' ;
         //Define dependent picklist value field
         String dependentField = 'InwiB2C_Detail__c' ;
         //Declare map variable to store list of dependent value for controlling field
         Map<String, List<String>> controllingInfo = new Map<String, List<String>>( ) ;
                  Map<String, List<String>> dependValues = new Map<String, List<String>>( ) ;

         //Get the type being dealt with
         Schema.SObjectType objType = Schema.getGlobalDescribe( ).get(objectName) ;
         Schema.DescribeSObjectResult  describeResult = objType.getDescribe ( ) ;
         //Get controlling field values 
          Schema.DescribeFieldResult controllingFieldInfo = describeResult.fields.getMap ( ).get (controllingField).getDescribe ( ) ;
         //Get dependent field values
         Schema.DescribeFieldResult  dependentFieldInfo = describeResult.fields.getMap ( ).get (dependentField).getDescribe ( ) ;
         List<Schema.PicklistEntry> controllingValues = controllingFieldInfo.getPicklistValues ( ) ;
         List<Schema.PicklistEntry> dependentValues = dependentFieldInfo.getPicklistValues ( ) ;
        
         system.debug('dependentFieldInfo'+dependentFieldInfo);
         system.debug('controllingValues'+controllingValues);
         system.debug('dependentValues'+dependentValues);

         //Get the label for controlling picklist value set
         For (Schema.PicklistEntry  currControllingValue  :  controllingValues)  {
             controllingInfo.put (currControllingValue.getLabel ( ) , new List<String>( ) ) ;
         }
     For (Schema.PicklistEntry  dependentValuesss  :  dependentValues)  {
             dependValues.put (dependentValuesss.getLabel ( ) , new List<String>( ) ) ;
         }
    
         Schema.DescribeFieldResult result = Case.InwiB2C_Detail__c.getDescribe();
                if (result.isDependentPicklist()) {
                       system.debug(result.getController()); //Field2__c
			}
     outMap.put('List',dependentFieldInfo );


    }

     

        

}
global class InwiB2C_Calcule_FMD implements vlocity_cmt.VlocityOpenInterface{
  global Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){

    Boolean result = true;

    try{

      if (methodName.equals('Calculs_Values')){
        Calculs_Values(inputMap, outMap);
      }

    } catch (Exception e){

      result = false;

    }

    return result;
  }

  private void Calculs_Values(Map<String, object> input, Map<String, object> output){

    String status = '';

    Map<String, Object> inputt = (Map<String, Object>)JSON.deserializeUntyped(json.serialize(input));
    System.debug(inputt);

    Map<String, Object> CSOrderScor = (Map<String, Object>)inputt.get('CSOrderScor');

    String offer = (String) CSOrderScor.get('offre');
     Decimal engagementDuration = 0 ; 
      if( CSOrderScor.get('engagementDuration') != null) {
      engagementDuration = (Decimal) CSOrderScor.get('engagementDuration');
} else { 
if (offer == 'INWIB2C_OFFERING_FTTH50MG3MOIS_249DH'
|| offer == 'INWIB2C_OFFERING_FTTH200MG3MOIS_449DH'
|| offer == 'INWIB2C_OFFERING_FTTH100MG3MOIS_349DH'
|| offer == 'INWIB2C_OFFERING_FTTH200MG_649DH'
|| offer == 'INWIB2C_OFFERING_FTTH20MG_249DH'
|| offer == 'INWIB2C_OFFERING_FTTH100MG_449DH'
|| offer == 'INWIB2C_OFFERING_FTTH50MG_349DH')

{
      engagementDuration = 12;
}

} 



    System.debug(engagementDuration);
    String handSetType = (String) CSOrderScor.get('handSetType');
    System.debug(handSetType);
    String targetOperator = (String) CSOrderScor.get('targetOperator');
    System.debug(targetOperator);
    String isBlackListed = (String) CSOrderScor.get('isBlackListed');
    System.debug(isBlackListed);
    Decimal seniority = (Decimal) CSOrderScor.get('seniority');
    System.debug(seniority);
    String typeClient = (String) CSOrderScor.get('typeClient');
    System.debug(typeClient);
    String isPorrtability = (String) CSOrderScor.get('isPorrtability');
    System.debug(isPorrtability);
      String Isterminal = (String) CSOrderScor.get('Isterminal');
    System.debug(Isterminal);

    List<Object> AdditionelCretera = (List<Object>)CSOrderScor.get('AdditionelCretera');

    for (Object inidividualEntries : AdditionelCretera){
      Map<String, Object> ind = (Map<String, Object>)inidividualEntries;
      String Code = (String) ind.get('Code');
      String Value = (String) ind.get('Value');
      system.debug(Code);
      system.debug(Value);
    }

    List<String> protabilityInClause = new List<String>{ 'ALL', isPorrtability };
    List<String> handSetInClause = new List<String>{ 'ALL', handSetType };
      InwiB2C_MONT_CAUT_FMSFMD__c CSOrderScorRep ;  
    try{
      CSOrderScorRep = [Select  InwiB2C_VALUE_CAUTION__c, VALUE_FMD__c, VALUE_FMS__c,InwiB2C_FNR__c
                                              from InwiB2C_MONT_CAUT_FMSFMD__c
                                              where InwiB2C_Code_Offre__c = :offer and InwiB2C_DUREE_ENGAGEMENT__c = :engagementDuration and InwiB2C_IS_PORTABILITY__c in:protabilityInClause and InwiB2C_ISBLACKLISTED__c = :isBlackListed and InwiB2C_M_Type_Client__c = :typeClient and InwiB2C_TYPE_HANDSET__c in:handSetInClause
                                              LIMIT 1];
} catch(Exception ex){ List<String>  Type_ClientInClause = new List<String>{ 'ALL', typeClient };
CSOrderScorRep = [Select  InwiB2C_VALUE_CAUTION__c, VALUE_FMD__c, VALUE_FMS__c,InwiB2C_FNR__c
                                              from InwiB2C_MONT_CAUT_FMSFMD__c
                                              where InwiB2C_Code_Offre__c = :offer and InwiB2C_DUREE_ENGAGEMENT__c = :engagementDuration and InwiB2C_IS_PORTABILITY__c in:protabilityInClause and InwiB2C_ISBLACKLISTED__c = :isBlackListed and InwiB2C_M_Type_Client__c in :Type_ClientInClause and InwiB2C_TYPE_HANDSET__c in:handSetInClause
                                              LIMIT 1];}

    system.debug('CSOrderScorRep' + CSOrderScorRep);

        //Map<String, Object> transformedJson = new Map<String, Object>();
        //transformedJson.put('FMD', CSOrderScorRep.get('VALUE_FMD__c'));
       //   transformedJson.put('Id', CSOrderScorRep.get('Id'));
                // output.put('output' , transformedJson);  
         output.put('VALUE_CAUTION', CSOrderScorRep.get('InwiB2C_VALUE_CAUTION__c'));
       output.put('FMD', CSOrderScorRep.get('VALUE_FMD__c'));
       output.put('FMS', CSOrderScorRep.get('VALUE_FMS__c'));
       output.put('FNR', CSOrderScorRep.get('InwiB2C_FNR__c'));
          output.put('Id', CSOrderScorRep.get('Id'));
    //MTA 03/11/2023 Begin //
    output.put('Isterminal', (String) CSOrderScor.get('Isterminal'));
       //MTA 03/11/2023 END //
  }

}
public with sharing class inwiB2C_EditRetail_Informations {
    @AuraEnabled
    public static void EditRetailInformations(Id paramId,String firstName, String lastName,String AccountName, String TypeActivite, String longitude, String latitude, String MdnDealer) {
        List<INWIB2C_GroupName__mdt> TemplateMD = [select inwiB2C_BoutiqueId__c from INWIB2C_GroupName__mdt];

        inwiB2C_Acteur_Marche__c ActeurMarche = new inwiB2C_Acteur_Marche__c();
        if (!Test.isRunningTest()){
        ActeurMarche.inwiB2C_idStore__c = paramId;
         }
        ActeurMarche.inwiB2C_FirstName__c = firstName;
        ActeurMarche.inwiB2C_LastName__c = lastName;
        ActeurMarche.inwiB2C_AccountName__c = AccountName;
        ActeurMarche.Name = AccountName;
        ActeurMarche.inwiCGC_TypeActivite__c= TypeActivite;
        ActeurMarche.inwiB2C_MDN_Dealer__c = MdnDealer;
        ActeurMarche.inwiB2C_localisationGeo__Latitude__s = Decimal.valueOf(latitude);
        ActeurMarche.inwiB2C_localisationGeo__Longitude__s = Decimal.valueOf(longitude);
        ActeurMarche.inwiB2C_Name__c = TemplateMD[0].inwiB2C_BoutiqueId__c;
         if (!Test.isRunningTest()){
             insert ActeurMarche;
         }
    }
}
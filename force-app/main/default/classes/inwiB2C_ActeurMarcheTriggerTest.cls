@isTest
public class inwiB2C_ActeurMarcheTriggerTest {
@isTest (SeeAllData=true)
    static void inwiB2C_ActeurMarcheTriggerTest(){
        Contact contact=new Contact();
        contact.FirstName = 'Test';
        contact.LastName = 'Test';
        insert contact;
        
        Account account=new Account();
        account.Name = 'Test' ;
        account.vlocity_cmt__PrimaryContactId__c= contact.Id;
        insert account ;
        
        Schema.RetailStore RS = new  Schema.RetailStore();
        RS.Name='Name';
        RS.PrimaryContactId=contact.Id;
        RS.AccountId=account.Id;
        insert RS;
        
        inwiB2C_Acteur_Marche__c AM= new inwiB2C_Acteur_Marche__c();
        AM.Name='Name';
        AM.inwiB2C_FirstName__c='Test';
        AM.inwiB2C_LastName__c='Test';
        AM.inwiB2C_AccountName__c='Test';
        AM.inwiB2C_MDN_Dealer__c='1234567891';
        AM.inwiCGC_TypeActivite__c='Grossiste';
        AM.inwiB2C_idStore__c =RS.Id;
        insert AM;
        AM.inwiB2C_Valide__c=true;
        AM.inwiB2C_Retail_Store__c=RS.Id;
        update AM;
    }
}
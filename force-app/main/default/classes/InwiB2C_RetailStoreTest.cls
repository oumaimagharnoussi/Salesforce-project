@isTest
public class InwiB2C_RetailStoreTest {
@isTest (SeeAllData=true)
    static void InwiB2C_RetailStoreTest(){
         Test.startTest(); 
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
        InwiB2C_RetailStore.RetailStoreRecord('firstName','lastName' ,'Name','Grossiste' ,'33.57856' ,'-7.63988' , '1234567891');
        InwiB2C_RetailStore.GetRetailStoreInformations(RS.Id);
    }
}
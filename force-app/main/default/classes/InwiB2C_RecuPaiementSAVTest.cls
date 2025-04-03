@isTest
public class InwiB2C_RecuPaiementSAVTest {
    
     @isTest
    static void testConstructor() {
        
       Account testAccount = new Account(Name = 'Test Account');
      insert testAccount;
         Order orderTest = new Order(
                inwiB2C_Statut__c = 'inwiB2C_Activation',
                EffectiveDate = Date.today().addDays(-1),
                inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification',
                inwiB2C_AncienModele__c = 'defective article example',
                Status = 'Draft',
                AccountId = testAccount.Id
            );

       insert orderTest;

        Test.startTest();

        PageReference pageRef = Page.inwiB2C_recu_paiement_terminal_SAV;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('orderid', orderTest.Id );

        InwiB2C_RecuPaiementSAV controller = new InwiB2C_RecuPaiementSAV();
        
        String result = InwiB2C_RecuPaiementSAV.trimLongString('defective article example', 10);
        System.assertEquals('defective ', result);


        Test.stopTest();

	}
}
@isTest
public class InwiB2C_BatchCancelOrderVenteCreditTest {
    @testSetup
    static void setupTestData() {

        Account testPartner = new Account(
            Name = 'Test Partner',
            inwib2c_CodePartenaire__c = 'code'
        );
        insert testPartner;
        
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;  

        Order testOrder = new Order(
                Status = 'Draft',
                EffectiveDate = Date.today().addDays(-10),
                inwiB2C_Statut__c = 'inwiB2C_EnCours',
                inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition',
                inwib2c_ModeDePaiement__c = 'inwiB2C_Vente_credit',
                inwib2c_Partenaire__r = testPartner,
            	AccountId =testAccount.Id
            );      
        insert testOrder;
        
        Test.setCreatedDate(testOrder.Id, DateTime.newInstance(2024,10,19));
    }

    @isTest
    static void testBatchExecution() {
        Test.startTest();
        
        InwiB2C_BatchCancelOrderVenteCredit batch = new InwiB2C_BatchCancelOrderVenteCredit();
        Id batchProcessId = Database.executeBatch(batch, 200);

        Test.stopTest();
                
         List<EventBusSubscriber> eventSubscribers = [
            SELECT Name, Position, Retries, LastError, Status 
            FROM EventBusSubscriber 
            WHERE Topic = 'inwiB2C_CancelOrdersBatchEvent__e' 
              AND Type = 'ApexTrigger'
        ];
        
        System.assert(!eventSubscribers.isEmpty());
        System.assertEquals('Running', eventSubscribers[0].Status);
        System.assert(eventSubscribers[0].Position > 0);

    }
}
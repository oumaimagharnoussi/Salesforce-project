@isTest
private class InwiB2C_SubmitCmdWithoutPOBatch_Test {

    @isTest
    static void testStart() {
        
        Test.startTest();
        InwiB2C_SubmitCmdWithoutPOBatch batch = new InwiB2C_SubmitCmdWithoutPOBatch();
        Iterable<SObject> scope = batch.start(null);
        Test.stopTest();

    }
   
    @isTest
    static void testExecute() {
        
        Account testAccount = new Account();
        testAccount.Name = 'Test Account';
        insert testAccount;
        

        Product2 prod = new Product2(Name = 'Laptop X200', Family = 'Hardware', ProductCode = 'INWIB2C_OFFERING_SIM');
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        Pricebook2 customPB = new Pricebook2(Name = 'Custom Pricebook', isActive = true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry(
            Pricebook2Id = customPB.Id, Product2Id = prod.Id,
            UnitPrice = 12000, IsActive = true);
        insert customPrice;
        

        Order neworder = new Order(
            Pricebook2Id = customPB.Id,
            inwiB2C_Statut__c = 'inwiB2C_Activation',
            EffectiveDate = Date.today().addDays(-1),
            inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification',
            Status = 'Draft',
            AccountId = testAccount.Id
        );
        insert neworder;


        Test.startTest();
        InwiB2C_SubmitCmdWithoutPOBatch batch = new InwiB2C_SubmitCmdWithoutPOBatch();
        List<Order> scope = new List<Order>{neworder};
        batch.execute(null, scope);
        Test.stopTest();
       
    }
   
    @isTest
    static void testFinish() {

        Test.startTest();
        InwiB2C_SubmitCmdWithoutPOBatch batch = new InwiB2C_SubmitCmdWithoutPOBatch();
        batch.finish(null);
        Test.stopTest();
       
    }
}
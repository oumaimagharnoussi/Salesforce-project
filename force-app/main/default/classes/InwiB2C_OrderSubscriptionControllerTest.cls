@isTest
private class InwiB2C_OrderSubscriptionControllerTest {

    @isTest
    static void testGetAllOrders() {
        // Création de données de test : Subscription
        vlocity_cmt__Subscription__c testSubscription = new vlocity_cmt__Subscription__c(
          vlocity_cmt__SubscriptionNumber__c='212611223373',Inwib2c_Num_ro_de_la_ligne__c='212611223373',Name='TEST5',inwiB2C_Statut__c='InwiB2C_Active',vlocity_cmt__Status__c='Active'
        );
        insert testSubscription;
        
        // Création de données de test : Orders
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Order order1 = new Order(
            AccountId = testAccount.Id,
            InwiB2C_Type_Offer__c = 'FTTH',
            Status = 'Draft',
            EffectiveDate = Date.today()
        );
        insert order1;
        
        Order order2 = new Order(
            AccountId = testAccount.Id,
            InwiB2C_Type_Offer__c = 'ADSL',
            Status = 'Draft',
            EffectiveDate = Date.today()
        );
        insert order2;
        
        Order order3 = new Order(
            AccountId = testAccount.Id,
            InwiB2C_Type_Offer__c = 'idar duo',
            Status = 'Draft',
            EffectiveDate = Date.today()
        );
        insert order3;

        Order order4 = new Order(
            AccountId = testAccount.Id,
            InwiB2C_Type_Offer__c = 'Mobile Prépayé',
            Status = 'Draft',
            EffectiveDate = Date.today()
        );
        insert order4;
        
        // Création des enregistrements InwiB2C_OrderSubscription__c associés à la Subscription
        InwiB2C_OrderSubscription__c orderSubscription1 = new InwiB2C_OrderSubscription__c(
            inwiB2C_Subscription__c = testSubscription.Id,
            inwiB2C_Order__c = order1.Id
        );
        insert orderSubscription1;
        
        InwiB2C_OrderSubscription__c orderSubscription2 = new InwiB2C_OrderSubscription__c(
            inwiB2C_Subscription__c = testSubscription.Id,
            inwiB2C_Order__c = order2.Id
        );
        insert orderSubscription2;
        
        InwiB2C_OrderSubscription__c orderSubscription3 = new InwiB2C_OrderSubscription__c(
            inwiB2C_Subscription__c = testSubscription.Id,
            inwiB2C_Order__c = order3.Id
        );
        insert orderSubscription3;

        InwiB2C_OrderSubscription__c orderSubscription4 = new InwiB2C_OrderSubscription__c(
            inwiB2C_Subscription__c = testSubscription.Id,
            inwiB2C_Order__c = order4.Id
        );
        insert orderSubscription4;
        
        // Appel de la méthode getAllOrders pour récupérer les commandes filtrées
        Test.startTest();
        List<InwiB2C_OrderSubscription__c> orderSubscriptions = InwiB2C_OrderSubscriptionController.getAllOrders(testSubscription.Id);
        Test.stopTest();

        // Vérification que le nombre d'enregistrements retournés est correct (devrait être 3)
        System.assertEquals(3, orderSubscriptions.size(), 'Le nombre de commandes retournées doit être 3.');

        // Vérification que les commandes retournées ont les bons types d'offres
        for (InwiB2C_OrderSubscription__c orderSub : orderSubscriptions) {
            System.assert(
                orderSub.inwiB2C_Order__r.InwiB2C_Type_Offer__c == 'idar duo' ||
                orderSub.inwiB2C_Order__r.InwiB2C_Type_Offer__c == 'FTTH' ||
                orderSub.inwiB2C_Order__r.InwiB2C_Type_Offer__c == 'ADSL',
                'Le type d\'offre de la commande doit être "idar duo", "FTTH" ou "ADSL".'
            );
        }
    }
}
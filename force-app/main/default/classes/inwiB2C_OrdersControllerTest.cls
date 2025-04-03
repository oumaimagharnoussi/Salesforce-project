@isTest
private class inwiB2C_OrdersControllerTest {

    @isTest
    static void testGetOrderList() {
        Contact cnt = new Contact(
            LastName = 'Test',
            FirstName = 'Test',
            InwiB2C_CIN__c = '123456',
            InwiB2C_Type_CIN__c = 'CNI'
        );
        try {
            insert cnt;
            System.debug('Contact inséré avec ID : ' + cnt.Id);
        } catch (Exception e) {
            System.debug('Erreur lors de l\'insertion du contact : ' + e.getMessage());
        }

        Account testAccount = new Account(
            Name = 'Test Account',
            vlocity_cmt__PersonContactId__c = cnt.id
        );
        try {
            insert testAccount;
            System.debug('Compte inséré avec ID : ' + testAccount.Id);
        } catch (Exception e) {
            System.debug('Erreur lors de l\'insertion du compte : ' + e.getMessage());
        }

        Order order1 = new Order(
            AccountId = testAccount.Id,
            InwiB2C_Type_Offer__c = 'FTTH',
            Status = 'Draft',
            EffectiveDate = Date.today()
        );
        try {
            insert order1;
            System.debug('Commande 1 insérée avec ID : ' + order1.Id);
        } catch (Exception e) {
            System.debug('Erreur lors de l\'insertion de la commande 1 : ' + e.getMessage());
        }

        Order order2 = new Order(
            AccountId = testAccount.Id,
            InwiB2C_Type_Offer__c = 'ADSL',
            Status = 'Draft',
            EffectiveDate = Date.today()
        );
        try {
            insert order2;
            System.debug('Commande 2 insérée avec ID : ' + order2.Id);
        } catch (Exception e) {
            System.debug('Erreur lors de l\'insertion de la commande 2 : ' + e.getMessage());
        }

        Order order3 = new Order(
            AccountId = testAccount.Id,
            InwiB2C_Type_Offer__c = 'idar duo',
            Status = 'Draft',
            EffectiveDate = Date.today()
        );
        try {
            insert order3;
            System.debug('Commande 3 insérée avec ID : ' + order3.Id);
        } catch (Exception e) {
            System.debug('Erreur lors de l\'insertion de la commande 3 : ' + e.getMessage());
        }

        Order order4 = new Order(
            AccountId = testAccount.Id,
            InwiB2C_Type_Offer__c = 'Mobile Prépayé',
            Status = 'Draft',
            EffectiveDate = Date.today()
        );
        try {
            insert order4;
            System.debug('Commande 4 insérée avec ID : ' + order4.Id);
        } catch (Exception e) {
            System.debug('Erreur lors de l\'insertion de la commande 4 : ' + e.getMessage());
        }

        Test.startTest();
        List<Order> orders = inwiB2C_OrderController.getOrderList(testAccount.Id);
        Test.stopTest();

        System.debug('Nombre de commandes retournées : ' + orders.size());
        System.assertEquals(3, orders.size(), 'Le nombre de commandes retournées doit être 3.');

        for (Order o : orders) {
            System.debug('Vérification du type d\'offre pour la commande ID : ' + o.Id);
            System.assert(
                o.InwiB2C_Type_Offer__c == 'idar duo' ||
                o.InwiB2C_Type_Offer__c == 'FTTH' ||
                o.InwiB2C_Type_Offer__c == 'ADSL',
                'Le type d\'offre de la commande doit être "idar duo", "FTTH" ou "ADSL".'
            );
        }
    }
}
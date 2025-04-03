@isTest
public class InwiB2C_CreateCasePortaFixeTest {
    @isTest
    static void testInvokeMethod_createCasePortaFixe() {
        // Créer un compte fictif
        Account testAccount = new Account(
            Name = 'Test Account'
        );
        insert testAccount;
        
        // Créer un contact fictif et l'associer au compte
        Contact testContact = new Contact(
            LastName = 'HM',
            FirstName = 'AKSEL',
            AccountId = testAccount.Id
        );
        insert testContact;

        // Créer une commande fictive
        Order testOrder = new Order(
            AccountId = testAccount.Id,
            Status = 'Draft',
            EffectiveDate = Date.today()
        );
        insert testOrder;

        // Créer une souscription fictive
        vlocity_cmt__Subscription__c testSubscription = new vlocity_cmt__Subscription__c(
            Name = 'Test_Subscription',
            vlocity_cmt__SubscriptionNumber__c = 'SUB123456'
        );
        insert testSubscription;

        // Créer une souscription d'ordre fictive
        inwiB2C_OrderSubscription__c orderSubscription = new inwiB2C_OrderSubscription__c(
            inwiB2C_Order__c = testOrder.Id,
            inwiB2C_Subscription__c = testSubscription.Id
        );
        insert orderSubscription;

        // Préparer les métadonnées
        InwiB2C_GestionDeCasePortaFixe__mdt metaData = [
            SELECT Id, InwiB2C_Categorie__c, InwiB2C_Detail__c, Inwib2c_la_file_d_attente__c, InwiB2C_Type__c, InwiB2C_Type_de_specialite__c, InwiB2C_Description__c, InwiB2C_Subject__c
            FROM InwiB2C_GestionDeCasePortaFixe__mdt
            LIMIT 1
        ];

        // Préparer les entrées pour invokeMethod
        Map<String, Object> inputMap = new Map<String, Object>{
            'orderId' => testOrder.Id
        };
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Test.startTest();
        // Appeler la méthode invokeMethod
        InwiB2C_CreateCasePortaFixe portaFixe = new InwiB2C_CreateCasePortaFixe();
        Boolean result = portaFixe.invokeMethod('createCasePortaFixe', inputMap, outMap, options);
        Test.stopTest();

        // Vérifier le résultat
        System.assert(result, 'La méthode invokeMethod devrait retourner true.');
        System.assertNotEquals(null, outMap.get('caseId'), 'Le cas devrait être créé et l\'ID devrait être retourné dans outMap.');

        // Récupérer le cas créé pour vérifier ses détails
        Id caseId = (Id) outMap.get('caseId');

         Case createdCase = [SELECT Id, AccountId, ContactId, Status, Inwib2c_Cat_gorie__c, InwiB2C_Detail__c 
                    FROM Case 
                    WHERE Id = :caseId 
                    LIMIT 1];
        System.assertEquals(testAccount.Id, createdCase.AccountId, 'L\'ID du compte du cas doit correspondre au compte de test.');
        System.assertEquals('InwiB2C_Escalade', createdCase.Status, 'Le statut du cas doit être InwiB2C_Escalade.');
        System.assertEquals(metaData.InwiB2C_Categorie__c, createdCase.Inwib2c_Cat_gorie__c, 'La catégorie du cas doit correspondre aux métadonnées.');
    }
}
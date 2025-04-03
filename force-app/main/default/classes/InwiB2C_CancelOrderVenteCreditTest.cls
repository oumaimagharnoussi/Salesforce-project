@isTest
public class InwiB2C_CancelOrderVenteCreditTest {
    
    @testSetup
    static void setupTestData() {

        Account testPartner = new Account(
            Name = 'Test Partner',
            inwib2c_CodePartenaire__c = 'code'
        );
        insert testPartner;
        
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;  

        Product2 prod = new Product2(Name = 'Laptop X200', Family = 'Hardware', ProductCode='INWIB2C_OFFERING_TERMINAL',vlocity_cmt__Type__c= 'Postpaye');
        insert prod;    
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB; 
        
        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        Order testOrder = new Order(
            Pricebook2Id = customPB.Id,
                Status = 'Draft',
                EffectiveDate = Date.today().addDays(-10),
                inwiB2C_Statut__c = 'inwiB2C_EnCours',
                inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition',
                inwib2c_ModeDePaiement__c = 'inwiB2C_Vente_credit',
                inwib2c_Partenaire__r = testPartner,
            	AccountId =testAccount.Id
            );      
        insert testOrder;
        
        String JsonAttr = '{"INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIawQAG","attributeid__c":"a0X3L0000019UhZUAU","attributecategoryid__c":"a0W3L000003LbH0UAK","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_IMEI","attributeconfigurable__c":true,"attributedisplaysequence__c":"40","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"IMEI/ESN","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001JPdHUAW","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":"10C3AB05FC99"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4K000002LIawQAG","attributeid__c":"a0X3L0000019UhiUAE","attributecategoryid__c":"a0W3L000003LbH0UAK","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_MODELE","attributeconfigurable__c":true,"attributedisplaysequence__c":"55","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Modèle","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3L000001JPdJUAW","isrequired__c":true,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":"77000056826"},"$$AttributeDefinitionEnd$$":null}]}';
        OrderItem newOrderitem = new OrderItem(
                vlocity_cmt__Action__c = 'Add', 
                Product2Id = prod.Id, 
                vlocity_cmt__JSONAttribute__c = JsonAttr, 
                PriceBookEntryId=customPrice.Id, 
                OrderId=testOrder.Id, 
                Quantity=1, 
                UnitPrice=customPrice.UnitPrice, 
                ServiceDate=Date.Today());
            insert newOrderitem;
    
    }
    
      @isTest
    static void testTrigger() {
        Order order = [SELECT Id FROM Order LIMIT 1];

       InwiB2C_CancelOrderVenteCredit__e event = new InwiB2C_CancelOrderVenteCredit__e(inwiB2C_OrderId__c = order.Id);

        List<InwiB2C_CancelOrderVenteCredit__e> eventList = new List<InwiB2C_CancelOrderVenteCredit__e>();
        eventList.add(event);
        
        Test.startTest();
        Database.SaveResult[] srList = EventBus.publish(eventList);
        Test.stopTest();     
       
        System.assertEquals(1, srList.size());
        System.assert(srList[0].isSuccess());

    }

}
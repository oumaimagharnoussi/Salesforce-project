@isTest
public class InwiB2C_AssetGeneraSusFactTriggerTest {
    public static testMethod void testTrigger() {
         List<InwiB2C_generate_asset_susfact__e> listEvent = new List<InwiB2C_generate_asset_susfact__e>();
        
         InwiB2C_generate_asset_susfact__e event1 = new InwiB2C_generate_asset_susfact__e(InwiB2C_AssetId__c ='assetId',InwiB2C_Operation__c='createOrder');
         listEvent.add(event1);
        
         InwiB2C_generate_asset_susfact__e event2 = new InwiB2C_generate_asset_susfact__e(InwiB2C_orderId__c ='orderId',InwiB2C_Operation__c='checkout');
         listEvent.add(event2);
        
         InwiB2C_generate_asset_susfact__e event3 = new InwiB2C_generate_asset_susfact__e(InwiB2C_subscriptionId__c ='subId',InwiB2C_Operation__c='SuspensionFacturation');
         listEvent.add(event3);
        
        Test.startTest();
        EventBus.publish(listEvent);
        Test.stopTest();
    }
}
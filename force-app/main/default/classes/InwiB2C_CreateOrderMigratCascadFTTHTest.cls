@isTest
public class InwiB2C_CreateOrderMigratCascadFTTHTest {
    
        public static testMethod void CreateMigrationFTTHTriggerTest() {
        vlocity_cmt__Subscription__c NewSubscription = new vlocity_cmt__Subscription__c (Inwib2c_Num_ro_de_la_ligne__c='0112334422', inwiB2C_Statut__c='InwiB2C_Active',vlocity_cmt__SubscriptionNumber__c='0112334422');  
        Insert NewSubscription;
        InwiB2C_autoMigrateFixe_c__c NewMigrationRequest= new InwiB2C_autoMigrateFixe_c__c (InwiB2C_Subscription__c =NewSubscription.Id,InwiB2C_CodeOffreReference__c ='INWIB2C_OFFERING_FTTH20MG_249DH');  
        Insert NewMigrationRequest;
       
        List<InwiB2C_CreateOrderMigrationCascadFTTH__e> eventItems = new List<InwiB2C_CreateOrderMigrationCascadFTTH__e>();
        
        InwiB2C_CreateOrderMigrationCascadFTTH__e eventItem = new InwiB2C_CreateOrderMigrationCascadFTTH__e(inwiB2C_Step__c='Create',InwiB2C_Id_Automigration__c=NewMigrationRequest.id,InwiB2C_Offre_Code__c=NewMigrationRequest.InwiB2C_CodeOffreReference__c,InwiB2C_Subscription__c=NewMigrationRequest.InwiB2C_Subscription__c);     
        eventItems.add(eventItem) ;
        
            
         InwiB2C_CreateOrderMigrationCascadFTTH__e eventItem1 = new InwiB2C_CreateOrderMigrationCascadFTTH__e(inwiB2C_Step__c='validate',InwiB2C_Id_Automigration__c=NewMigrationRequest.id,InwiB2C_Offre_Code__c=NewMigrationRequest.InwiB2C_CodeOffreReference__c,InwiB2C_Subscription__c=NewMigrationRequest.InwiB2C_Subscription__c);     
         eventItems.add(eventItem1) ;
        
        Test.startTest();
        List<Database.SaveResult> results = EventBus.publish(eventItems);
        Test.stopTest();
        
        System.assertEquals(eventItem1.inwiB2C_step__c, 'validate');
        
    }

}
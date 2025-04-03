@isTest
public class InwiB2C_ExecTraitMigPrePostTriggerTest {
 public static testMethod void testExecuteSMO() {
       		InwiB2C_Trace_API__c trace = new InwiB2C_Trace_API__c();
            trace.InwiB2C_MDN__c='212648069781';
     		trace.InwiB2C_request_body__c= '{"CSExecuteMigPrePost":{"Ins":"a4k0C0000008jD3QAI","MDN":"212648078653","billingAccount":"0010C00000VXWibQAH","fmsReference":"1234567","fmsAmount":"214","Profil":"54234","productId":"86908","Code_offre":"INWIB2C_OFFERING_99DH_APL"},"CSOperationInfo":{"user":"SF","channel":"myInwi","uuid":"13412452345234"}}';  
            insert trace;
            
        inwiB2C_ExecuteMigrPrePostEvent__e EventItem = new inwiB2C_ExecuteMigrPrePostEvent__e(InwiB2C_TraceId__c=trace.Id);
        
        Test.startTest();
        Database.SaveResult results = EventBus.publish(EventItem);
        Test.stopTest();
        
 }
}
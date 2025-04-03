@isTest
public class inwiB2C_ManageIdarSuspensionBatchTest {
@isTest(SeeAllData=true)
        public static void inwiB2C_ManageIdarSuspensionBatchTest() {
            //List<vlocity_cmt__Subscription__c> subsc = [ SELECT Id From vlocity_cmt__Subscription__c  limit 1];
            //system.debug('testid'+subsc[0].Id);
            vlocity_cmt__Subscription__c subsc = new vlocity_cmt__Subscription__c ();
            subsc.Inwib2c_Num_ro_de_la_ligne__c = '212647858612';
            subsc.vlocity_cmt__SubscriptionNumber__c = '02i8M000000BIcZQAW';
            subsc.inwib2c_vip__c = false;
            subsc.inwiB2C_OptionIdentification__c = false;
            subsc.inwiB2C_managedInSF__c = true;
            subsc.InwiB2C_A_r_silier__c = false;
            subsc.Blacklist__c = false;
            insert subsc;
            
            
          
            

            InwiB2C_Order_SuspIdar__c lstRequest= new InwiB2C_Order_SuspIdar__c();            
            lstRequest.InwiB2C_Statut__c ='Ready';
            lstRequest.InwiB2C_SubscriptionIdar__c = subsc.Id;
            lstRequest.Name='test';
            insert lstRequest;
           
            Test.startTest();   
            inwiB2C_ManageIdarSuspensionBatch obj = new inwiB2C_ManageIdarSuspensionBatch();
            
            DataBase.executeBatch(obj);                
            Test.stopTest();
            //system.assertEquals('Warm', leads.Rating);
        
    }
}
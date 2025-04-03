public class InwiB2C_ExecuteMigrationCascadeFTTH implements Database.Batchable<sObject>, Database.AllowsCallouts{
    String RequestQuery ;
    
    
public Database.querylocator start(Database.BatchableContext BC){

    RequestQuery = 'select id , InwiB2C_Statut__c, InwiB2C_CodeOffreReference__c,InwiB2C_Subscription__c,InwiB2C_ExpectedDateMigration__c, CreatedDate, InwiB2C_order__c from InwiB2C_autoMigrateFixe_c__c where InwiB2C_ExpectedDateMigration__c <= TODAY and InwiB2C_Subscription__r.inwiB2C_Statut__c    in (\'InwiB2C_Active\') and InwiB2C_Statut__c = \'InwiB2C_Nouveau\' limit 200';
    
    return Database.getQueryLocator(RequestQuery) ;       
    }
public void execute(Database.BatchableContext BC, List<InwiB2C_autoMigrateFixe_c__c> scope){      
    
        system.debug('batch scope'+scope);  
        String RequestStatus = 'InwiB2C_Encours';
        List<InwiB2C_CreateOrderMigrationCascadFTTH__e> MigrationRequestEvent = new List<InwiB2C_CreateOrderMigrationCascadFTTH__e>();
    
        for (InwiB2C_autoMigrateFixe_c__c  requestitem: scope)
        {
        
         InwiB2C_CreateOrderMigrationCascadFTTH__e eventToCreate = new InwiB2C_CreateOrderMigrationCascadFTTH__e();
                eventToCreate.InwiB2C_Id_Automigration__c  = requestitem.Id;
                eventToCreate.InwiB2C_Offre_Code__c  = requestitem.InwiB2C_CodeOffreReference__c;
                eventToCreate.InwiB2C_Subscription__c  = requestitem.InwiB2C_Subscription__c;
                eventToCreate.inwiB2C_step__c   = 'Create';
                
                requestitem.InwiB2C_Statut__c=RequestStatus;
                MigrationRequestEvent.add(eventToCreate);	
        }
    
        List <Database.SaveResult> sresult = EventBus.publish(MigrationRequestEvent);
            update scope;

    }
public void finish(Database.BatchableContext BC){

        AsyncApexJob a = [Select a.TotalJobItems, a.Status, a.NumberOfErrors,
        a.JobType, a.JobItemsProcessed, a.ExtendedStatus, a.CreatedById,
        a.CompletedDate From AsyncApexJob a WHERE id = :BC.getJobId()];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        String[] email = new String[]{'projet-crm-sf@inwi.ma'};
        mail.setToAddresses(email);
        mail.setReplyTo('projet-crm-sf@inwi.ma');
        mail.setSenderDisplayName('Batch Processing');
        mail.setSubject('Batch Process Completed'+a.Status);
        mail.setPlainTextBody('The Batch Apex job processed '+ a.TotalJobItems+' batches with '+a.NumberOfErrors+' failures '+' Job Itemprocessed are '+a.JobItemsProcessed);
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

    }

    
}
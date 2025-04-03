public class BulkDataOperation implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext BC) {
        // Create new records to update
        List<InwiB2C_Demande_de_resiliation__c> recordsToUpdate = new List<InwiB2C_Demande_de_resiliation__c>();
        for (Integer i = 0; i < 5; i++) {
                InwiB2C_Demande_de_resiliation__c record = new InwiB2C_Demande_de_resiliation__c(
                    InwiB2C_Subscription__c = 'a4k3L0000003bCOQAY', 
                    InwiB2C_Account__c = '0013L00000bbFWLQA2'
                );
                recordsToUpdate.add(record);
            }
            insert recordsToUpdate;
            return Database.getQueryLocator([SELECT Id, InwiB2C_Statut_Resil__c, InwiB2C_Statut_R_tention__c FROM InwiB2C_Demande_de_resiliation__c WHERE Id IN :recordsToUpdate]);
        }

        public void execute(Database.BatchableContext BC, List<InwiB2C_Demande_de_resiliation__c> scope) {
            // Modify records in bulk
            for (InwiB2C_Demande_de_resiliation__c record : scope) {
                record.InwiB2C_Statut_Resil__c = 'Clôturée';
                record.InwiB2C_Statut_R_tention__c = 'Retenu';
            }
            
            
            update scope; // Update records in bulk
        }

        public void finish(Database.BatchableContext BC) {
            // Batch processing finished
        }
   

}
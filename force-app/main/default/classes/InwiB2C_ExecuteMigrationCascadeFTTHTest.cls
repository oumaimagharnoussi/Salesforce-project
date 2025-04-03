@isTest
private class InwiB2C_ExecuteMigrationCascadeFTTHTest {

    static testmethod void testBatchExecution() {
        // Créer des enregistrements de test InwiB2C_autoMigrateFixe_c__c
        List<InwiB2C_autoMigrateFixe_c__c> records = new List<InwiB2C_autoMigrateFixe_c__c>();
        //vlocity_cmt__Subscription__c newSubsc=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='212611223377',Inwib2c_Num_ro_de_la_ligne__c='212611223377',Name='TEST1',inwiB2C_LegacyStatus__c='ACTIVE',inwiB2C_Statut__c='InwiB2C_Active',vlocity_cmt__Status__c='Active', inwiB2C_managedInSF__c = true);
        //insert newSubsc;
        for(Integer i = 0; i < 2; i++) {
            InwiB2C_autoMigrateFixe_c__c record = new InwiB2C_autoMigrateFixe_c__c();
            // Remplir les champs nécessaires
            record.InwiB2C_Subscription__c = 'a4k3L0000005PLqQAM';
            //record.InwiB2C_Subscription__c = newSubsc.Id;
            record.InwiB2C_CodeOffreReference__c  = 'INWIB2C_OFFERING_FTTH20MG_249DH';
            record.InwiB2C_Statut__c = 'InwiB2C_Nouveau';
            record.InwiB2C_ExpectedDateMigration__c = Date.today();
            records.add(record);
        }
        insert records;

        Test.startTest();

        // Démarrer le batch
        Database.executeBatch(new InwiB2C_ExecuteMigrationCascadeFTTH());
        InwiB2C_MigrationCascadeFTTHSchedulable called = new InwiB2C_MigrationCascadeFTTHSchedulable();
        Datetime sysTime = System.now().addMinutes(5);
        String cronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        System.schedule('InwiB2C_ExecuteMigrationCascadeFTTH', cronExpression ,called);
        Test.stopTest();

    }
}
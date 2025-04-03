@isTest
public class InwiB2C_DeferredMigrationSched_Test {
	  
    public static testMethod void InwiB2C_DeferredMigrationSchedTest() {
        
        Test.startTest();   
        InwiB2C_DeferredMigrationBatch obj = new InwiB2C_DeferredMigrationBatch();
        List<InwiB2CScheduleBatch__mdt> timeSkip = [SELECT Id, DeveloperName, TimeMinSched__c FROM InwiB2CScheduleBatch__mdt WHERE DeveloperName ='SchedDeferredMigrationBatch' LIMIT 1];
        InwiB2C_DeferredMigrationSched_OnlyOne called = new InwiB2C_DeferredMigrationSched_OnlyOne();
        Datetime sysTime = System.now() + (timeSkip[0].TimeMinSched__c/1440);
        String CRON_EXP = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        String jobId = System.schedule('ScheduleApexClassTest', CRON_EXP, called);
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                              FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
    }
}
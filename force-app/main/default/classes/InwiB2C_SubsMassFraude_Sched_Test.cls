@isTest
public class InwiB2C_SubsMassFraude_Sched_Test {
 	
    public static testMethod void InwiB2C_SubsMassFraudeSchedTest() {
        
        Test.startTest();   
        InwiB2C_SubsMassProcessingBatch_Fraude obj = new InwiB2C_SubsMassProcessingBatch_Fraude();
        List<InwiB2CScheduleBatch__mdt> timeSkip = [SELECT Id, DeveloperName, TimeMinSched__c FROM InwiB2CScheduleBatch__mdt WHERE DeveloperName ='SchedSubsMassProcessingBatchFraude' LIMIT 1];      
        InwiB2C_SubsMassFraude_Sched_OnlyOne called = new InwiB2C_SubsMassFraude_Sched_OnlyOne();
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
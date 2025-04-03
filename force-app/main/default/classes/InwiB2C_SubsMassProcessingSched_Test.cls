@isTest
public class InwiB2C_SubsMassProcessingSched_Test {
    
	public static testMethod void InwiB2C_SubsMassProcessingSchedTest() {
        
        Test.startTest();   
        InwiB2C_SubsMassProcessingBatch obj = new InwiB2C_SubsMassProcessingBatch();
        List<InwiB2CScheduleBatch__mdt> timeSkip = [SELECT Id, DeveloperName, TimeMinSched__c FROM InwiB2CScheduleBatch__mdt WHERE DeveloperName ='SchedSubsMassProcessingBatch' LIMIT 1];
        InwiB2C_SubsMassProcessingSched_OnlyOne called = new InwiB2C_SubsMassProcessingSched_OnlyOne();
        Datetime sysTime = System.now() + timeSkip[0].TimeMinSched__c;
        String CRON_EXP = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        String jobId = System.schedule('InwiB2C_SubsMassProcessingSched_OnlyOneTest', CRON_EXP, called);
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                              FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
    }
}
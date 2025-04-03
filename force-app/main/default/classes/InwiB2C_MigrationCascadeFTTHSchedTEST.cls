@isTest
public class InwiB2C_MigrationCascadeFTTHSchedTEST {

    public static testMethod void InwiB2C_MigrationCascadeFTTHSchedulable_Test() {
        
        Test.startTest();   
        InwiB2C_ExecuteMigrationCascadeFTTH obj = new InwiB2C_ExecuteMigrationCascadeFTTH();
        InwiB2C_MigrationCascadeFTTHSchedulable called = new InwiB2C_MigrationCascadeFTTHSchedulable();
        Datetime sysTime = System.now().addMinutes(5);
        String CRON_EXP = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        String jobId = System.schedule('ScheduleApexClassTest', CRON_EXP, called);
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                              FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
    }
}
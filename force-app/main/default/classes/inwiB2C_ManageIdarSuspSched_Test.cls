@isTest
public class inwiB2C_ManageIdarSuspSched_Test {
    
    public static testMethod void inwiB2C_ManageIdarSuspSched_OnlyOne_Test() {
        
        Test.startTest();   
        inwiB2C_ManageIdarSuspensionBatch obj = new inwiB2C_ManageIdarSuspensionBatch();
        inwiB2C_ManageIdarSuspSched_OnlyOne called = new inwiB2C_ManageIdarSuspSched_OnlyOne();
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
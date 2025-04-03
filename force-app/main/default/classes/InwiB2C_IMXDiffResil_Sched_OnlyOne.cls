global with sharing class InwiB2C_IMXDiffResil_Sched_OnlyOne implements Schedulable{
    global void execute(SchedulableContext sc){
        
        InwiB2C_SubsMassProBatch_IMXDiffResil b = new InwiB2C_SubsMassProBatch_IMXDiffResil(); 
        database.executebatch(b);
        System.AbortJob(sc.getTriggerId());
    	rescheduleJob();
	}
       
    private void rescheduleJob(){
        List<InwiB2CScheduleBatch__mdt> timeSkip = [SELECT Id, DeveloperName, TimeMinSched__c FROM InwiB2CScheduleBatch__mdt WHERE DeveloperName = 'SchedIMXDiffResilBatch' LIMIT 1];
        InwiB2C_IMXDiffResil_Sched_OnlyOne scheduledJob = new InwiB2C_IMXDiffResil_Sched_OnlyOne();
        Datetime sysTime = System.now() + (timeSkip[0].TimeMinSched__c/1440);
		String cronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        System.schedule('InwiB2C_SubsMassProBatch_IMXDiffResil', cronExpression ,scheduledJob);
	}
}
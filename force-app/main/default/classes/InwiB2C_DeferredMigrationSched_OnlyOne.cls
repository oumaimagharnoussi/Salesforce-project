global class InwiB2C_DeferredMigrationSched_OnlyOne implements Schedulable{

     global void execute(SchedulableContext sc){
        
        InwiB2C_DeferredMigrationBatch b = new InwiB2C_DeferredMigrationBatch(); 
        database.executebatch(b);
        System.AbortJob(sc.getTriggerId());
    	rescheduleJob();
	}
       
    private void rescheduleJob(){
        
        List<InwiB2CScheduleBatch__mdt> timeSkip = [SELECT Id, DeveloperName, TimeMinSched__c FROM InwiB2CScheduleBatch__mdt WHERE DeveloperName ='SchedDeferredMigrationBatch' LIMIT 1];
        InwiB2C_DeferredMigrationSched_OnlyOne scheduledJob = new InwiB2C_DeferredMigrationSched_OnlyOne();
        Datetime sysTime = System.now().addMinutes(5);
		String cronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        System.schedule('InwiB2C_DeferredMigrationBatch', cronExpression ,scheduledJob);
	}
}
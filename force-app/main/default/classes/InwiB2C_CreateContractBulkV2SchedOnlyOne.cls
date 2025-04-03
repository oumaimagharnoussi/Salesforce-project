global class InwiB2C_CreateContractBulkV2SchedOnlyOne implements Schedulable{
    
    global void execute(SchedulableContext sc){

        InwiB2C_CreateContractBulkBatch b = new InwiB2C_CreateContractBulkBatch(); 
        database.executebatch(b);
        System.AbortJob(sc.getTriggerId());
    	rescheduleJob();
	}
   
    
    private void rescheduleJob(){
        List<InwiB2CScheduleBatch__mdt> timeSkip = [SELECT Id, DeveloperName, TimeMinSched__c FROM InwiB2CScheduleBatch__mdt WHERE DeveloperName = 'SchedCreateContractBulkV2' LIMIT 1];
        InwiB2C_CreateContractBulkSched_OnlyOne scheduledJob = new InwiB2C_CreateContractBulkSched_OnlyOne();
        Datetime sysTime = System.now() + (timeSkip[0].TimeMinSched__c/1440);
		String cronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        System.schedule('InwiB2C_CreateContractBulkSchedulable', cronExpression ,scheduledJob);
	}
}
global class InwiB2C_SubsMassProcessingSched_OnlyOne implements Schedulable{
    global void execute(SchedulableContext sc){

        InwiB2C_SubsMassProcessingBatch b = new InwiB2C_SubsMassProcessingBatch(); 
        database.executebatch(b);
        System.AbortJob(sc.getTriggerId());
    	rescheduleJob();
	}
   
    
    private void rescheduleJob()
	{
        List<InwiB2CScheduleBatch__mdt> timeSkip = [SELECT Id, DeveloperName, TimeMinSched__c FROM InwiB2CScheduleBatch__mdt WHERE DeveloperName ='SchedSubsMassProcessingBatch' LIMIT 1];
        InwiB2C_SubsMassProcessingSched_OnlyOne scheduledJob = new InwiB2C_SubsMassProcessingSched_OnlyOne();
        Datetime sysTime = System.now() + timeSkip[0].TimeMinSched__c;
		String cronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        System.schedule('InwiB2C_SubsMassProcessingBatch', cronExpression ,scheduledJob);
	}

}
global class InwB2C_SDPRequestSched_OnlyOne implements Schedulable{

    global void execute(SchedulableContext sc){
        
        InwB2C_SDPRequestBatchJob b = new InwB2C_SDPRequestBatchJob(); 
        database.executebatch(b);
        System.AbortJob(sc.getTriggerId());
    	rescheduleJob();
	}
       
    private void rescheduleJob(){
        
        List<InwiB2CScheduleBatch__mdt> timeSkip = [SELECT Id, DeveloperName, TimeMinSched__c FROM InwiB2CScheduleBatch__mdt WHERE DeveloperName ='SchedInwB2C_SDPRequest' LIMIT 1];
        InwB2C_SDPRequestSched_OnlyOne scheduledJob = new InwB2C_SDPRequestSched_OnlyOne();
        Datetime sysTime = System.now() + (timeSkip[0].TimeMinSched__c/1440);
		String cronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        System.schedule('InwB2C_SDPRequestBatchJob', cronExpression ,scheduledJob);
	}
}
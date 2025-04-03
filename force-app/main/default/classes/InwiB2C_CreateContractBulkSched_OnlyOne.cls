global class InwiB2C_CreateContractBulkSched_OnlyOne implements Schedulable{

    global void execute(SchedulableContext sc){

        InwiB2C_CreateContractBulkBatch b = new InwiB2C_CreateContractBulkBatch(); 
        database.executebatch(b);
        System.AbortJob(sc.getTriggerId());
    	rescheduleJob();
	}
   
    
    private void rescheduleJob(){
        
        InwiB2C_CreateContractBulkSched_OnlyOne scheduledJob = new InwiB2C_CreateContractBulkSched_OnlyOne();
        Datetime sysTime = System.now().addMinutes(5);
		String cronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        System.schedule('InwiB2C_CreateContractBulkSchedulable', cronExpression ,scheduledJob);
	}
}
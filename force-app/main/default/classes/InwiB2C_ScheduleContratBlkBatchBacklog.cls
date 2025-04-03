global class InwiB2C_ScheduleContratBlkBatchBacklog implements Schedulable {
  global void execute(SchedulableContext sc) {
        InwiB2C_CreateContractBulkBatchBacklog b = new InwiB2C_CreateContractBulkBatchBacklog(); 
        database.executebatch(b);
        System.AbortJob(sc.getTriggerId());
    	  rescheduleJob();
   } 
    private void rescheduleJob(){
        
      InwiB2C_ScheduleContratBlkBatchBacklog scheduledJob = new InwiB2C_ScheduleContratBlkBatchBacklog();
        Datetime sysTime = System.now().addMinutes(5);
		String cronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        System.schedule('InwiB2C_CreateContractBulkSchedulableBacklog', cronExpression ,scheduledJob);
	}
}
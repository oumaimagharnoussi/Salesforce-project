global class InwiB2C_ScheduleCreateContractBlkBatchV3 implements Schedulable {
  global void execute(SchedulableContext sc) {
        InwiB2C_CreateContractBulkBatchV3 b = new InwiB2C_CreateContractBulkBatchV3(); 
        database.executebatch(b);
        System.AbortJob(sc.getTriggerId());
    	  rescheduleJob();
   } 
    private void rescheduleJob(){
        
      InwiB2C_ScheduleCreateContractBlkBatchV3 scheduledJob = new InwiB2C_ScheduleCreateContractBlkBatchV3();
        Datetime sysTime = System.now().addMinutes(5);
		String cronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        System.schedule('InwiB2C_CreateContractBulkSchedulableV3', cronExpression ,scheduledJob);
	}
}
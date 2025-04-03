global with sharing class InwiB2C_ScheduleSubsMassProBatchIdentif  implements Schedulable { 
    global void execute(SchedulableContext sc) {
        InwiB2C_SubsMassProcessingBatchIdentif b = new InwiB2C_SubsMassProcessingBatchIdentif(); 
        database.executebatch(b);
        System.AbortJob(sc.getTriggerId());
    	  rescheduleJob();
   } 
    private void rescheduleJob(){
        
        InwiB2C_ScheduleSubsMassProBatchIdentif scheduledJob = new InwiB2C_ScheduleSubsMassProBatchIdentif();
        Datetime sysTime = System.now().addMinutes(10);
		String cronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        System.schedule('InwiB2C_ScheduleSubsMassProBatchIdentif', cronExpression ,scheduledJob);
	}
}
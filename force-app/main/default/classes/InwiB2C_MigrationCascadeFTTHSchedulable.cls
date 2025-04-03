global class InwiB2C_MigrationCascadeFTTHSchedulable implements Schedulable{
	
    global void execute(SchedulableContext sc){

        InwiB2C_ExecuteMigrationCascadeFTTH b = new InwiB2C_ExecuteMigrationCascadeFTTH(); 
        database.executebatch(b);
        System.AbortJob(sc.getTriggerId());
    	rescheduleJob();
	}
   
    
    private void rescheduleJob()
	{
          
        InwiB2C_MigrationCascadeFTTHSchedulable scheduledJob = new InwiB2C_MigrationCascadeFTTHSchedulable();
        Datetime sysTime = System.now().addMinutes(180);
		String cronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        System.schedule('InwiB2C_ExecuteMigrationCascadeFTTH', cronExpression ,scheduledJob);
	 
    }
    
}
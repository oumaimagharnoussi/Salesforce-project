global class inwiB2C_ManageIdarSuspSched_OnlyOne implements Schedulable{

    global void execute(SchedulableContext sc){

        inwiB2C_ManageIdarSuspensionBatch b = new inwiB2C_ManageIdarSuspensionBatch(); 
        database.executebatch(b);
        System.AbortJob(sc.getTriggerId());
    	rescheduleJob();
	}
   
    
    private void rescheduleJob(){
        
        inwiB2C_ManageIdarSuspSched_OnlyOne scheduledJob = new inwiB2C_ManageIdarSuspSched_OnlyOne();
        Datetime sysTime = System.now().addMinutes(5);
		String cronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        System.schedule('inwiB2C_ManageIdarSuspensionBatch', cronExpression ,scheduledJob);
	}
    
}
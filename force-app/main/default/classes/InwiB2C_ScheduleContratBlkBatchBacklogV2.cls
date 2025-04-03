global class InwiB2C_ScheduleContratBlkBatchBacklogV2 implements Schedulable {
    global void execute(SchedulableContext sc) {
        InwiB2C_CreateContractBulkBatchBacklogV2 b = new InwiB2C_CreateContractBulkBatchBacklogV2(); 
          database.executebatch(b);
          System.AbortJob(sc.getTriggerId());
            rescheduleJob();
     } 
      private void rescheduleJob(){
          
        InwiB2C_ScheduleContratBlkBatchBacklogV2 scheduledJob = new InwiB2C_ScheduleContratBlkBatchBacklogV2();
          Datetime sysTime = System.now().addMinutes(5);
          String cronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
          System.schedule('InwiB2C_CreateContractBulkSchedulableBacklogV2', cronExpression ,scheduledJob);
      }
  }
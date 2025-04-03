global class InwiB2C_ScheduleGenerateOrderCascaBatch implements Schedulable {
   global void execute(SchedulableContext sc) {
      InwiB2C_ExecuteMigrationCascadeFTTH b = new InwiB2C_ExecuteMigrationCascadeFTTH(); 
      database.executebatch(b);
   }
}
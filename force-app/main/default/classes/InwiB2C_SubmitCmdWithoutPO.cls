global class InwiB2C_SubmitCmdWithoutPO implements Schedulable {

    global void execute(SchedulableContext sc) {

        InwiB2C_SubmitCmdWithoutPOBatch b = new InwiB2C_SubmitCmdWithoutPOBatch();

        database.executebatch(b);

    }

}
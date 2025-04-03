/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-26-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global class InwiB2C_TechnoMassifBatchSchedulable implements Schedulable {
    global void execute(SchedulableContext sc) {
        InwiB2C_ChangementTechnoMassifBatch b = new InwiB2C_ChangementTechnoMassifBatch(); 
     database.executebatch(b);

    }
}
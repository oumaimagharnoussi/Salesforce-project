/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-26-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@IsTest
public class InwiB2C_TechnoMassifBatchSchedulableTest {
    public static testMethod void testSchedule() {
       
        Test.startTest();
        
         InwiB2C_TechnoMassifBatchSchedulable schedulable = new InwiB2C_TechnoMassifBatchSchedulable();
        
        String cronExp = '0 0 23 * * ?'; // Exemple d'expression CRON
        System.schedule('Test TechnoMassifBatch Schedule', cronExp, schedulable);
        

        Test.stopTest();

    }
}
@istest
class InwiB2C_ScheduleCreatContractBatchTestV2 {
    public static testMethod void testschedule() {
		Test.StartTest();
		InwiB2C_ScheduleCreateContractBlkBatchV2 testsche = new InwiB2C_ScheduleCreateContractBlkBatchV2();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
        
	}
}
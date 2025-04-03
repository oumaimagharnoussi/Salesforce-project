@istest
class InwiB2C_ScheduleCreateContrctBatchV3Test{
	public static testMethod void testschedule() {
		Test.StartTest();
		InwiB2C_ScheduleCreateContractBlkBatchV3 testsche = new InwiB2C_ScheduleCreateContractBlkBatchV3();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
	}
}
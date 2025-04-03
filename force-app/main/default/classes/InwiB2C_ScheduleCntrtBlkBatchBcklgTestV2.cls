@istest
class InwiB2C_ScheduleCntrtBlkBatchBcklgTestV2{
	public static testMethod void testschedule() {
		Test.StartTest();
		InwiB2C_ScheduleContratBlkBatchBacklogV2 testsche = new InwiB2C_ScheduleContratBlkBatchBacklogV2();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
	}
}
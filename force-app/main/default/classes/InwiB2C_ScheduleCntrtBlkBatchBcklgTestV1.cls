@istest
class InwiB2C_ScheduleCntrtBlkBatchBcklgTestV1{
	public static testMethod void testschedule() {
		Test.StartTest();
		InwiB2C_ScheduleContratBlkBatchBacklogV1 testsche = new InwiB2C_ScheduleContratBlkBatchBacklogV1();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
	}
}
@istest
class InwiB2C_ScheduleContratBlkBatchBcklgTest{
	public static testMethod void testschedule() {
		Test.StartTest();
		InwiB2C_ScheduleContratBlkBatchBacklog testsche = new InwiB2C_ScheduleContratBlkBatchBacklog();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
	}
}
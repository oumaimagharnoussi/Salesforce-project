@istest
class InwiB2C_SchedSubsMassProBatchIdentifTest {
    public static testMethod void testschedule() {
		Test.StartTest();
		InwiB2C_ScheduleSubsMassProBatchIdentif testsche = new InwiB2C_ScheduleSubsMassProBatchIdentif();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
	}
}
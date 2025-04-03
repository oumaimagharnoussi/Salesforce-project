@isTest
private class InwiB2C_SubmitCmdWithoutPO_Test {
    @isTest
    static void testExecute() {
        
        Test.startTest();
        InwiB2C_SubmitCmdWithoutPO scheduler = new InwiB2C_SubmitCmdWithoutPO();
        scheduler.execute(null);
        Test.stopTest();
        
        
        
    }
}
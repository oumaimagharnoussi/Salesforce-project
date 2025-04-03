@isTest
public class inwiB2C_CTControlFileAMTriggerTest {
    @isTest(SeeAllData=true)
    public static void inwiB2C_CTControlFileAMTriggerTest() {
        String lignes='[{"type":"typee","Firstname":"test","lasntame":"test","":"testtt","":"cinn","":"typecin","":"coddee","":"212123456789","":"212644333333","email":"text@gmail.com;Casablanca","":"rue adess","":"quartier","":"casa","":"123","":"1234"}]';
       
        InwiB2C_Controle_fileAM__e CTControlfileAMEvent = new InwiB2C_Controle_fileAM__e(
            InwiB2C_fileSize__c=20,InwiB2C_documentId__c='test',InwiB2C_Counter__c=1,InwiB2C_demandesList__c=lignes);
           
        Test.startTest();
        Database.SaveResult results = EventBus.publish(CTControlfileAMEvent);
        Test.stopTest();
        
    }
}
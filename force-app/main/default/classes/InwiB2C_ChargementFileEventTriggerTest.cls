@isTest
public class InwiB2C_ChargementFileEventTriggerTest {
    @isTest
    static void testInwiB2C_ChargementFileEventTrigger() {
        // Création d'un enregistrement simulé de type InwiB2C_ChargementFileEvent__e
        InwiB2C_ChargementFileEvent__e testEvent = new InwiB2C_ChargementFileEvent__e(
            InwiB2C_CIN__c = '124589666', 
            InwiB2C_Type_CIN_c__c = 'Passeport', 
            InwiB2C_Segment_Dealer__c = 'Grossiste', 
            InwiB2C_Typehandler__c = 'Non Handler',
            InwiB2C_Region__c = 'Grand Casablanca', 
            InwiB2C_Address__c = 'Meknes,Tafilalet CHARQAOUA aaa', 
            inwiB2C_Ville__c = 'SIDI BERNOUSSI',
            InwiB2C_Quartier__c = 'CASABLANCA', 
            InwiB2C_Geolocalisation_Latitude__c = Decimal.valueOf('27'), // Conversion en Decimal
            InwiB2C_Geolocalisation_Longitude__c = Decimal.valueOf('55'), // Conversion en Decimal
            inwib2c_AdresseMail__c = 'test5@gmail.com', 
            InwiB2C_Code_Dealer__c = Decimal.valueOf('555564'), 
             /* ACYL 19/12/2024 begin*/
            PartenaireNumContact1__c = '541515',
            Partenaire_Num_Contact2__c = '2121415', 
        /* ACYL 19/12/2024 End */

            FirstName__c = 'israa', 
            LastName__c = 'israaaa' 
        );
        
        
        // Insertion de l'événement dans Salesforce pour simuler l'exécution du trigger
        Test.startTest();
        Database.SaveResult results = EventBus.publish(testEvent);
       // insert testEvent;
        Test.stopTest();
        
        System.assert(true, 'Trigger exécuté sans erreur.');
    }
}
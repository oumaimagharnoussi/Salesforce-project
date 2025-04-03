@isTest
public class inwiB2C_RattrapageCaseSN_Test {
    @TestSetup
    static void setupData(){
        // Create Case
        Case sfCase = new Case(
            Inwib2c_Cat_gorie__c = 'Inwib2c_Assistance/service _HelpDesk',
            InwiB2C_Detail__c = 'Autres',
            Subject = 'Test subject',
            InwiB2C_Qualification__c = 'Service',
            InwiB2C_Qualification_AUDA__c = false,
            InwiB2C_TypeSpecialite__c = 'All',
            Status = 'InwiB2C_Escalade',
            Type = 'Inwib2c_HelpDesk',
            Description = 'Test description',
            Inwib2c_la_file_d_attente__c = 'Support Technique FTTH B2C N1',
            InwiB2C_LastEscaladeDate__c = Datetime.now().addHours(-5)
        );
        insert sfCase;

        InwiB2C_Typologie_Mapping_SF_SN__c mapping = new InwiB2C_Typologie_Mapping_SF_SN__c(
            InwiB2C_CategorieSF__c = 'Inwib2c_Assistance/service _HelpDesk',
            InwiB2C_DetailSF__c = 'Autres',
            InwiB2C_Type_de_offreSF__c = 'FTTH',
            InwiB2C_Type_de_specialiteSF__c = 'All',
            InwiB2C_Sous_categorieSN__c = 'All',
            InwiB2C_DetailSN__c = 'Autres'
        );
        insert mapping;
    }

    @isTest
    static void testBatchRattrapage(){
        Test.setMock(HttpCalloutMock.class, new inwiB2C_RattrapageCaseSN_TokenMock());
        Test.startTest();
        Database.executeBatch(new inwiB2C_RattrapageCaseSN('TODAY', 0, 10, 10, [SELECT ID FROM CASE LIMIT 1].ID));
        Test.stopTest();
        
    }
}
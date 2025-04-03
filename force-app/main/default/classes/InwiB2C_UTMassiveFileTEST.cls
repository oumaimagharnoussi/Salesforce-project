@isTest
public  class InwiB2C_UTMassiveFileTEST {
   @isTest(SeeAllData=false)
    public static void  ReadFileTest() {
        Test.startTest();
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        ContentVersion cv = new ContentVersion();
        cv.Description  = 'test description';
        cv.PathOnClient ='test_UTMassiveFile.txt';
        cv.Title = 'test UTMassiveFile';
        cv.versiondata=Blob.valueOf('123');
        insert cv;
        Id idDocument = cv.ContentDocumentId; 
        ContentDocument document = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument LIMIT 1];
        inputMap.put('contentDocumentId',document.Id);
        inputMap.put('fileName','test UTMassiveFile');
        new InwiB2C_UTMassiveFile().invokeMethod('ReadFile',inputMap, outMap, options);
        Test.stopTest();
    }
    @isTest(SeeAllData=false)
    // File OK
    public static void ReadUTFileOKTest()
    {
        Test.startTest();
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        ContentVersion cv = new ContentVersion();
        cv.Description  = 'test description';
        cv.PathOnClient ='test_file.txt';
        cv.Title = 'test file';
        String csvString = 'Segment;Distributeur;Type;Nom;Prénom;Piece identite;Type piece identite;Code;Num de contact 1;Num de contact 2;Adresse mail;Région;Adresse;Précision Quartier;Ville/Douar;Flag Rural ou Urbain;Canal (RTM/Classique);Latitude;Longitude;Vendeur;Sous-Région(RVR)\n'
        + 'typee;test;test;test;testtt;cinn;typecin;coddee;212123456789;212644333333;text@gmail.com;EST;rue adess;quartier;casa;Rural;RTM;123;1234;test;test\n'
        + 'typee;test;test;test;testtt;cinn;typecin;coddee;212123456789;212644333333;text@gmail.com;EST;rue adess;quartier;casa;Rural;RTM;123;1234;test;test';
        cv.versiondata=Blob.valueOf(csvString);
        insert cv;
        ContentVersion insertedVersion = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];
        Chargement_de_fichierAM_en_masse__c newRecord = new Chargement_de_fichierAM_en_masse__c();
                newRecord.Inwib2c_Segment_Dealer_c__c = 'Dealer';
                newRecord.InwiB2C_Typehandler__c = 'TH';
                newRecord.LastName__c = 'Test';
                newRecord.FirstName__c ='Test';
                newRecord.InwiB2C_CIN__c ='CIN';
                newRecord.InwiB2C_Type_CIN_c__c = 'Type piece';
                newRecord.InwiB2C_Code_Dealer__c = 123;
               // newRecord.PartenaireNumContact1__c =212123456789;
                //newRecord.Partenaire_Num_Contact2__c = 212123456789;
                newRecord.inwib2c_AdresseMail__c = 'TEXT@gmail.com';
                newRecord.InwiB2C_Region__c = 'EST';
                newRecord.InwiB2C_Address__c = 'Rue casa';
                newRecord.InwiB2C_Quartier__c ='Rue quartier';
                newRecord.inwiB2C_Ville__c = 'Casablanca';
                newRecord.inwib2c_Geolocalisation_Longitude__c = 11;
                newRecord.inwib2c_Geolocalisation_Latitude__c = 122;
                newRecord.InwiB2C_Vendeur__c = 'test';
                newRecord.InwiB2C_SousRegion__c ='test';
                newRecord.InwiB2C_Canal__c = 'RTM';
                newRecord.InwiB2C_Flag_Rural_Urbain__c = 'Rural';
                // Champ personnalisable ou spécifique au nouvel enregistrement
                newRecord.InwiB2C_UIID__c = insertedVersion.ContentDocumentId;

                // Insérer le nouvel enregistrement
                insert newRecord;
        inputMap.put('contentDocumentId',insertedVersion.ContentDocumentId);
        new InwiB2C_UTMassiveFile().invokeMethod('ReadFile',inputMap, outMap, options);
        Test.stopTest();
    }
     @isTest(SeeAllData=false)
    // File OK
    public static void ReadUTFileKOTest()
    {
        Test.startTest();
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        ContentVersion cv = new ContentVersion();
        cv.Description  = 'test description';
        cv.PathOnClient ='test_file.txt';
        cv.Title = 'test file';
        String csvString = 'Type;Nom;Prénom;Piece identite;Type piece identite;Code;Num de contact 1;Num de contact 2;Adresse mail;Région;Adresse;Quartier;Ville;Longitude;Latitude\n'
        + 'typee;test;testtt;cinn;typecin;coddee;212123456789;212644333333;text@gmail.com;Casablanca;rue adess;quartier;casa;123;1234\n'
        + 'typee;test;testtt;cinn;typecin;coddee;212123456789;212644333333;text@gmail.com;Casablanca;rue adess;quartier;casa;123;1234';
        cv.versiondata=Blob.valueOf(csvString);
        insert cv;
        Id idDocument = cv.ContentDocumentId; 
        //ContentDocument document = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument WHERE Id= :cv.ContentDocumentId LIMIT 1];
        ContentVersion insertedVersion = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];
        inputMap.put('contentDocumentId',insertedVersion.ContentDocumentId);
        new InwiB2C_UTMassiveFile().invokeMethod('ReadFile',inputMap, outMap, options);
        Test.stopTest();
    }
    @isTest(SeeAllData=false)
    public static void  ReadFileElseTest() {
        Test.startTest();
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        ContentVersion cv = new ContentVersion();
        cv.Description  = 'test description';
        cv.PathOnClient ='test_UTMassiveFile.txt';
        cv.Title = 'test UTMassiveFile';
        cv.versiondata=Blob.valueOf('123');
        insert cv;
        Id idDocument = cv.ContentDocumentId; 
        ContentDocument document = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument LIMIT 1];
          Chargement_de_fichierAM_en_masse__c newRecord = new Chargement_de_fichierAM_en_masse__c();
                newRecord.Inwib2c_Segment_Dealer_c__c = 'Dealer';
                newRecord.InwiB2C_Typehandler__c = 'TH';
                newRecord.LastName__c = 'Test';
                newRecord.FirstName__c ='Test';
                newRecord.InwiB2C_CIN__c ='CIN';
                newRecord.InwiB2C_Type_CIN_c__c = 'Type piece';
                newRecord.InwiB2C_Code_Dealer__c = 123;
               // newRecord.PartenaireNumContact1__c =212123456789;
                //newRecord.Partenaire_Num_Contact2__c = 212123456789;
                newRecord.inwib2c_AdresseMail__c = 'TEXT@gmail.com';
                newRecord.InwiB2C_Region__c = 'EST';
                newRecord.InwiB2C_Address__c = 'Rue casa';
                newRecord.InwiB2C_Quartier__c ='Rue quartier';
                newRecord.inwiB2C_Ville__c = 'Casablanca';
                newRecord.inwib2c_Geolocalisation_Longitude__c = 11;
                newRecord.inwib2c_Geolocalisation_Latitude__c = 122;
                newRecord.InwiB2C_Vendeur__c = 'test';
                newRecord.InwiB2C_SousRegion__c ='test';
                newRecord.InwiB2C_Canal__c = 'RTM';
                newRecord.InwiB2C_Flag_Rural_Urbain__c = 'Rural';
                insert newRecord;
        //inputMap.put('contentDocumentId',document.Id);
        inputMap.put('fileName','test UTMassiveFile');
        new InwiB2C_UTMassiveFile().invokeMethod('ReadFile',inputMap, outMap, options);
        Test.stopTest();
    }
}
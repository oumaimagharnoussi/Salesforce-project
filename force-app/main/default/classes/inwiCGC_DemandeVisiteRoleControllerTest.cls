@isTest
public class inwiCGC_DemandeVisiteRoleControllerTest {
   @isTest
    static void testGetRoleHierarchy(){

        UserRole rootRole = [SELECT Id, Name FROM UserRole WHERE Name = 'Casa' LIMIT 1];
        User currentRole = [select Name, id, UserRoleId , UserRole.Name from User where UserRoleId=: rootRole.Id LIMIT 1];
        
 
        
        inwiCGC_DemandeDeVisite__c testDemandeVisite = new inwiCGC_DemandeDeVisite__c();

        testDemandeVisite.Name = 'Test Demand';
        testDemandeVisite.Planned_Start_Time__c = System.now();
        testDemandeVisite.Planned_End_Time__c = System.now().addDays(2);
        testDemandeVisite.inwiCGC_Descriptif__c = 'Test descreption';
        testDemandeVisite.inwiCGC_Objectif__c = 100;
        testDemandeVisite.Status__c = 'inwiCGC_Valide'; 
        testDemandeVisite.OwnerId = currentRole.Id;
        insert testDemandeVisite;

        String result = InwiCGC_DemandeDeVisiteRoleController.getRoleHierarchy(testDemandeVisite.Id);
        System.debug('result '+ result );
        System.assertNotEquals(null, result, 'Result should not be null');
            
    }
    
    
    @isTest
    static void testCreateDemandesVisiteWithSubRole() {

        UserRole rootRole = [SELECT Id, Name FROM UserRole WHERE Name = 'Casa' LIMIT 1];
        List<UserRole> subordinateRoles = [SELECT Id ,Name FROM UserRole WHERE ParentRoleId=:rootRole.id];
        User subordinateUserRoles = [select Name, id, UserRoleId , UserRole.Name from User where UserRoleId IN :subordinateRoles LIMIT 1];
        User currentRole = [select Name, id, UserRoleId , UserRole.Name from User where UserRoleId=:rootRole.Id LIMIT 1];
        
        System.debug('rootRole '+ rootRole );
       
  
        inwiCGC_DemandeDeVisite__c testDemandeVisite = new inwiCGC_DemandeDeVisite__c();

        testDemandeVisite.Name = 'Test Demand';
        testDemandeVisite.Planned_Start_Time__c = System.now();
        testDemandeVisite.Planned_End_Time__c = System.now().addDays(2);
        testDemandeVisite.inwiCGC_Descriptif__c = 'Test descreption';
        testDemandeVisite.inwiCGC_Objectif__c = 100;
        testDemandeVisite.Status__c = 'inwiCGC_Valide'; 
        testDemandeVisite.OwnerId = currentRole.Id;
        insert testDemandeVisite;

        Map<String, Object> result = InwiCGC_DemandeDeVisiteRoleController.createDemandesVisite('[{"id":"' + subordinateUserRoles.UserRoleId + '","label":"Test Role","Objectif":"100","Descriptif":"test","isChecked":true}]', testDemandeVisite.Id);

        if(subordinateUserRoles != null){
            System.assertEquals(true, result.get('response'), 'Response should be true');
        }
        else {
            System.assertEquals(false, result.get('response'), 'Response should be false');
            List<String> errorMessages = new List<String>();
            errorMessages.add('Aucun utilisateur avec les roles sélectionné n\'as été trouvé');
            System.assertEquals(errorMessages, result.get('message'));
        }
        System.debug('result '+ result );
        
    }
    
     @isTest
    static void testCreateDemandesVisiteNoSubRole() {

        UserRole rootRole = [SELECT Id, Name FROM UserRole WHERE Name = 'Casa' LIMIT 1];
        User currentRole = [select Name, id, UserRoleId , UserRole.Name from User where UserRoleId=:rootRole.Id LIMIT 1];
        
        
        UserRole unassignedRoles = [SELECT Id, Name FROM UserRole WHERE ParentRoleId = null AND Id NOT IN (SELECT UserRoleId FROM User) limit 1];
  
        inwiCGC_DemandeDeVisite__c testDemandeVisite = new inwiCGC_DemandeDeVisite__c();

        testDemandeVisite.Name = 'Test Demand';
        testDemandeVisite.Planned_Start_Time__c = System.now();
        testDemandeVisite.Planned_End_Time__c = System.now().addDays(2);
        testDemandeVisite.inwiCGC_Descriptif__c = 'Test descreption';
        testDemandeVisite.inwiCGC_Objectif__c = 100;
        testDemandeVisite.Status__c = 'inwiCGC_Valide'; 
        testDemandeVisite.OwnerId = currentRole.Id;
        insert testDemandeVisite;

        Map<String, Object> result = InwiCGC_DemandeDeVisiteRoleController.createDemandesVisite('[{"id":"' + unassignedRoles.Id + '","label":"Test Role","Objectif":"100","Descriptif":"test","isChecked":true}]', testDemandeVisite.Id);

    
            System.assertEquals(false, result.get('response'), 'Response should be false');
            List<String> errorMessages = new List<String>();
            errorMessages.add('Aucun utilisateur avec les roles sélectionné n\'as été trouvé');
            System.assertEquals(errorMessages, result.get('message'));
        
        System.debug('result '+ result );
        
    }
    
    
      @isTest
    static void testDuplicateDemande() {

        UserRole rootRole = [SELECT Id, Name FROM UserRole WHERE Name = 'Casa' LIMIT 1];
        List<UserRole> subordinateRoles = [SELECT Id ,Name FROM UserRole WHERE ParentRoleId=:rootRole.id];
        User subordinateUserRoles = [select Name, id, UserRoleId , UserRole.Name from User where UserRoleId IN :subordinateRoles LIMIT 1];
        User currentRole = [select Name, id, UserRoleId , UserRole.Name from User where UserRoleId=:rootRole.Id LIMIT 1];
        
        inwiCGC_DemandeDeVisite__c testDemandeVisite = new inwiCGC_DemandeDeVisite__c();

        testDemandeVisite.Name = 'Test Demand';
        testDemandeVisite.Planned_Start_Time__c = System.now();
        testDemandeVisite.Planned_End_Time__c = System.now().addDays(2);
        testDemandeVisite.inwiCGC_Descriptif__c = 'Test descreption';
        testDemandeVisite.inwiCGC_Objectif__c = 100;
        testDemandeVisite.Status__c = 'inwiCGC_Valide'; 
        testDemandeVisite.OwnerId = currentRole.Id;
        insert testDemandeVisite;



        InwiCGC_DemandeDeVisiteRoleController.UserWithRoleInfo testUserWithRoleInfo = new InwiCGC_DemandeDeVisiteRoleController.UserWithRoleInfo();
        testUserWithRoleInfo.userId = currentRole.Id;
        testUserWithRoleInfo.userRoleId = subordinateUserRoles.UserRoleId;
        testUserWithRoleInfo.objectif = '1000';
        testUserWithRoleInfo.descriptif = 'Test Descriptif';

        List<inwiCGC_DemandeDeVisite__c> result = InwiCGC_DemandeDeVisiteRoleController.duplicateDemande(testDemandeVisite, new List<InwiCGC_DemandeDeVisiteRoleController.UserWithRoleInfo>{ testUserWithRoleInfo });


        System.assertEquals(1, result.size(), 'There should be one duplicated record');
        inwiCGC_DemandeDeVisite__c duplicatedRecord = result[0];
        System.assertEquals(testUserWithRoleInfo.userId, duplicatedRecord.OwnerId, 'Owner should be the test user');
        System.assertEquals(testDemandeVisite.Name, duplicatedRecord.Name, 'Name should be the same');

    }

}
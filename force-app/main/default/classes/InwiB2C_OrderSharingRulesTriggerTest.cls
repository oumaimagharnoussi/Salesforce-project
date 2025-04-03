/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-19-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class InwiB2C_OrderSharingRulesTriggerTest {

        
    public static testMethod void OrderSharingRulesTriggerTest() {
        Account testAccount = new Account();
        testAccount.Name='Test Account';
        insert testAccount;
        
        List<Order> ListOrders= new List<Order>();
        order neworder1 = new Order (inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification', Status = 'Draft', AccountId =testAccount.Id);
        ListOrders.add(neworder1);
         order neworder2 = new Order (inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1),inwiB2C_Canal__c = 'inwiB2C_Eshop', inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition', Status = 'Draft', AccountId =testAccount.Id);
        ListOrders.add(neworder2);
        order neworder3 = new Order (inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1),inwiB2C_Canal__c = 'inwiB2C_D2D', inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition', Status = 'Draft', AccountId =testAccount.Id);
        ListOrders.add(neworder3);
        
        
        Test.startTest();
        insert neworder1;
        insert neworder2;
        insert neworder3;

        neworder1.inwiB2C_Statut__c = 'inwiB2C_Activation';
        neworder2.inwiB2C_Statut__c = 'inwiB2C_Activation';
        neworder3.inwiB2C_Statut__c = 'inwiB2C_Activation';
        Update neworder1;
        Update neworder2;
        Update neworder3;
        Test.stopTest();
        
        
        System.assertEquals(neworder1.inwib2c_TypeDeLaCommande__c, 'inwiB2C_Modification');
        System.assertEquals(neworder2.inwib2c_TypeDeLaCommande__c, 'inwiB2C_Acquisition');
        System.assertEquals(neworder3.inwib2c_TypeDeLaCommande__c, 'inwiB2C_Acquisition');

    }
    
}
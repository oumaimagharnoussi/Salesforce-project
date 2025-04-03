public with sharing class InwiB2C_AccountSearchController {
    @AuraEnabled(cacheable=true)
    public static List<Account> searchAccounts(String cin, String contactNumber) {
        String query = 'SELECT Id, Name, Type__c, vlocity_cmt__Status__c, Type FROM Account WHERE Type__c = \'Non Handler\' AND vlocity_cmt__Status__c = \'Active\' AND Type = \'Partner\'';
        
        if (cin != null && cin != '') {
            query += ' AND CIN__c = :cin';
        }
        if (contactNumber != null && contactNumber != '') {
            query += ' AND Phone = :contactNumber';
        }

        return Database.query(query);
    }
}

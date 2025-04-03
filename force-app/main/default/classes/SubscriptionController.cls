public with sharing class SubscriptionController {
    @AuraEnabled(cacheable=true)
    public static vlocity_cmt__Subscription__c getSubscriptionInfo(String subscriptionId) {
        return [SELECT Id,
                       vlocity_cmt__AccountId__c,
                       vlocity_cmt__AccountId__r.Name,
                       InwiB2C_Contract__c,
                       InwiB2C_Contract__r.ContractNumber,
                       InwiB2C_Contract__r.InwiB2C_Statut_Dossier__c,
                       vlocity_cmt__BillingAccountId__c,
                       vlocity_cmt__BillingAccountId__r.Name,
                       vlocity_cmt__BillingAccountId__r.AccountNumber
                FROM vlocity_cmt__Subscription__c
                WHERE Id = :subscriptionId];
    }
}
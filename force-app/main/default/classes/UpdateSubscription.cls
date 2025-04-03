public class UpdateSubscription {
    
    public void updateSubscriptions(List<Id> Mdn) {
        List<vlocity_cmt__Subscription__c > subscriptions = [SELECT Id, inwiB2C_Statut__c,  vlocity_cmt__Status__c, vlocity_cmt__AccountId__c, inwiB2C_managedInSF__c FROM vlocity_cmt__Subscription__c  WHERE Id IN :Mdn AND inwiB2C_Statut__c ='InwiB2C_Active'];

        Map<Id, vlocity_cmt__Subscription__c > subscriptionByIdMap = new Map<Id, vlocity_cmt__Subscription__c >();

        for (vlocity_cmt__Subscription__c  subscription : subscriptions) {
            subscriptionByIdMap.put(subscription.Id, subscription);

            if (subscription.inwiB2C_Statut__c == 'InwiB2C_Active') {
                if (subscription.inwiB2C_managedInSF__c == true) {
                    subscription.inwiB2C_managedInSF__c = false;
                }
                
                subscription.inwiB2C_Statut__c = 'InwiB2C_Expired';
                subscription.vlocity_cmt__Status__c = 'Expired';
                System.debug('In activate to Expire');
            }
        }

        // Update the records only if there are changes
        if (!subscriptions.isEmpty()) {
            update subscriptions;
        }
    }
}
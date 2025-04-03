public with sharing class InwiCGC_GetUsersList {
    @AuraEnabled(cacheable=true)
    public static List<User> getUsers(String recordId) {
        // Visit visitRecord = [SELECT VisitorId FROM Visit WHERE Id = :recordId LIMIT 1];
        // if (String.valueOf(visitRecord.VisitorId).length() != 18) {
        //     return new List<User>();
        // }
        String currentUserId = UserInfo.getUserId();
        return [SELECT Id, Name FROM User WHERE ManagerId = :currentUserId];
    }

    /*@AuraEnabled(cacheable=true)
    public static List<RetailStore> getAdresses(Decimal longitude, Decimal latitude) {
       // List<RetailStore> stores = [SELECT id, Name, Address, inwiCGC_TypeActivite__c, DISTANCE(Address, GEOLOCATION(:latitude, :longitude), 'km') FROM RetailStore WHERE DISTANCE(Address, GEOLOCATION(:latitude, :longitude), 'km') < 50 ORDER BY DISTANCE(Address, GEOLOCATION(:latitude, :longitude), 'km') asc LIMIT 10];
        List<RetailStore> retailStores = [SELECT id, Name, inwiCGC_TypeActivite__c FROM RetailStore   LIMIT 10];
        return retailStores;
    }*/

    @AuraEnabled(cacheable=true)
    public static List<Schema.RetailStore> getCloseRetailStores(Decimal latitude, Decimal longitude) {
        List<Schema.RetailStore> retaiStoreList = [SELECT id, Name, Address, inwiCGC_TypeActivite__c, DISTANCE(Address, GEOLOCATION(:latitude, :longitude), 'km') FROM RetailStore WHERE DISTANCE(Address, GEOLOCATION(:latitude, :longitude), 'km') < 10 ORDER BY DISTANCE(Address, GEOLOCATION(:latitude, :longitude), 'km') asc LIMIT 10];

        System.debug( JSON.serialize(retaiStoreList));
        return retaiStoreList;
    }


}
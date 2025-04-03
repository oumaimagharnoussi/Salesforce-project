public with sharing class InwiB2C_RecordValidation {
    @AuraEnabled
    public static List<Map<String, Object>> validateRecords(List<Map<String, Object>> records) {
        List<Map<String, Object>> validationResults = new List<Map<String, Object>>();

        for (Map<String, Object> record : records) {
            String cin = (String) record.get('CIN');
            List<InwiB2C_AM_en_masse__c> matchingRecords = [SELECT Id FROM InwiB2C_AM_en_masse__c WHERE InwiB2C_CIN__c = :cin];
            record.put('isValid', matchingRecords.size() > 0);
            validationResults.add(record);
        }

        return validationResults;
    }
}
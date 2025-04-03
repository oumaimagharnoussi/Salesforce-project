public with sharing class AddressManagementController {

    @AuraEnabled
    public static void manageAddress(String accountId, String paysName, String regionName, String villeName, String quartierName, String precisionQuartierName) {
        try {
            Account acc = [SELECT Id, Name, InwiB2C_Address__c FROM Account WHERE Id = :accountId LIMIT 1];

            if (acc != null) {
                InwiB2C_Address__c addressRecord;

                // Vérifier si l'adresse existe déjà pour ce compte
                if (String.isNotBlank(acc.InwiB2C_Address__c)) {
                    addressRecord = [SELECT Id, 
                                     InwiB2C_Pays__c, 
                                     InwiB2C_Region__c,
                                     InwiB2C_Ville__c,
                                     InwiB2C_Quartier__c
                                     FROM InwiB2C_Address__c
                                     WHERE Id = :acc.InwiB2C_Address__c LIMIT 1];
                } else {
                    addressRecord = new InwiB2C_Address__c();
                }

                // Mettre à jour les champs de l'adresse
                addressRecord.Name = 'Adresse de ' + acc.Name;
                addressRecord.InwiB2C_Pays__c = createOrUpdatePays(paysName);
                addressRecord.InwiB2C_Region__c = createOrUpdateRegion(regionName);
                addressRecord.InwiB2C_Ville__c = createOrUpdateVille(villeName);
                addressRecord.InwiB2C_Quartier__c = createOrUpdateQuartier(quartierName);

                // Insérer ou mettre à jour l'enregistrement d'adresse
                if (addressRecord.Id == null) {
                    insert addressRecord;
                } else {
                    update addressRecord;
                }

                // Mettre à jour l'ID de l'adresse sur le compte
                acc.InwiB2C_Address__c = addressRecord.Id;
                update acc;
            }
        } catch (Exception e) {
            // Gérer l'exception selon vos besoins
            System.debug('Exception occurred: ' + e.getMessage());
            throw e; // Re-lancer l'exception pour une gestion supplémentaire si nécessaire
        }
    }

    // Méthodes utilitaires pour créer ou récupérer des enregistrements dans les objets Pays, Région, Ville et Quartier

    private static Id createOrUpdatePays(String paysName) {
        try {
            InwiB2C_Pays__c paysRecord = [SELECT Id FROM InwiB2C_Pays__c WHERE Name = :paysName LIMIT 1];

            if (paysRecord == null) {
                paysRecord = new InwiB2C_Pays__c(Name = paysName);
                insert paysRecord;
            }

            return paysRecord.Id;
        } catch (Exception e) {
            // Gérer l'exception selon vos besoins
            System.debug('Exception occurred in createOrUpdatePays: ' + e.getMessage());
            throw e; // Re-lancer l'exception pour une gestion supplémentaire si nécessaire
        }
    }

    private static Id createOrUpdateRegion(String regionName) {
        try {
            InwiB2C_Region__c regionRecord = [SELECT Id FROM InwiB2C_Region__c WHERE Name = :regionName LIMIT 1];

            if (regionRecord == null) {
                regionRecord = new InwiB2C_Region__c(Name = regionName);
                insert regionRecord;
            }

            return regionRecord.Id;
        } catch (Exception e) {
            // Gérer l'exception selon vos besoins
            System.debug('Exception occurred in createOrUpdateRegion: ' + e.getMessage());
            throw e; // Re-lancer l'exception pour une gestion supplémentaire si nécessaire
        }
    }

    private static Id createOrUpdateVille(String villeName) {
        try {
            InwiB2C_Ville__c villeRecord = [SELECT Id FROM InwiB2C_Ville__c WHERE Name = :villeName LIMIT 1];

            if (villeRecord == null) {
                villeRecord = new InwiB2C_Ville__c(Name = villeName);
                insert villeRecord;
            }

            return villeRecord.Id;
        } catch (Exception e) {
            // Gérer l'exception selon vos besoins
            System.debug('Exception occurred in createOrUpdateVille: ' + e.getMessage());
            throw e; // Re-lancer l'exception pour une gestion supplémentaire si nécessaire
        }
    }

    private static Id createOrUpdateQuartier(String quartierName) {
        try {
            InwiB2C_Quartier__c quartierRecord = [SELECT Id FROM InwiB2C_Quartier__c WHERE Name = :quartierName LIMIT 1];

            if (quartierRecord == null) {
                quartierRecord = new InwiB2C_Quartier__c(Name = quartierName);
                insert quartierRecord;
            }

            return quartierRecord.Id;
        } catch (Exception e) {
            // Gérer l'exception selon vos besoins
            System.debug('Exception occurred in createOrUpdateQuartier: ' + e.getMessage());
            throw e; // Re-lancer l'exception pour une gestion supplémentaire si nécessaire
        }
    }
}
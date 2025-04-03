public with sharing class InwiB2C_ListViewsD2D {
    @AuraEnabled(cacheable=true)
    public static List<Order> getOrdersForUserQueue() {
        // Récupérer l'ID de l'utilisateur connecté
        Id currentUserId = UserInfo.getUserId();
        
        // Trouver les Queues auxquelles appartient cet utilisateur
        List<GroupMember> userGroups = [
            SELECT GroupId 
            FROM GroupMember 
            WHERE UserOrGroupId = :currentUserId
        ];
        
        // Extraire les IDs des Queues
        Set<Id> queueIds = new Set<Id>();
        for (GroupMember gm : userGroups) {
            queueIds.add(gm.GroupId);
        }
        
        // Récupérer les commandes où le propriétaire est une Queue
        List<Order> orders = [
            SELECT Id, OrderNumber, Name, inwiB2C_Animateur_D2D__r.Name, CreatedDate, 
                   inwiB2C_Statut__c,inwib2c_Partenaire__r.inwib2c_CodePartenaire__c, inwib2c_TypeDeLaCommande__c, InwiB2C_Type_Offer__c, 
                   InwiB2C_Offre__c, TotalAmount, OwnerId
            FROM Order 
            WHERE OwnerId IN :queueIds 
            ORDER BY CreatedDate DESC
        ];

        // Récupérer les valeurs des statuts et types de commande
        Map<String, String> statutLabels = new Map<String, String>();
        Map<String, String> typeCommandeLabels = new Map<String, String>();

        // Récupérer tous les valeurs possibles des statuts et types de commandes dans l'Ordre
        for (Order o : orders) {
            if (o.inwiB2C_Statut__c != null && !statutLabels.containsKey(o.inwiB2C_Statut__c)) {
                statutLabels.put(o.inwiB2C_Statut__c, getStatutLabel(o.inwiB2C_Statut__c));
            }
            if (o.inwib2c_TypeDeLaCommande__c != null && !typeCommandeLabels.containsKey(o.inwib2c_TypeDeLaCommande__c)) {
                typeCommandeLabels.put(o.inwib2c_TypeDeLaCommande__c, getTypeCommandeLabel(o.inwib2c_TypeDeLaCommande__c));
            }
        }

        // Remplacer les API names avec leurs labels dans les résultats
        for (Order o : orders) {
            if (o.inwiB2C_Statut__c != null && statutLabels.containsKey(o.inwiB2C_Statut__c)) {
                o.put('inwiB2C_Statut__c', statutLabels.get(o.inwiB2C_Statut__c));
            }
            if (o.inwib2c_TypeDeLaCommande__c != null && typeCommandeLabels.containsKey(o.inwib2c_TypeDeLaCommande__c)) {
                o.put('inwib2c_TypeDeLaCommande__c', typeCommandeLabels.get(o.inwib2c_TypeDeLaCommande__c));
            }
        }
        
        return orders;
    }

    // Méthode pour obtenir le label pour 'inwiB2C_Statut__c'
    private static String getStatutLabel(String statutValue) {
        // Remplacer cette logique avec les valeurs réelles ou votre propre logique
        if (statutValue == 'inwiB2C_Activee') {
            return 'Active';  // Label réel
        }else if (statutValue == 'inwiB2C_EnCours') {
            return 'En cours	';  // Label réel
        }else if (statutValue == 'inwiB2C_Paiement') {
            return 'Paiement';  // Label réel
        }else if (statutValue == 'inwiB2C_Finalisation') {
            return 'Finalisation';  // Label réel
        }else if (statutValue == 'inwiB2C_Activation') {
            return 'Active';  // Label réel
        }else if (statutValue == 'inwiB2C_Activation') {
            return 'Activation';  // Label réel
        }else if (statutValue == 'inwiB2C_Annulee') {
            return 'Annulée';  // Label réel
        }else if (statutValue == 'inwiB2C_Conforme') {
            return 'Conforme';  // Label réel
        }else if (statutValue == 'inwiB2C_NonConforme') {
            return 'Non Conforme';  // Label réel
        }else if (statutValue == 'inwiB2C_ValideeBO') {
            return 'Validée BO';  // Label réel
        }else if (statutValue == 'inwiB2C_RefuseeBO') {
            return 'Refusée BO';  // Label réel
        }else if (statutValue == 'inwib2c_Validee_BO_135') {
            return 'Validée BO 135';  // Label réel
        }else if (statutValue == 'inwiB2C_Refusee_BO_135') {
            return 'Refusée BO 135';  // Label réel
        }else if (statutValue == 'En attente d\'approbation') {
            return 'En attente d\'approbation';  // Label réel
        }
        // Ajoutez d'autres valeurs et labels si nécessaire
        return statutValue; // Retourne le nom de l'API si aucune correspondance
    }

    // Méthode pour obtenir le label pour 'inwib2c_TypeDeLaCommande__c'
    private static String getTypeCommandeLabel(String typeCommandeValue) {
        // Remplacer cette logique avec les valeurs réelles ou votre propre logique
        if (typeCommandeValue == 'inwiB2C_Acquisition') {
            return 'Acquisition';  // Label réel
        }else if(typeCommandeValue =='inwiB2C_Migration'){
             return 'Migration';  // Label réel
        }
        // Ajoutez d'autres valeurs et labels si nécessaire
        return typeCommandeValue; // Retourne le nom de l'API si aucune correspondance
    }
}
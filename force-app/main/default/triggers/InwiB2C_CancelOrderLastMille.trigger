trigger InwiB2C_CancelOrderLastMile on InwiB2C_CancelOrderBatchLastMile__e (after insert) {

    String IP_UnlockArticle = 'Inwi_InwiB2C_UnLockArticle'; // Nom de la VIP
    String imei;
    String CodeArticleTerminal;
    List<Order> OrdersToCancel = new List<Order>();
    String vendor;

    // Liste des IDs de commandes à annuler
    List<Id> OrdersIdList = new List<Id>();

    // Récupérer les IDs des commandes depuis l'event déclenché
    for(InwiB2C_CancelOrderBatchLastMile__e currentOrder : Trigger.new){
        OrdersIdList.add(currentOrder.inwiB2C_OrderId__c);
    }

    // Requête pour récupérer les commandes avec statut 'inwiB2C_A_Annuler'
    List<Order> OrdersList = [SELECT id, inwiB2C_Statut__c, inwib2c_Partenaire__r.inwib2c_CodePartenaire__c 
                              FROM Order 
                              WHERE inwiB2C_Statut__c = 'inwiB2C_A_Annuler' 
                              AND Id IN :OrdersIdList];

    // Détails des commandes à annuler
    for (Order orderItem : OrdersList) {
        // Mise à jour du statut de la commande
        orderItem.inwiB2C_Statut__c = 'inwiB2C_Annulee'; 
        orderItem.inwib2c_MotifAnnulation__c = 'inwiB2C_CommandeAnnulee';
        orderItem.inwib2c_DetailMotif__c = 'La commande a été annulée automatiquement après 2 heures.';
        OrdersToCancel.add(orderItem);
        String vendor = OrderItem.inwib2c_Partenaire__r.inwib2c_CodePartenaire__c;
    }

    // Traitement des articles liés aux commandes
    List<OrderItem> OrderItemListTERM = [SELECT id, OrderId, Product2.ProductCode, vlocity_cmt__JSONAttribute__c 
                                          FROM OrderItem 
                                          WHERE OrderId IN :OrdersIdList 
                                          AND Product2.ProductCode = 'INWIB2C_OFFERING_TERMINAL'];

    // Annulation des produits associés aux commandes
    for (OrderItem ordItem : OrderItemListTERM) {
        if (ordItem.OrderId != null) {
            // Extraction des informations depuis le JSON (par exemple, IMEI et CodeArticleTerminal)
            if (ordItem.vlocity_cmt__JSONAttribute__c != null && ordItem.vlocity_cmt__JSONAttribute__c != '') {
                imei = INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(ordItem.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_IMEI');
                CodeArticleTerminal = INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(ordItem.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_MODELE');

                // Préparation des paramètres pour l'appel VIP
                Map<String, Object> HandsetItemsTerminal = new Map<String, Object>();
                HandsetItemsTerminal.put('code', CodeArticleTerminal);
                HandsetItemsTerminal.put('serialNumber', imei);
                HandsetItemsTerminal.put('orderType', 'MOBILE');
                HandsetItemsTerminal.put('vendor', vendor);
                HandsetItemsTerminal.put('quantity', '1');

                Map<String, Object> ipInput = new Map<String, Object>();
                ipInput.put('username', 'Jawad');
                ipInput.put('action', 'OS');
                ipInput.put('mode', 'SALE');
                ipInput.put('channel', 'SF');
                ipInput.put('id', '12');
                ipInput.put('orgID', 'INWI');
                ipInput.put('marketSegment', 'B2C');
                ipInput.put('offerType', 'MOBILE');
                ipInput.put('handset', new List<Map<String, Object>>{HandsetItemsTerminal});

                Map<String, Object> ipOptions = new Map<String, Object>();

                // Appel à la VIP via une classe d'exécution asynchrone
                Map<String, Object> Params = new Map<String, Object>();
                Params.put('Name', IP_UnlockArticle);
                Params.put('ipInput', ipInput);
                Params.put('ipOptions', ipOptions);
                inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(Params));
            }
        }
    }

    // Si ce n'est pas un test, on met à jour les commandes annulées
    if(!Test.isRunningTest()) {
        update OrdersToCancel;
    }
}

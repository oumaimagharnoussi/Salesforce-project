/**
 * @description       : Classe pour transformer les interactions de paiement JSON
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-21-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
global with sharing class InwiB2C_TransformJsonPayment implements vlocity_cmt.VlocityOpenInterface2 {

    global static boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> output, Map<String, Object> options) {        
        Boolean result = true;    
        try {
            if (methodName.equals('TransformJsonPayment')) {
                TransformJsonPayment(input, output, options);                                                      
            }     
        } catch (Exception e) {
            result = false;
            System.debug('Error in invokeMethod: ' + e.getMessage());
        }     
        return result;            
    }

    public static void TransformJsonPayment(Map<String, Object> deserialized, Map<String, Object> output, Map<String, Object> options) {
        Integer creatorReferenceIndex = 0;
        Integer amountTIIndex = 0;
        Integer amountPTIndex = 0;
        Integer typeIndex = 0;
        Integer shortDescIndex = 0;
        Integer codeIndex = 0;

        // Liste pour stocker les interactions de paiement transformées
        List<Map<String, Object>> transformedPayments = new List<Map<String, Object>>();

        // Extraction de la liste des interactions de paiement
        List<Object> paymentInteractionsObj = (List<Object>) deserialized.get('CSCreatePaymentInteraction');
        System.debug('Payment Interactions: ' + paymentInteractionsObj);

        if (paymentInteractionsObj == null || paymentInteractionsObj.isEmpty()) {
            System.debug('No payment interactions found.');
            return;
        }

        // Parcours de chaque interaction pour transformation
        for (Object paymentInteractionObj : paymentInteractionsObj) {
            Map<String, Object> paymentInteraction = (Map<String, Object>) paymentInteractionObj;
            Map<String, Object> transformedInteraction = new Map<String, Object>();
            Map<String, Object> transformedPayment = new Map<String, Object>();

            // Extraction de l'objet CSPayment pour transformation
            Map<String, Object> payment = (Map<String, Object>) paymentInteraction.get('CSPayment');
            System.debug('Original Payment: ' + payment);
            
            if (payment == null) {
                System.debug('No payment information found in interaction.');
                continue; // Passer à la prochaine interaction si l'information de paiement est absente
            }
            
            // Traitement de 'CSPaymentReference' en limitant les références
            Map<String, Object> paymentReference = (Map<String, Object>) payment.get('CSPaymentReference');
            if (paymentReference != null) {
                Object creatorReferenceObj = paymentReference.get('creatorReference');
                if (creatorReferenceObj instanceof List<Object>) {
                    List<String> creatorReferenceList = (List<String>) creatorReferenceObj;
                    if (creatorReferenceList != null && !creatorReferenceList.isEmpty()) {
                        Integer currentIndex = Math.mod(creatorReferenceIndex, creatorReferenceList.size());
                        paymentReference.put('creatorReference', new List<String>{creatorReferenceList[currentIndex]});
                        creatorReferenceIndex++;
                    }
                }
            }

            // Transformation des montants (CSAmount)
            Map<String, Object> csAmount = (Map<String, Object>) payment.get('CSAmount');
            if (csAmount != null) {
                // Transformer amountTI
                Object amountTIObj = csAmount.get('amountTI');
                if (amountTIObj instanceof List<Object>) {
                    List<Integer> amountTI = (List<Integer>) amountTIObj;
                    if (amountTI != null && !amountTI.isEmpty()) {
                        Integer currentIndex = Math.mod(amountTIIndex, amountTI.size());
                        csAmount.put('amountTI', new List<Integer>{amountTI[currentIndex]});
                        amountTIIndex++;
                    }
                }

                // Transformer amountPT
                Object amountPTObj = csAmount.get('amountPT');
                if (amountPTObj instanceof List<Object>) {
                    List<Integer> amountPT = (List<Integer>) amountPTObj;
                    if (amountPT != null && !amountPT.isEmpty()) {
                        Integer currentIndex = Math.mod(amountPTIndex, amountPT.size());
                        csAmount.put('amountPT', new List<Integer>{amountPT[currentIndex]});
                        amountPTIndex++;
                    }
                }
            }

            // Transformation du type
            Object typeObj = payment.get('type');
            if (typeObj instanceof List<Object>) {
                List<String> typeList = (List<String>) typeObj;
                if (typeList != null && !typeList.isEmpty()) {
                    Integer currentIndex = Math.mod(typeIndex, typeList.size());
                    payment.put('type', new List<String>{typeList[currentIndex]});
                    typeIndex++;
                }
            }

            // Transformation des offres (CSOffer)
            Map<String, Object> csOrder = (Map<String, Object>) payment.get('CSOrder');
            if (csOrder != null) {
                Map<String, Object> csOffer = (Map<String, Object>) csOrder.get('CSOffer');
                if (csOffer != null) {
                    // Transformer shortDesc
                    Object shortDescObj = csOffer.get('shortDesc');
                    if (shortDescObj instanceof List<Object>) {
                        List<String> shortDesc = (List<String>) shortDescObj;
                        if (shortDesc != null && !shortDesc.isEmpty()) {
                            Integer currentIndex = Math.mod(shortDescIndex, shortDesc.size());
                            csOffer.put('shortDesc', new List<String>{shortDesc[currentIndex]});
                            shortDescIndex++;
                        }
                    }

                    // Transformer code
                    Object codeObj = csOffer.get('code');
                    if (codeObj instanceof List<Object>) {
                        List<String> code = (List<String>) codeObj;
                        if (code != null && !code.isEmpty()) {
                            Integer currentIndex = Math.mod(codeIndex, code.size());
                            csOffer.put('code', new List<String>{code[currentIndex]});
                            codeIndex++;
                        }
                    }
                }
            }

            // Ajouter le champ CSPayment transformé
            transformedPayment.put('CSPaymentReference', paymentReference);
            transformedPayment.put('CSAmount', csAmount);
            transformedPayment.put('type', payment.get('type'));
            transformedPayment.put('CSOrder', csOrder);

            // Ajouter l'interaction transformée à la liste
            transformedInteraction.put('CSPayment', transformedPayment);

            // Ajouter les autres champs de l'interaction de paiement
            for (String interactionKey : paymentInteraction.keySet()) {
                if (interactionKey != 'CSPayment') {
                    transformedInteraction.put(interactionKey, paymentInteraction.get(interactionKey));
                }
            }

            // Ajouter l'interaction transformée à la liste des interactions
            transformedPayments.add(transformedInteraction);
        }

        // Ajouter la liste des interactions transformées à la sortie
        output.put('CSCreatePaymentInteraction', transformedPayments);
        System.debug('Transformed Payments: ' + transformedPayments);

        // Ajouter d'autres champs à la sortie si nécessaire
        output.put('channel', deserialized.get('channel'));
        output.put('uuid', deserialized.get('uuid'));
        output.put('user', deserialized.get('user'));
    }
}
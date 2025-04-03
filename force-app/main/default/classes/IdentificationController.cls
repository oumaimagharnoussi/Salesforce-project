public with sharing class IdentificationController {
    @AuraEnabled(cacheable=true)
    public static List<String> getPieceIdentiteOptions() {
        List<String> options = new List<String>();
        for (AggregateResult ar : [SELECT InwiB2C_Type_piece_identite__c 
                                   FROM InwiB2C_Demande_identification__c 
                                   WHERE InwiB2C_Type_piece_identite__c != null 
                                   GROUP BY InwiB2C_Type_piece_identite__c]) {
            options.add(String.valueOf(ar.get('InwiB2C_Type_piece_identite__c')));
        }
        return options;
    }

    @AuraEnabled(cacheable=true)
    public static List<InwiB2C_Demande_identification__c> searchForIdentification(String typePieceIdentite, String pieceIdentite) {
        return [SELECT Id, InwiB2C_Type_piece_identite__c, InwiB2C_MDN__c, InwiB2C_Piece_identite__c, InwiB2C_Contract__r.ContractNumber 
                FROM InwiB2C_Demande_identification__c 
                WHERE InwiB2C_MDN__c = :pieceIdentite AND InwiB2C_Type_piece_identite__c = :typePieceIdentite LIMIT 1];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<InwiB2C_Demande_identification__c> searchForIdentificationByPiece(String pieceIdentite) {
        return [SELECT Id, InwiB2C_Type_piece_identite__c, InwiB2C_MDN__c, InwiB2C_Piece_identite__c, InwiB2C_Contract__r.ContractNumber 
                FROM InwiB2C_Demande_identification__c 
                WHERE InwiB2C_Piece_identite__c = :pieceIdentite LIMIT 1];
    }
}
/**
 * @description       : cette classe permet de gerer les demandes de partage FTTH: createNewDegroupageOrder => creer une nouvelle demande de partage / cloneDemandePrtage: cloner une demande de partage et mise a jour des champs
 * @author            : Imane Lakrari
 * @last modified on  : 24-12-2024
 * @last modified by  : Imane Lakrari
**/
public class InwiB2C_ManagePartageOrder {

/**create new demande de partage*/

    public static void createNewDegroupageOrder(String orderId){

        //create commande de partage
        InwiB2C_Commande_de_partage__c commandePartage = new InwiB2C_Commande_de_partage__c(InwiB2C_Order__c=orderId);
        insert commandePartage;

        //get informations from order and site
        String statutLigne = '';
        String Portability ='';
        String nd='';
        String ndAttribut='';
        String login='';
        String identifligne= 'ND';
        String operatorInfra='';
        String mac='';
        String codeRoutage ='';
        String rio='';

        Order commande = [select id,vlocity_cmt__DefaultServiceAccountId__r.inwib2c_numvoiecode__c,vlocity_cmt__DefaultServiceAccountId__r.inwib2c_numvoievalue__c,
        vlocity_cmt__DefaultServiceAccountId__r.inwib2c_voievalue__c,vlocity_cmt__DefaultServiceAccountId__r.inwib2c_voiecode__c,
        vlocity_cmt__DefaultServiceAccountId__r.inwib2c_quartiervalue__c,vlocity_cmt__DefaultServiceAccountId__r.inwib2c_quartiercode__c,
        vlocity_cmt__DefaultServiceAccountId__r.inwib2c_communevalue__c,vlocity_cmt__DefaultServiceAccountId__r.inwib2c_communecode__c,
        vlocity_cmt__DefaultServiceAccountId__r.inwib2c_provincevalue__c,vlocity_cmt__DefaultServiceAccountId__r.inwib2c_provincecode__c,
        AccountId,Account.vlocity_cmt__PersonContactId__r.FirstName,Account.vlocity_cmt__PersonContactId__r.LastName,Account.vlocity_cmt__PersonContactId__r.Phone,Account.vlocity_cmt__PersonContactId__r.InwiB2C_CIN__c,
        vlocity_cmt__DefaultServiceAccountId__c,vlocity_cmt__DefaultServiceAccountId__r.inwiB2C_numero_de_designation__c,vlocity_cmt__DefaultServiceAccountId__r.InwiB2C_Portabilite__c,vlocity_cmt__DefaultServiceAccountId__r.InwiB2C_LoginIAM__c,
        vlocity_cmt__DefaultServiceAccountId__r.InwiB2C_Identifiant_de_la_ligne__c,vlocity_cmt__DefaultServiceAccountId__r.InwiB2C_Address__r.InwiB2C_Region__r.InwiB2C_RegionMdn__c from Order where Id =:orderId ];
        
        orderitem parent=[select id,vlocity_cmt__JSONAttribute__c  FROM orderitem WHERE OrderId  =: orderId and vlocity_cmt__ParentItemId__c =null and product2.vlocity_cmt__Type__c = 'FTTH' ];
        orderitem numTel=[select id,vlocity_cmt__JSONAttribute__c  FROM orderitem WHERE OrderId  =: orderId and vlocity_cmt__ParentItemId__c =: parent.Id and product2.ProductCode = 'INWIB2C_FOB2C_OFFERING_MSISDN_STANDARD' ];
        orderitem terminal=[select id,vlocity_cmt__JSONAttribute__c  FROM orderitem WHERE OrderId  =: orderId and vlocity_cmt__ParentItemId__c =: parent.Id and product2.ProductCode = 'INWIB2C_FOB2C_OFFERING_TERMINAL' ];
        
        statutLigne=INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(parent.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_STATUTPARTAGE');
        Portability=commande.vlocity_cmt__DefaultServiceAccountId__r.InwiB2C_Portabilite__c;
        identifligne=commande.vlocity_cmt__DefaultServiceAccountId__r.InwiB2C_Identifiant_de_la_ligne__c;
        operatorInfra=INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(parent.vlocity_cmt__JSONAttribute__c,'INWIB2C_ATT_RT_OPERATEUROI');
        mac=INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(terminal.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_CPEMAC');
        rio=INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(numTel.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_RIO');

        //set Nd or login
        if(statutLigne=='LA'){
            if(identifligne=='Login')
                login=commande.vlocity_cmt__DefaultServiceAccountId__r.InwiB2C_LoginIAM__c;
            else
                nd=commande.vlocity_cmt__DefaultServiceAccountId__r.inwiB2C_numero_de_designation__c;
        }

        //set NdAttribut
        String ndOrderItem = (Portability=='Oui')?'INWIB2C_ATT_RT_MSISDN_PORTED':'INWIB2C_ATT_RT_MSISDN';
        ndAttribut=INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(numTel.vlocity_cmt__JSONAttribute__c, ndOrderItem);

        //set routing code
        codeRoutage=(commande.vlocity_cmt__DefaultServiceAccountId__r.InwiB2C_Address__r.InwiB2C_Region__r.InwiB2C_RegionMdn__c == 'NORD')?'E2101':'E3101'; 

        //create demande de partage
        inwiB2C_demande_partage__c demande = new inwiB2C_demande_partage__c(
            Commande_de_partage__c=commandePartage.id,
            InwiB2C_Sequence__c=1,
            InwiB2C_Statut_demande__c='NOU',
            InwiB2C_Statut_ligne__c=statutLigne,
            InwiB2C_Operateur_Infrastructure__c=operatorInfra,
            InwiB2C_Operateur_commercial__c='WANA',
            Type_de_partage__c='ACTIF',
            InwiB2C_NumeroDesignation__c=nd,
            InwiB2C_Login__c=login,
            InwiB2C_nd_Attribut__c=ndAttribut,
            InwiB2C_FirstName__c=commande.Account.vlocity_cmt__PersonContactId__r.FirstName,
            InwiB2C_LastName__c=commande.Account.vlocity_cmt__PersonContactId__r.LastName,
            InwiB2C_Nationalid__c=commande.Account.vlocity_cmt__PersonContactId__r.InwiB2C_CIN__c,
            InwiB2C_numeroContact__c=commande.Account.vlocity_cmt__PersonContactId__r.Phone,
            InwiB2C_Installation_CPE__c='OUI',
            InwiB2C_Identifiant_CPE__c=mac,
            InwiB2C_savPlus__c='OUI',
            InwiB2C_Province__c=commande.vlocity_cmt__DefaultServiceAccountId__r.inwib2c_provincevalue__c,
            InwiB2C_Code_Province__c=commande.vlocity_cmt__DefaultServiceAccountId__r.inwib2c_provincecode__c,
            InwiB2C_Commune__c=commande.vlocity_cmt__DefaultServiceAccountId__r.inwib2c_communevalue__c,
            InwiB2C_Code_Commune__c=commande.vlocity_cmt__DefaultServiceAccountId__r.inwib2c_communecode__c,
            inwiB2C_Quartier__c=commande.vlocity_cmt__DefaultServiceAccountId__r.inwib2c_quartiervalue__c,
            InwiB2C_Code_Quartier__c=commande.vlocity_cmt__DefaultServiceAccountId__r.inwib2c_quartiercode__c,
            InwiB2C_Voie__c=commande.vlocity_cmt__DefaultServiceAccountId__r.inwib2c_voievalue__c,
            InwiB2C_Code_Voie__c=commande.vlocity_cmt__DefaultServiceAccountId__r.inwib2c_voiecode__c,
            InwiB2C_Numero_de_la_voie__c=commande.vlocity_cmt__DefaultServiceAccountId__r.inwib2c_numvoievalue__c,
            InwiB2C_Code_de_Numero_de_la_voie__c=commande.vlocity_cmt__DefaultServiceAccountId__r.inwib2c_numvoiecode__c,
            InwiB2C_codeRoutage__c=codeRoutage,
            InwiB2C_Portabilite__c=(Portability=='Oui')?'OUI':'NON',
            InwiB2C_Rio__c=rio
        );
    }

}
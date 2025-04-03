// JBE - BEGIN
global class InwiB2C_CreateClonedAsset {

    @future (callout=true)
    Public static void CloneAsset(String inMap)
    { 
        System.debug('inside myMethod...'); //do your callout logic here... System.debug('exiting myMethod...');
        Map <String, Object> outMap = new Map <String, Object> ();
        Map <String, Object> options = new Map <String, Object> ();
        Map <String, Object> inputMap = (Map <String, Object>)JSON.deserializeUntyped(inMap);
        system.debug(inMap);

        // get Template Order based on account segment
        String AccountId = (String) inputMap.get('inwiB2C_CustomerId__c');
        //CHB 05/03/24 Ano B-14523 begin*/
        String profileId = (String) inputMap.get('inwiB2C_ProfileId__c');
        //CHB 05/03/24 Ano B-14523 end*/
        String accountSegment = [Select Inwib2c_Segment_march__c from Account where Id =:AccountId limit 1].Inwib2c_Segment_march__c;
        String assetIdTemplate;
        //CHB 05/03/24 Ano B-14523 begin*/
        if (accountSegment == 'Dealer' && profileId !='20707'){
            assetIdTemplate = [Select MasterLabel, InwiB2C_AssetId__c, Label from InwiB2C_IdAssetToClone__mdt where label = 'AssetDealer' limit 1].InwiB2C_AssetId__c;
        }//CHB 05/03/24 Ano B-14523 end*/
        else if(profileId =='20707'){
            assetIdTemplate = [Select MasterLabel, InwiB2C_AssetId__c, Label from InwiB2C_IdAssetToClone__mdt where label = 'TicTacAssetCampus' limit 1].InwiB2C_AssetId__c;
        } 
        //CHB 05/03/24 Ano B-14523 end*/
        else{
            assetIdTemplate = [Select MasterLabel, InwiB2C_AssetId__c, Label from InwiB2C_IdAssetToClone__mdt where label = 'TicTacAsset' limit 1].InwiB2C_AssetId__c;
        }
       
        //get the list of the assets having as the rootitemid the template id
        List<Asset> genericAssetsList= [SELECT Product2Id, vlocity_cmt__JSONAttribute__c,  vlocity_cmt__PricingLogData__c from ASSET where vlocity_cmt__RootItemId__c = :assetIdTemplate order by AssetLevel asc];

        // get input values
        String currentAssetId = (String) inputMap.get('inwiB2C_assetId__c');
        String inwiB2C_Mdn = (String) inputMap.get('inwiB2C_Mdn__c');
        String inwiB2C_Icc = (String) inputMap.get('inwiB2C_Icc__c');
        String inwiB2C_imsi = (String) inputMap.get('inwiB2C_imsi__c');
        String inwiB2C_ki = (String) inputMap.get('inwiB2C_ki__c');
        String inwiB2C_ProfileId = (String) inputMap.get('inwiB2C_ProfileId__c');
        String inwiB2C_puk = (String) inputMap.get('inwiB2C_puk__c');
        String inwiB2C_CodeArticle = (String) inputMap.get('inwiB2C_CodeArticle__c');
        String inwiB2C_SimOCSID = (String) inputMap.get('inwiB2C_SimOCSID__c');
        String inwiB2C_MdnOCSID = (String) inputMap.get('inwiB2C_MdnOCSID__c');
         //Amine brm ESIM
        String inwib2c_TypeCarteSIM = (String) inputMap.get('inwib2c_TypeCarteSIM__c');
        // get articlelabel
        List<vlocity_cmt__PicklistValue__c> articleLabelValue = [select Name from vlocity_cmt__PicklistValue__c  where vlocity_cmt__PicklistId__r.vlocity_cmt__Code__c = 'INWIB2C_PLK_MODELE_CARTE_SIM' and vlocity_cmt__Code__c=:inwiB2C_CodeArticle limit 1];
        string CodeArticleName;
        if (articleLabelValue.size()>0){
            CodeArticleName = articleLabelValue[0].Name;
        }


        //Get current AssetItems
        //chb 15-03-2024 SF24-026_Activation roaming MRE begin */
        //List<Asset> currentAssetList = [SELECT Product2Id, vlocity_cmt__JSONAttribute__c,  vlocity_cmt__PricingLogData__c, ProductCode,vlocity_cmt__OrderProductId__c, Name from ASSET where vlocity_cmt__RootItemId__c = :currentAssetId or id =:currentAssetId limit 20];
        List<Asset> currentAssetList = [SELECT Id,Product2Id, vlocity_cmt__JSONAttribute__c,  vlocity_cmt__PricingLogData__c, ProductCode,vlocity_cmt__OrderProductId__c, Name from ASSET where vlocity_cmt__RootItemId__c = :currentAssetId or id =:currentAssetId limit 20];
        //chb 15-03-2024 SF24-026_Activation roaming MRE end */
        //Build map of Template Assets with ProductId as Key
        Map<String, Asset> genericAssetItemsMap = new Map<String, Asset> ();
        for (Asset genericAT: genericAssetsList){
            
            genericAssetItemsMap.put(genericAT.Product2Id, genericAT);
        }

        // Loop through current Assets to update JSON attributes and Pricing Log
        if(!Test.isRunningTest()) {
        for (Asset currentAsset: currentAssetList){
            currentAsset.vlocity_cmt__JSONAttribute__c = genericAssetItemsMap.get(currentAsset.Product2Id).vlocity_cmt__JSONAttribute__c;
            currentAsset.vlocity_cmt__PricingLogData__c = genericAssetItemsMap.get(currentAsset.Product2Id).vlocity_cmt__PricingLogData__c;
            }
        }
        update currentAssetList;
         //chb 15-03-2024 SF24-026_Activation roaming MRE begin */
        String JsonRoaming;
        List<Asset> assetRoaming = new List<Asset>();
        //chb 15-03-2024 SF24-026_Activation roaming MRE end */
        for (Asset currentAsset: currentAssetList){
            if(currentAsset.ProductCode == 'INWIB2C_OFFERING_MSISDN_STANDARD'){
                string datajsonMdn = '{"id":"'+currentAsset.id+'", "mdn":"'+inwiB2C_Mdn+'","ocsId":"'+inwiB2C_MdnOCSID+'"}';
                vlocity_cmt.DRProcessResult resultMdn = vlocity_cmt.DRGlobal.processObjectsJSON(datajsonMdn, 'inwiB2C_SetAssetMDNAttributes');

                Map<String, Object> resultMapMdn = resultMdn.convertToMap();
                System.debug(JSON.serialize(resultMapMdn));
            }

            if(currentAsset.ProductCode == 'INWIB2C_OFFERING_TICTAC_SANS_TERMINAL' || currentAsset.ProductCode == 'INWIB2C_OFFERING_DEALER_SANS_TERMINAL'){
                string datajsonOffre = '{"id":"'+currentAsset.id+'", "profilIn":"'+inwiB2C_ProfileId+'"}';
                vlocity_cmt.DRProcessResult resultOffre = vlocity_cmt.DRGlobal.processObjectsJSON(datajsonOffre, 'inwiB2C_SetAssetOfferAttributes');
    
                Map<String, Object> resultMapOffre = resultOffre.convertToMap();
                System.debug(JSON.serialize(resultMapOffre));
            }
            if(currentAsset.ProductCode == 'INWIB2C_OFFERING_SIM'){
                //Amine brm Update attribute Type Sim 
                string datajsonSim = '{"AssetId":"'+currentAsset.id+'", "mdn":"'+inwiB2C_Mdn+'","ocsId":"'+inwiB2C_SimOCSID+'","accountId":"'+AccountId+'","icc":"'+inwiB2C_Icc+'","imsi":"'+inwiB2C_imsi+'","ki":"'+inwiB2C_ki+'","name":"'+currentAsset.Name+'","puk":"'+inwiB2C_puk+'","typeSim":"'+inwib2c_TypeCarteSIM+'"}';
                vlocity_cmt.DRProcessResult resultSim = vlocity_cmt.DRGlobal.processObjectsJSON(datajsonSim, 'inwiB2C_SetAssetSIMAttributes');
    
                Map<String, Object> resultMapSim = resultSim.convertToMap();
                System.debug(JSON.serialize(resultMapSim)); 
            }
            //chb 15-03-2024 SF24-026_Activation roaming MRE begin */
            if(currentAsset.ProductCode == 'INWIB2C_OFFERING_SRV_ROAMING' && profileId =='5292' ){
              JsonRoaming= INWIB2CJSONAttributeUtilities.updateAttributeValueFromJSON(currentAsset.vlocity_cmt__JSONAttribute__c,'INWIB2C_ATT_RT_ROAMING_VOIX_SMS','Roaming Voix+SMS+Data');
              assetRoaming.add(new Asset (id = currentAsset.Id, vlocity_cmt__JSONAttribute__c = JsonRoaming));
            }
        }
        if(!Test.isRunningTest() &&  assetRoaming.size() > 0) {
            update assetRoaming;
        }
        //chb 15-03-2024 SF24-026_Activation roaming MRE end */

        /*String procedureName = 'inwib2c_inwib2c_UpdateAssetAttributes';
        // Call the IP via runIntegrationService, and save the output to ipOutput 
        outMap = (Map<String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService(procedureName, inputMap, options);
        System.debug('IP Output UpdateAssetAttributes: ' + outMap);*/
        }



}
// JBE - END
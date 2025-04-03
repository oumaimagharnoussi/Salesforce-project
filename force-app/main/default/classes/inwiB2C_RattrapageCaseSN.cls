public without sharing class inwiB2C_RattrapageCaseSN implements Database.Batchable<sObject>, Database.AllowsCallouts  {

    private String token;
    private Integer limitRecords;
    private String dateFilter;
    private Integer timeIntervalInMinutes;
    private Integer batchSize;
    private String caseId; // TEMP
    
    public inwiB2C_RattrapageCaseSN(String dateFilter, Integer limitRecords, Integer timeIntervalInMinutes, Integer batchSize, String caseId) {
        this.limitRecords = limitRecords;
        this.dateFilter = dateFilter;
        this.timeIntervalInMinutes = timeIntervalInMinutes;
        this.batchSize = batchSize;
        this.caseId = caseId; // TEMP
    }

    public Database.QueryLocator start(Database.BatchableContext bc){
        
        String query = '';
        String[] conditions = new List<String>();
        String[] fields = new List<String>();
        fields.add('CaseNumber');
        fields.add('CreatedBy.Name');
        fields.add('CreatedDate');
        fields.add('Inwib2c_Cat_gorie__c');
        fields.add('InwiB2C_Detail__c');
        fields.add('InwiB2C_Qualification__c');
        fields.add('InwiB2C_Qualification_AUDA__c');
        fields.add('InwiB2C_TypeSpecialite__c');
        fields.add('Status');
        fields.add('Subject');
        fields.add('Type');
        fields.add('Description');
        fields.add('vlocity_cmt__SubscriptionId__c');
        fields.add('vlocity_cmt__SubscriptionId__r.Inwib2c_Num_ro_de_la_ligne__c');
        fields.add('vlocity_cmt__SubscriptionId__r.InwiB2C_Id_profil__c');
        fields.add('Inwib2c_la_file_d_attente__c');
        conditions.add('InwiB2C_LastEscaladeDate__c = ' + dateFilter);
        conditions.add('(Inwib2c_la_file_d_attente__c = \'Support Technique ADSL B2C N1\' OR Inwib2c_la_file_d_attente__c = \'Support Technique FTTH B2C N1\')');
        conditions.add('Status = \'InwiB2C_Escalade\'');
        conditions.add('Type = \'Inwib2c_HelpDesk\'');
        conditions.add('Inwib2c_Cat_gorie__c = \'Inwib2c_Assistance/service _HelpDesk\'');
        conditions.add('InwiB2C_Incident_SN__c = \'\'');
        conditions.add('InwiB2C_Detail__c <> \'\'');
        conditions.add('Subject <> \'\'');
        conditions.add('ID = :caseId '); // TEMP
        if (!Test.isRunningTest()){
            conditions.add('vlocity_cmt__SubscriptionId__c <> NULL');
        } 
        query = ' SELECT ' + String.join(fields, ', ');
        query += ' FROM Case ';
        query += ' WHERE ' + String.join(conditions, ' AND ');
        query += ' ORDER BY CreatedDate ASC ';
        if (limitRecords != null && limitRecords != 0) query += ' LIMIT ' + limitRecords;
        
        System.Debug('query >> ' + query);
        
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<Case> cases){        
        this.token = getToken();
        List<Case> casesToUpdate = new List<Case>();
        List<InwiB2C_Trace_API__c> traceAPIs = new List<InwiB2C_Trace_API__c>();
        for(Case sfCase : cases){
            String uuid = UUID.randomUUID().toString();
            
            SNRequestWrapper snw = new SNRequestWrapper(sfCase);
            
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setEndpoint('callout:InwiB2C_APIGEE_EXT/incidents/v1');
            req.setHeader('Authorization', 'Bearer ' + this.token);
            req.setHeader('canal', 'SF');
            req.setHeader('content-type', 'application/json');
            req.setHeader('user', 'SF');
            req.setHeader('uuid', uuid);
            req.setTimeout(120000);
            req.setBody(JSON.serialize(snw));
            Http h = new Http();
            HttpResponse res = h.send(req);
            Map<String, Object> retObj = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            String uNumber;
            String status;
            String message;
            try {
                uNumber = (String) retObj.get('uNumber');
            } catch (Exception ex) {}
            try {
                status = (String) retObj.get('status');
            } catch (Exception ex) {}
            try {
                message = (String) retObj.get('message');
            } catch (Exception ex) {}
            if (String.isEmpty(uNumber)){
                if (String.isNotEmpty(status) && status == 'error') {
                    if (String.isNotEmpty(message) && message.contains('existe déjà en base et liée à l\'incident')){
                        String[] splittedMessage = message.split(' ');
                        uNumber = splittedMessage[splittedMessage.size() - 1].trim();
                    }
                }
            }
            if (String.isNotEmpty(uNumber)) {
                casesToUpdate.add(new Case(Id = sfCase.Id, InwiB2C_Incident_SN__c = uNumber));
            }
            
            traceAPIs.add(new InwiB2C_Trace_API__c(
                InwiB2C_API_Name__c = 'CreateCaseSN_Rattrapage',
                InwiB2C_request_body__c = JSON.serialize(snw),
                InwiB2C_Response__c = res.getBody()
            ));
        }
                
        if (casesToUpdate.size() > 0) update casesToUpdate;
        if (traceAPIs.size() > 0) insert traceAPIs;
    }

    public void finish(Database.BatchableContext bc){
        // System.scheduleBatch(
        //     new inwiB2C_RattrapageCaseSN(dateFilter, limitRecords, timeIntervalInMinutes, batchSize),
        //     'Rattrapage Create Case SN ' + Datetime.now().toString(),
        //     timeIntervalInMinutes,
        //     batchSize
        // );
    }

    public String getToken(){
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:InwiB2C_APIGEE_EXT/oauth/token');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setTimeout(120000);
        req.setBody('client_id=JLI1LVKWxXtJYxAQ5l6MxBij8GOGI5qQMumGE9v5VIPwCpya&client_secret=pr9mWyhEDkAqpnxJPLM28OZiV4lcruiOXGFfkP9rX9sumLWCTqNGfMzZygxAuwxI');
        Http h = new Http();
        HttpResponse res = h.send(req);
        Map<String, Object> retObj = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        //System.debug((String) retObj.get('access_token'));
        return (String) retObj.get('access_token');
    }

    private class SNRequestWrapper {
        public String caseSF;
        public String correlationId;
        public String createdByInCRM;
        public String crmCreationDate;
        public String description;
        public String shortDescription;
        public String typeIncident;
        public String assignmentGroup;
        public String creationGroup;
        public String category;
        public String subSubcategory;
        public String subcategory;
        public String ndCrm;
        public SNRequestWrapper(Case sfCase){
            caseSF = sfCase.CaseNumber;
            correlationId = sfCase.Id;
            createdByInCRM = sfCase.CreatedBy.Name;
            //yyyy-MM-dd HH:mm:ss
            crmCreationDate = sfCase.CreatedDate.format('yyyy-MM-dd HH:mm:ss');
            description = String.isNotEmpty(sfCase.Description) ? sfCase.Description.replaceAll('\\r', ' ').replaceAll('\\n', ' ').replaceAll('\\t', ' ') : '';
            shortDescription = String.isNotEmpty(sfCase.Subject) ? sfCase.Subject.replaceAll('\\r', ' ').replaceAll('\\n', ' ').replaceAll('\\t', ' ') : '';
            typeIncident = sfCase.InwiB2C_Qualification__c;
            assignmentGroup = caseFileAttenteAG(sfCase.Inwib2c_la_file_d_attente__c);
            creationGroup = caseFileAttenteCG(sfCase.Inwib2c_la_file_d_attente__c);
            InwiB2C_Typologie_Mapping_SF_SN__c mappingItem = searchCaseCategory(sfCase);
            String caseTypeOffre = typeOffreFromProfile(
                !Test.isRunningTest() ? sfCase.vlocity_cmt__SubscriptionId__r.InwiB2C_Id_profil__c : '89510',
                sfCase.InwiB2C_Qualification_AUDA__c
            );
            
            category = caseTypeOffre;
            subSubcategory = mappingItem.InwiB2C_DetailSN__c;
            subcategory = mappingItem.InwiB2C_Sous_categorieSN__c;
            ndCrm = !Test.isRunningTest() ? sfCase.vlocity_cmt__SubscriptionId__r.Inwib2c_Num_ro_de_la_ligne__c : '212600003791';
        }

        private InwiB2C_Typologie_Mapping_SF_SN__c searchCaseCategory(Case sfCase){
            String caseCategory = sfCase.Inwib2c_Cat_gorie__c;
            String caseDetail = sfCase.InwiB2C_Detail__c;
            String caseTypeOffre = typeOffreFromProfile(
                !Test.isRunningTest() ? sfCase.vlocity_cmt__SubscriptionId__r.InwiB2C_Id_profil__c : '89510',
                sfCase.InwiB2C_Qualification_AUDA__c
            );
            String caseTypeSpecialit = sfCase.InwiB2C_TypeSpecialite__c;
            String caseDetailIn = String.escapeSingleQuotes(caseDetail);
            
            // Construct the WHERE clause 
            String whereClause = ' WHERE  ';
            if (String.isNotBlank(caseCategory)) {
                whereClause += ' InwiB2C_CategorieSF__c = \'' + caseCategory + '\'';
            }
            if (String.isNotBlank(caseDetailIn)) {
                whereClause += ' AND InwiB2C_DetailSF__c = \'' + caseDetailIn + '\'';
            }
            if (String.isNotBlank(caseTypeOffre)) {
                whereClause += ' AND InwiB2C_Type_de_offreSF__c = \'' + caseTypeOffre + '\'';
            }
            if (String.isNotBlank(caseTypeSpecialit)) {
                whereClause += ' AND InwiB2C_Type_de_specialiteSF__c = \'' + caseTypeSpecialit + '\'';
            }
            
            String query = 'SELECT Id, InwiB2C_Sous_categorieSN__c , ' +
            ' InwiB2C_DetailSN__c  '+
            ' FROM InwiB2C_Typologie_Mapping_SF_SN__c ' + whereClause + ' LIMIT 1 ' ;
            
            // System.debug(query);
            return (InwiB2C_Typologie_Mapping_SF_SN__c) Database.query(query);
        }

        private String caseFileAttenteAG(String caseFile){
            if (String.isEmpty(caseFile)) return '';
            if (caseFile == 'Support Technique ADSL B2C N1') return 'DSL_SUP1_BO';
            if (caseFile == 'Support Technique FTTH B2C N1') return 'FTTH_SUP2';
            return caseFile;
        }
    
        private String caseFileAttenteCG(String caseFile){
            if (String.isEMpty(caseFile)) return '';
            if (caseFile == 'Support Technique ADSL B2C N1') return 'DSL_SUP1_FO';
            if (caseFile == 'Support Technique FTTH B2C N1') return 'FTTH_SUP1_FO';
            return caseFile;
        }
    
        private String typeOffreFromProfile(String profile, Boolean auda){
            String typeOffre = 'ADSL';
            if (String.isEmpty(profile)) typeOffre = 'ADSL';
            else if (profile == '88594') typeOffre = 'FTTH';
            else if (profile == '88595') typeOffre = 'FTTH';
            else if (profile == '88596') typeOffre = 'FTTH';
            else if (profile == '88986') typeOffre = 'FTTH';
            else if (profile == '89508') typeOffre = 'FTTH';
            else if (profile == '89509') typeOffre = 'FTTH';
            else if (profile == '89510') typeOffre = 'FTTH';
            else typeOffre = 'ADSL';
            if (typeOffre == 'FTTH' && auda) typeOffre = 'AUDA';
            else if (typeOffre == 'FTTH') typeOffre = 'FTTH';
            else typeOffre = 'ADSL';
            return typeOffre;
        }
    }

    
}
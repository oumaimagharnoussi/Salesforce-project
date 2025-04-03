public with sharing class InwiB2C_RetailStore {
    @AuraEnabled
    public static Id RetailStoreRecord(String firstName, String lastName,String Name, String ActivityType, String longitude, String latitude, String MdnDealer) {
        
        List<INWIB2C_GroupName__mdt> TemplateMD = [select inwiB2C_BoutiqueId__c from INWIB2C_GroupName__mdt];
        List<INWIB2C_StoreProduct__mdt> TemplateMDProduct = [select inwiB2C_ProductId__c from INWIB2C_StoreProduct__mdt];

        Contact contact=new Contact();
        contact.FirstName = firstName;
        contact.LastName = lastName;
        insert contact;

        Account account=new Account();
        account.Name = Name ;
        account.vlocity_cmt__PrimaryContactId__c= contact.Id;
        insert account ;

        contact.AccountId=account.Id;
        update contact;
        Schema.Location newLocation = new Schema.Location(Name = Name ) ;
        insert newLocation;
        //RetailLocationGroup newRetailLocationGroup = new RetailLocationGroup();
        //newRetailLocationGroup.Name=RtailGroupName;
        //insert newRetailLocationGroup;
        
        Schema.RetailStore store = new Schema.RetailStore();
        store.Name = Name;
        store.AccountId = account.Id;
        store.PrimaryContactId = contact.Id;
        store.LocationId = newLocation.Id;
        //store.RetailLocationGroupId = '0Y23L0000004CFiSAM';
        store.RetailLocationGroupId = TemplateMD[0].inwiB2C_BoutiqueId__c;
        store.inwiCGC_TypeActivite__c = ActivityType;
        store.Latitude = Decimal.valueOf(latitude);
        store.Longitude= Decimal.valueOf(longitude);
        store.inwiB2C_MDN__c = MdnDealer;
        insert store;

        InStoreLocation storeLocation = new InStoreLocation();
        storeLocation.Name= 'Main';
        storeLocation.Category='Generic';
        storeLocation.RetailStoreId = store.Id;
        storeLocation.LocationId = newLocation.Id;
        insert storeLocation;

        StoreProduct productStore = new StoreProduct();
        productStore.ProductId = TemplateMDProduct[0].inwiB2C_ProductId__c;
        productStore.RetailStoreId = store.Id;
        productStore.InStoreLocationId= storeLocation.Id;
        productStore.StartDate= System.Today() ;
        insert productStore;


        System.debug('Longitude: ' + longitude + ' Latitude: ' + latitude);
        
        return store.id;
    }
    @AuraEnabled
    public static map<String,Object> GetRetailStoreInformations(Id recordId2 ) {
       List<Schema.RetailStore> InfoStore = [select Id,Name,inwiCGC_TypeActivite__c,inwiB2C_MDN__c,PrimaryContact.FirstName,PrimaryContact.LastName  from RetailStore where Id =: recordId2 LIMIT 1];
       map<String,Object> InfoActeurMarche= new map<String,Object> ();
       InfoActeurMarche.put('Id',InfoStore[0].Id);
       InfoActeurMarche.put('FirstName',InfoStore[0].PrimaryContact.FirstName);
       InfoActeurMarche.put('LastName',InfoStore[0].PrimaryContact.LastName);
       InfoActeurMarche.put('Name',InfoStore[0].Name);
       InfoActeurMarche.put('MdnDealer',InfoStore[0].inwiB2C_MDN__c);
       InfoActeurMarche.put('TypeActivite',InfoStore[0].inwiCGC_TypeActivite__c);
       return InfoActeurMarche;

    }
}
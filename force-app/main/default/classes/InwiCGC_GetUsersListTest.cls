@isTest
public class InwiCGC_GetUsersListTest {
    @isTest
    static void getUsersTest(){
        Schema.Location locationTest = new Schema.Location();
        locationTest.Name='locationTest';
        insert locationTest;
        
        Account parentAccount = new Account(Name='Test Account');
        insert parentAccount;

        
        Schema.Address addressTest = new Schema.Address();
        addressTest.ParentId = locationTest.Id;
        insert addressTest;
        
        Profile profilTest = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User userTest = new User(Alias = 'test', Email='test@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profilTest.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testgetUserList@testorg.com');
        insert userTest;
        
        Visit visitTest = new Visit(
            PlannedVisitStartTime=DateTime.now(),
            PlaceId=addressTest.Id,
            VisitorId=userTest.Id
        );
        insert visitTest;
        InwiCGC_GetUsersList.getUsers(visitTest.Id);
    }
    
    @isTest
    static void getCloseRetailStores(){
        Account AccountTest = new Account(Name='Test Account');
        insert AccountTest;
        Schema.RetailStore retailStoreTest = new Schema.RetailStore(Name='Retail Store Test',inwiCGC_TypeActivite__c='Cyber',AccountId=AccountTest.Id);
        retailStoreTest.City='Casablanca';
        retailStoreTest.country='Morocco';
        retailStoreTest.geocodeAccuracy='Block';
        retailStoreTest.latitude=33.559574722025225;
        retailStoreTest.longitude=-7.539961110579985;
        retailStoreTest.postalCode='20250';
        retailStoreTest.state='state';
        retailStoreTest.street='1 Boulevard Moulay Rachid';
        insert retailStoreTest;
        InwiCGC_GetUsersList.getCloseRetailStores(retailStoreTest.latitude,retailStoreTest.longitude);
    }
}
@isTest
public class INWIB2C_SendSMSToPhoneTest {

    @isTest
    public static void testSendSMS() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Contact contact = new Contact(FirstName = 'John', LastName = 'Doe', AccountId = acc.Id, Phone = '212637908217');
        insert contact;

        Order ord = new Order(AccountId = acc.Id, Status = 'Draft', EffectiveDate = Date.today());
        insert ord;

        Test.setMock(HttpCalloutMock.class, new MockHttp());

        Map<String, Object> options = new Map<String, Object>();
        options.put('orderId', ord.Id);

        Test.startTest();
        INWIB2C_SendSMSToPhone.sendSMS(new Map<String, Object>(), new Map<String, Object>(), options);
        Test.stopTest();
    }

    @isTest
    public static void testInvokeMethodWithInvalidOrderId() {
        Map<String, Object> options = new Map<String, Object>();
        options.put('orderId', ''); // Empty orderId

        Test.startTest();
        INWIB2C_SendSMSToPhone sendSMSInstance = new INWIB2C_SendSMSToPhone();
        Boolean result = sendSMSInstance.invokeMethod('sendSMS', new Map<String, Object>(), new Map<String, Object>(), options);
        Test.stopTest();

        System.assertEquals(false, result, 'Expected result to be false when orderId is missing or empty.');
    }

    @isTest
    public static void testInvokeMethodWithUnknownMethod() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        Order ord = new Order(AccountId = acc.Id, Status = 'Draft', EffectiveDate = Date.today());
        insert ord;

        Map<String, Object> options = new Map<String, Object>();
        options.put('orderId', ord.Id);

        Test.startTest();
        INWIB2C_SendSMSToPhone sendSMSInstance = new INWIB2C_SendSMSToPhone();
        Boolean result = sendSMSInstance.invokeMethod('unknownMethod', new Map<String, Object>(), new Map<String, Object>(), options);
        Test.stopTest();

        System.assertEquals(false, result, 'Expected result to be false when an unknown method is called.');
    }

    public class MockHttp implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setStatus('OK');
            return res;
        }
    }
}
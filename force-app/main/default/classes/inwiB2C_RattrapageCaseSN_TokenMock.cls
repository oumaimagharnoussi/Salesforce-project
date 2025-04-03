global class inwiB2C_RattrapageCaseSN_TokenMock implements HttpCalloutMock  {
    global HTTPResponse respond(HTTPRequest req) {
        //req.getEndpoint()
        HttpResponse res = new HttpResponse();
        if (req.getEndpoint().contains('oauth/token')){
            // Mock token response
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"refresh_token_expires_in":0,"api_product_list":"[SLF_PRODUCT]","api_product_list_json":["SLF_PRODUCT"],"organization_name":"inwi-apigee-prod","developer.email":"yassine.zenouaki@inwi.ma","token_type":"Bearer","issued_at":"1716999833218","client_id":"JLI1LVKWxXtJYxAQ5l6MxBij8GOGI5qQMumGE9v5VIPwCpya","access_token":"LGizr8PynU0BjHwS3uD7i2dZf49L","application_name":"83407196-cb5c-4e84-8d33-cc2f5e473f3e","scope":"","expires_in":3599,"refresh_count":"0","status":"approved"}');
            res.setStatusCode(200);
        }
        else if (req.getEndpoint().contains('incidents/v1')){
            // Mock create case response
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status":"error","message":"Enregistrement non inséré : Le Correlation ID renseigné 500a2000001GPWXAA4 existe déjà en base et liée à l\'incident INC1772997"}');
            res.setStatusCode(200);
        }
        return res;
    }
}
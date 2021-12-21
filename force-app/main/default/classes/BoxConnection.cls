public with sharing class BoxConnection {
    public static final String HEADER_CONTENT_TYPE = 'Content-Type';
    public static final String HEADER_APPLICATION_ENCODED = 'application/x-www-form-urlencoded';
    public static final String TOKEN_URL_STRING = 'https://api.box.com/oauth2/token';
    public static final String USER_URL_STRING = 'https://api.box.com/2.0/users';
 	private static String publicKeyId = '';
   	private static String privateKey = '';
 	private static String enterpriseId = '';
 	private static String clientId = '';
 	private static String clientSecret = '';
    private static BoxConnection instance = null;
    public BoxPlatformApiConnection api { get; private set; }
    public String accessToken { get; private set; }
       	private static BoxJwtEncryptionPreferences preferences = new BoxJwtEncryptionPreferences();


    private BoxConnection() {


             String publicKeyId = 'ifg5grsh';//boxJwtConnection.Public_Key_ID__c;
            String privateKey = 'MIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDeDUt4cqE8hLm7l5Zez3Ht8bmb9EDrNziz5JYkLx4kVl+/vIFn5ZUm2n2epadV3A7IoOnLy9kqKLSE/F68jWuDhUsEU4E5vRCYkRqxKeKf1ZKqIAHctYYhPgMP54zBQTmvcIYxrxywW+LiBhbcrYx5FIBDSpjYqSSEbsEosO+3GSOsock+HSNy0jxDcD5KmbTfY0QdnzrQIy6N2hbQHQcgUrAqPoZBza4SEoETwsJHL2kFt3c1+PCOGBEePxwgVjnbZJMWJMuO3+csotDaL13M8uEdXQ2WFf3vviWw5EYiUxQoDaXyFjYcis+nbkyE/ryQuC8OwKg2E6NkvuP6BkRZAgMBAAECggEAN5R0U429tfwy0TW8ObcK+VgL8XFN3pJP6xdITX5NuSK1jLSOX4cjsjn2P4OPQvp16Nn+Kzi2/sp5hN/2hpOPWbg/crHEIsOkJ8wKNlYZl5BJybOBQ9Fb5W40LgLzRFwjKDquHDmMoMgfHhwQFOSLyLLM+Arv/ys3LL7cMmc3WUjGKH0fknKwJeEG4G7giyU8DOgmC+btds+Lq99LIqVIEdhmKYLk2h0ZkN+S5fdftfk9nLhkuaKa7H6LstIqMLdoj4Gn5EUw0gyY2zQFPsOYCWqZU20ty8J+LHy6VZIKYCp0Rv3XgxgHqeS5FUNLizTT8OjtSpfotRf1CUm3Y9ZsQQKBgQD3gL14IpBjcJk6T+36+GBm+fvo8pFFoBE3wHuWBR/TKyFg/1ng9fSJAhKtxiAyspeaP8vSqLD5l0L158onRUbs5sc3++emyrLxN55vLm0HWo1ZZ6AvNcs5kVJqOvlNQQyoVIggRZWQuL6bZjIF/yoaO4bYWxEzR+HWUsStUEAgbQKBgQDlrN7ij89gzbS4RLHgiQESr1d0Uv2U1zmwda4L58KLbVnidTkxbAdH7TYjPn40O7/D8XYDh3x0U0JYTeYtbdsILnJq7ZbEZVTt2FnVLIa93glZjA/fjCvmR+cpmk4aHhAbBvz2VY2mS9ImfZfmqcfpt+8Cn+DYSyIZdSA4Ex34HQKBgQDNrYDGmwKegG31lYLQ8yM5sDh1p06uK4zjZePOEcgWtlrwvoM0fXCPgtd+7YzIVL3Dg4ygLWuUnu0YaV0HMXz1VfrsPTyO0RfPeUcCYfRdDhU03PazBOMznd59RTDz0EDyifztxKW8NKrBfTXI4flc/2bZ2SP8F5pHf1TOKkiAKQKBgQCPQ7YEPRBuoeIIz1DlbpBsx1MWDG6BWX9ywvU+F+MSdbOLvvNeELS5+Q28Dk9K5bpIz2V97hWDuiu4SV87Fzt5bv+QE4PoHg1MD5h5kLy70rSiVuvP1e/MRS28lbQCNp51PXatcdBZ2xHLUKxgBafd8g305SWrxbIPjy/5ynL3QQKBgQCie7XPn55XkkZdVarM0nhQIB94fqE2IxY9HccVjw4Gi1kZ0eoodBKyARugOEJaQ/NugMTwyyw4QE0LDVfYbkHzobKHxMWodqgA9jTmLB3z+KevJBFH2RfDKKYKl/IxgTGi+U+ZeTbzBjA+IKVcC8Hev97aUiDqQWYm/9/rVO/vKg==';//boxJwtConnection.Private_Key__c;
            String enterpriseId = '47757585';//boxJwtConnection.Enterprise_ID__c;
            String clientId = 'bn2iyg37p78jkowrp0io0nc2ln0be3wt';//boxJwtConnection.Client_ID__c;
            String clientSecret = 'C45GViJjUNr3QWvCSXlJAXbbfYBeHyPZ';//;


		    preferences.setPublicKeyId(publicKeyId);
		    preferences.setPrivateKey(privateKey);
		    api = BoxPlatformApiConnection.getAppEnterpriseConnection(enterpriseId, clientId, clientSecret, preferences);
            accessToken = api.getAccessToken();
    }

    public static BoxConnection getInstance() {
        if(instance == null) {
            instance = new BoxConnection();
        }
        return instance;
    }

    @AuraEnabled(cacheable=true)
    public static String exchangeToken(String parentToken, String scopes, String resource) {
        String downscopedToken;
        
        // Construct the JWT URL parameters
        String urlParameters = 
            String.format('subject_token={0}' +
       		'&subject_token_type=urn:ietf:params:oauth:token-type:access_token' +
            '&grant_type=urn:ietf:params:oauth:grant-type:token-exchange' +
            '&scope={1}', new String[] {parentToken, scopes});

        // Get a service account connection
        BoxConnection box = BoxConnection.getInstance();
        BoxPlatformApiConnection api = box.api;
        
        // Create the request object
        BoxApiRequest request = new BoxApiRequest(api, TOKEN_URL_STRING, BoxApiRequest.METHOD_POST);
        request.shouldAuthenticate = false;
        request.setBody(urlParameters);
        request.addHeader(HEADER_CONTENT_TYPE, HEADER_APPLICATION_ENCODED);
        request.setTimeout(api.getTimeout());
        
        // Issue the POST request and parse the response
        HttpResponse response = request.send();
        if (response.getStatus() == 'OK') {
            BoxGenericJsonObject authResponse = new BoxGenericJsonObject(response.getBody());
            downscopedToken = authResponse.getValue('access_token');
        } else {
            System.debug('BoxPlatformApiConnection unable to authenticate to generate tokens');
        }
        
        return downscopedToken;    
    }

    public static String getTokenForUser(String parentToken,Id extUserId) {
        String userToken;
        
        // Construct the JWT URL parameters
        String queryString = 'external_app_user_id='+extUserId + '&fields=id';
        // Get a service account connection
        BoxConnection box = BoxConnection.getInstance();
        BoxPlatformApiConnection api = box.api;
        
        // Create the request object
        BoxApiRequest request = new BoxApiRequest(api, USER_URL_STRING+'?'+queryString, BoxApiRequest.METHOD_GET);
        request.shouldAuthenticate = true;
        request.setTimeout(api.getTimeout());
        // Issue the POST request and parse the response
        HttpResponse response = request.send();
        String userId='';
        if (response.getStatus() == 'OK') {
            BoxGenericJsonObject authResponse = new BoxGenericJsonObject(response.getBody());
            System.debug(authResponse.getValue('entries'));
            JSONParser parser = JSON.createParser(authResponse.getJsonString ());
			list<String> childEntries = BoxJsonObject.parseJsonObjectArray(authResponse.getValue('entries'));
    		for (String entry : childEntries) {
    			BoxGenericJsonObject entryObject = new BoxGenericJsonObject(entry);
                userId = entryObject.getValue('id');
                break;
            }
    		
        } else {
            System.debug('BoxPlatformApiConnection unable to authenticate to generate tokens');
        }
        BoxPlatformApiConnection userApi = new BoxPlatformApiConnection(userId, BoxPlatform.PlatformEntityType.USER, clientId, clientSecret, preferences);
        system.debug(userApi.getAccessToken());
        return userApi.getAccessToken();    
    }
}

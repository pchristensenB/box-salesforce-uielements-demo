public with sharing class BoxAppUserHandler {
    private static final String USERS_URL_TEMPLATE = 'users';

    @future(callout=true)
    public static void createAppUser(String name, String userRecordID) {
        // Get an instance of a BoxPlatformApiConnection
        BoxConnection box = BoxConnection.getInstance();
        BoxPlatformApiConnection api = box.api;

        // Construct the request body to send to Box
        BoxGenericJsonObject requestJson = new BoxGenericJsonObject();
        requestJson.addValue('name', 'SFDC ' + name);
        requestJson.addValue('is_platform_access_only', 'true');
        requestJson.addValue('external_app_user_id', userRecordID);

        // Construct the request object
        String createAppUserUrl = api.baseUrl + USERS_URL_TEMPLATE;
        BoxApiRequest request = new BoxApiRequest(api, createAppUserUrl, BoxApiRequest.METHOD_POST);
        request.setBody(requestJson.getJsonString());
        request.setTimeout(api.timeout);
        request.addJsonContentTypeHeader();

        // Sent the POST request to Box to create the App User
        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxUser.createEnterpriseUser');
        BoxUser.Info boxAppUserInfo = new BoxUser.Info(responseBody);
        System.debug('Created App User with name: ' + boxAppUserInfo.name + ' and id: ' + boxAppUserInfo.id);
        //Now add a secure folder for the user with the user name in 'Secure Document Exchange'
        BoxFolder folder = new BoxFolder(api,'151444700983');
        BoxFolder.Info newFolder = folder.createFolder(name);
        collaborateWithCanViewPath(api,newFolder.id,boxAppUserInfo.id,'viewer',false);
    }
 
 
 public static void collaborateWithCanViewPath(BoxPlatformApiConnection api,String newFolderId,String emailOrId,String role,boolean useEmail) {
         if(!emailOrId.equals('NOT FOUND')) {
             BoxApiRequest request = new BoxApiRequest(api, 'https://api.box.com/2.0/collaborations', BoxApiRequest.METHOD_POST);
            request.shouldAuthenticate = true;
            request.setTimeout(api.getTimeout());
            BoxGenericJsonObject  requestJson = new BoxGenericJsonObject ();
            BoxGenericJsonObject  itemJson = new BoxGenericJsonObject ();
            itemJson.addValue('id',newFolderId);
            itemJson.addValue('type','folder');              
            requestJson.addValue('item', itemJson);
            requestJson.addValue('role', role);
            requestJson.addValue('can_view_path', 'true');
            BoxGenericJsonObject  accessibleByJson = new BoxGenericJsonObject ();
            if(useEmail) {
                accessibleByJson.addValue('login',emailOrId);
            }
            else {
                accessibleByJson.addValue('id',emailOrId);
            }
            accessibleByJson.addValue('type','user');
            requestJson.addValue('accessible_by',accessibleByJson);
            request.setBody(requestJson.getJsonString());
            HttpResponse response = request.send();
            System.debug(response);
         }
    }
   
}
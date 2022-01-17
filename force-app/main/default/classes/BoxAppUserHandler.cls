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
        
        //READ THIS FOR SETTING UP APP USER ACCESS TO FOLDER
        //Here you need to create/select a folder that the JWT Service Account has access to.
        //This next part will add a new folder in this folder with the name of your user and set a collaboration with view path
        //Then you can use the same folder as the 'Standalone Box Content explorer' and see differnet content based on user
        BoxFolder folder = new BoxFolder(api,'FOLDER ID HERE');
        BoxFolder.Info newFolder = folder.createFolder(name);
        collaborateWithCanViewPath(api,newFolder.id,boxAppUserInfo.id,'viewer',false);

        //The next part adds the app user to the account Box Folder
        List<User> users = [select id,contactId from user where id=:userRecordID LIMIT 1];
        Contact con = [select id,accountId from contact where id =:users[0].contactId limit 1];
        box__FRUP__c frup = [SELECT box__Folder_ID__c, box__Record_ID__c FROM box__FRUP__c WHERE box__Record_ID__c = :con.accountId LIMIT 1];
        String accountFolderId = frup.box__Folder_ID__c;
        BoxFolder folder = new BoxFolder(api,accountFolderId);
        BoxFolder.Info newFolder = folder.createFolder('External Collaboration');
        collaborateWithCanViewPath(api,newFolder.id,boxAppUserInfo.id,'viewer uploader',false);
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
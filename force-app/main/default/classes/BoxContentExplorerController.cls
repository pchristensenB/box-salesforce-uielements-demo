public without sharing class BoxContentExplorerController {

    @AuraEnabled(cacheable=true)
    public static Map<String,String> getContentExplorerMap(String recordId) {
        System.debug('Found record id: ' + recordId);
        String folderId=null;
        // Get a service account connection
        BoxConnection box = BoxConnection.getInstance();
        BoxPlatformApiConnection api = box.api;
        try {
        // Get the record folder
            box__FRUP__c frup = [SELECT box__Folder_ID__c, box__Record_ID__c FROM box__FRUP__c WHERE box__Record_ID__c = :recordId LIMIT 1];
            folderId = frup.box__Folder_ID__c;
            System.debug('Found folder with id: ' + folderId);
        }
        catch(Exception e) {
            System.debug(e);
        }
  
       
        // Get the service account access token
        String accessToken = box.accessToken;
        //This will try to fetch a token for the logged in user if there is a mapped app user. If not it
        //will return the service account token
        accessToken = box.getTokenForUser(accessToken,Id.valueOf(UserInfo.getUserId()));

        // Create a resource for the folder
        String resource = 'https://api.box.com/2.0/folders/' + folderId;
        System.debug('Downscoping resource: ' + resource);

        // Exchange the service account access token for a downscoped token that is safer
        String scopes = 'base_explorer item_preview item_download item_rename item_delete item_share item_upload root_readwrite annotation_view_all annotation_edit';
        
        
        
        String downscopedToken = BoxConnection.exchangeToken(accessToken, scopes, resource); 
		

        // Create the map to return to the lightning component
        Map<String,String> contentExplorerMap = new Map<String,String>();
        contentExplorerMap.put('downscopedToken', downscopedToken);
        contentExplorerMap.put('folderId', folderId);
        return contentExplorerMap;
    }
   

}

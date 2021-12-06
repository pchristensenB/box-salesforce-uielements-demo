public with sharing class BoxPreviewController {

    @AuraEnabled(cacheable=true)
    public static Map<String,String> getContentExplorerMap(String documentId) {
		System.debug('User:' + UserInfo.getUserId());
        System.debug('DocumentId:' + documentId);
        // Get a service account connection
        BoxConnection box = BoxConnection.getInstance();
        BoxPlatformApiConnection api = box.api;

       
        // Get the service account access token
        String accessToken = box.accessToken;
  		
        // Create a resource for the folder
        //String resource = 'https://api.box.com/2.0/folders/' + folderId;
        //System.debug('Downscoping resource: ' + resource);

        // Exchange the service account access token for a downscoped token that is safer
        //String scopes = 'base_explorer item_preview item_download item_rename item_delete item_share item_upload root_readwrite annotation_view_all annotation_edit';
        //String downscopedToken = BoxConnection.exchangeToken(accessToken, scopes, resource); 
		//accessToken = BoxConnection.getTokenForUser(accessToken,Id.valueOf(UserInfo.getUserId()));
        // Create the map to return to the lightning component
        Map<String,String> contentExplorerMap = new Map<String,String>();
        contentExplorerMap.put('downscopedToken', accessToken);
        contentExplorerMap.put('documentId', documentId);
        return contentExplorerMap;
    }
}
({
    doInit : function(component, event, helper) {
        var action = component.get("c.getContentExplorerMap");
        var recordId = component.get("v.recordId");

        action.setParams({ recordId: recordId });
        action.setCallback(this, function(response) {
            var contentUploaderMap = response.getReturnValue();            
            var downscopedToken = contentUploaderMap.downscopedToken; 
            var folderId = contentUploaderMap.folderId;
            if(folderId == null || !folderId){
                folderId = component.get("v.folderId");
            }
            if(folderId != null) {
                var baseURL = window.location.origin;
                var logoUrl = component.get("v.logoUrl");
                var uploader = new Box.ContentUploader();
                var uploaderContainer = component.find("uploader-container").getElement();
                uploader.show(folderId, downscopedToken, {
                    container: uploaderContainer
                });
                uploader.addListener('complete', function(file) {
                    var counter = 0;
                    var target = file.length;
                    console.log("Upload complete");
                    
                   
                });
            }
            else {
                var elemDiv = document.createElement('div');
                elemDiv.innerHTML='Could not find folder associated with record'
                var uploaderContainer = component.find("uploader-container").getElement();
                uploaderContainer.appendChild(elemDiv);
            }
        });
        $A.enqueueAction(action);
    }
})

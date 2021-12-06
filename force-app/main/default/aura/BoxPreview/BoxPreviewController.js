({
    doInit : function(component, event, helper) {
        var action = component.get("c.getContentExplorerMap");
        var documentId = component.get("v.documentId");

        action.setParams({ documentId: documentId });
        action.setCallback(this, function(response) {
            var contentUploaderMap = response.getReturnValue();            
            var downscopedToken = contentUploaderMap.downscopedToken; 
            var documentId = contentUploaderMap.documentId;
            if(documentId == null || !documentId){
                documentId = component.get("v.documentId");
            }
            if(documentId != null) {
                var baseURL = window.location.origin;
                var logoUrl = component.get("v.logoUrl");
                var preview = new Box.Preview();
                var previewContainer = component.find("preview-container").getElement();
                preview.show(documentId, downscopedToken, {
                    container: previewContainer
                });
             
            }
            else {
                var elemDiv = document.createElement('div');
                elemDiv.innerHTML='Could not find document'
                var uploaderContainer = component.find("preview-container").getElement();
                uploaderContainer.appendChild(elemDiv);
            }
        });
        $A.enqueueAction(action);
    }
})

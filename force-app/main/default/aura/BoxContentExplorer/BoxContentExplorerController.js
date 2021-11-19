({
    doInit : function(component, event, helper) {
        var action = component.get("c.getContentExplorerMap");
        var recordId = component.get("v.recordId");

        action.setParams({ recordId: recordId });
        action.setCallback(this, function(response) {
            var contentExplorerMap = response.getReturnValue();            
            var downscopedToken = contentExplorerMap.downscopedToken; 
            var folderId = contentExplorerMap.folderId;
    
            if(folderId != null) {
                var baseURL = window.location.origin;
                var previewResource = $A.get("$Resource.preview");
                var logoUrl = component.get("v.logoUrl");
                var explorer = new Box.ContentExplorer();
                var explorerContainer = component.find("explorer-container").getElement();
                explorer.show(folderId, downscopedToken, {
                    container: explorerContainer,
                    logoUrl: logoUrl,
                    autoFocus: true,
                    canPreview: true,
                    canDownload: true,
                    canUpload: true,
                    canCreateNewFolder: true,
                    canDelete: true,
                    canRename: true,
                    canShare: true,
                    canSetShareAccess: true,
                    staticHost: baseURL,
                    contentUploaderProps: {
                        isFolderUploadEnabled:true,
                    },
                    staticPath: previewResource,
                        previewLibraryVersion: '2.12.0',
                    contentPreviewProps: {
                        
                        showAnnotations: true,
                        contentSidebarProps: {
                            detailsSidebarProps: {
                                hasNotices: true,
                                hasProperties: true,
                                hasAccessStats: true,
                                hasVersions: true
                            },
                            hasActivityFeed: true,
                            hasSkills: true,
                            hasMetadata: true
                        },
                        contentOpenWithProps: {
                            show: false
                        }
                    }
                });
                explorer.addListener('upload', function(file){
                    console.log('upload complete')
                    let action = component.get("c.sendEmail");
                    action.setParams({
                        'recordId': recordId
                    });
                    action.setCallback(this, function(response) {
                        var state = response.getState();
                        console.log("state is " + state)
                        if (state === "SUCCESS") {
                            var storeResponse = response.getReturnValue();
                        }
                        else if (state === "ERROR") {
                            var errors = response.getError();
                            if (errors) {
                                if (errors[0] && errors[0].message) {
                                    console.log("Error message: " + 
                                             errors[0].message);
                                }
                            } else {
                                console.log("Unknown error");
                            }
                        }
            
             
                    });
                    $A.enqueueAction(action);

                });
            }
            else {
                var elemDiv = document.createElement('div');
                elemDiv.innerHTML='Could not find folder associated with record'
                var explorerContainer = component.find("explorer-container").getElement();
                explorerContainer.appendChild(elemDiv);
            }
        });
        $A.enqueueAction(action);
    }
})

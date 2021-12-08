({
  doInit: function (component, event, helper) {
    var action = component.get("c.getContentExplorerMap");
    var recordId = component.get("v.recordId");
    action.setParams({ recordId: recordId });

    action.setCallback(this, function (response) {
      console.log("in get container");
      var contentExplorerMap = response.getReturnValue();
      var downscopedToken = contentExplorerMap.downscopedToken;
      var folderId = contentExplorerMap.folderId;

      if (folderId != null) {
        var baseURL = window.location.origin;
        var previewResource = $A.get("$Resource.preview");
        var logoUrl = component.get("v.logoUrl");
        var explorer = new Box.ContentExplorer();
        var explorerContainer = component
          .find("explorer-container2")
          .getElement();
        const fields = ["metadata.enterprise_123456.templateKey.fieldKey"];
        const fieldsToShow = [
          {
            key: "metadata.enterprise_123456.templateKey.fieldKey",
            canEdit: true
          }
        ];
        const query = "fieldKey  is null";
        const query_params = { arg1: "Arggh" };
        const mdQuery = {
          from: "enterprise_123456.templateKey",
          query: query,
          limit: 20,
          query_params: query_params,
          ancestor_folder_id: folderId,
          fields: fields
        };
        explorer.show(folderId, downscopedToken, {
          container: explorerContainer,
          metadataQuery: mdQuery,
          fieldsToShow: fieldsToShow,
          defaultView: "metadata",
          logoUrl: logoUrl,
          autoFocus: true,
          staticHost: baseURL,
          staticPath: previewResource,
          previewLibraryVersion: "2.12.0",
          contentUploaderProps: {
            isFolderUploadEnabled: true
          },
          contentPreviewProps: {
            showAnnotations: false,
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
      }
    });
    $A.enqueueAction(action);
  }
});

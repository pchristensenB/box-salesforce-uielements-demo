public with sharing class BoxRecordFolderHandler {
    @future(callout=true)
    public static void createFolder(Id recordId, Id userId) {
        // Instantiate the Toolkit object
        box.Toolkit boxToolkit = new box.Toolkit();

	    box.Toolkit.CollaborationType collabType = box.Toolkit.CollaborationType.EDITOR;
        String collabId = boxToolkit.createCollaborationOnRecord(userId, recordId, collabType, true);
        
        // Commit changes
        boxToolkit.commitChanges();
    }
    @future(callout=true)
     public static void createOpportunityFolder(Id recordId, Id userId,String accountId) {
        // Instantiate the Toolkit object
        box.Toolkit boxToolkit = new box.Toolkit();
        box.Toolkit.CollaborationType collabType = box.Toolkit.CollaborationType.EDITOR;
		String oppFolderId = boxToolkit.createFolderForRecordId(recordId, null, true);
	    boxToolkit.createCollaborationOnRecord(userId,recordId, collabType,false);

		String accFolderId = boxToolKit.getFolderIdByRecordId(accountId);
        boxToolKit.moveFolder(oppFolderId,accFolderId,null);
        // Commit changes
        boxToolkit.commitChanges();
    }
}
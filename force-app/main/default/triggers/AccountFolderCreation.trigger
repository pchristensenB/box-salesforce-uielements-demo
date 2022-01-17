trigger AccountFolderCreation on Account (after insert) {

    boolean isFirstRun = true;
    for(Account insertedAccount: Trigger.new) {
        if(isFirstRun) {
            //This will create a Box folder for this account on account creation
            BoxRecordFolderHandler.createFolder(insertedAccount.Id, UserInfo.getUserId());
            isFirstRun = false;
        }
    }
}
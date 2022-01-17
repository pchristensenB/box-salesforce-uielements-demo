trigger OpportunityTrigger on Opportunity (after insert) {
boolean isFirstRun = true;
    for(Opportunity insertedOpportunity: Trigger.new) {
        if(isFirstRun) {
            //This will create a Box folder for the opportunity and move it to the account folder for the account
            BoxRecordFolderHandler.createOpportunityFolder(insertedOpportunity.Id, UserInfo.getUserId(),insertedOpportunity.accountId);
            isFirstRun = false;
        }
    }
}
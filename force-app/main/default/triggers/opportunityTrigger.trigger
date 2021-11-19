trigger opportunityTrigger on Opportunity (after insert) {
boolean isFirstRun = true;
    for(Opportunity insertedOpportunity: Trigger.new) {
        if(isFirstRun) {
            BoxRecordFolderHandler.createOpportunityFolder(insertedOpportunity.Id, UserInfo.getUserId(),insertedOpportunity.accountId);
            isFirstRun = false;
        }
    }
}
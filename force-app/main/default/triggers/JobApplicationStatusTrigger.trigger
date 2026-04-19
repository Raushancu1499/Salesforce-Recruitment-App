trigger JobApplicationStatusTrigger on Job_Application__c (after update) {

    // Store Position Ids
    Set<Id> positionIds = new Set<Id>();

    for(Job_Application__c ja : Trigger.new){
        if(ja.Position__c != null){
            positionIds.add(ja.Position__c);
        }
    }

    // Get all Job Applications for those Positions
    List<Job_Application__c> allApps = [
        SELECT Id, Status__c, Position__c
        FROM Job_Application__c
        WHERE Position__c IN :positionIds
    ];

    // Map to track if any application is NOT rejected
    Map<Id, Boolean> positionHasActiveApps = new Map<Id, Boolean>();

    for(Job_Application__c app : allApps){
        
        if(!positionHasActiveApps.containsKey(app.Position__c)){
            positionHasActiveApps.put(app.Position__c, false);
        }

        if(app.Status__c != 'Rejected'){
            positionHasActiveApps.put(app.Position__c, true);
        }
    }

    // Prepare Positions to update
    List<Position__c> positionsToUpdate = new List<Position__c>();

    for(Id posId : positionHasActiveApps.keySet()){
        
        // If NO active applications → close position
        if(positionHasActiveApps.get(posId) == false){
            
            Position__c pos = new Position__c(
                Id = posId,
                Position_Status__c = 'Closed'
            );
            
            positionsToUpdate.add(pos);
        }
    }

    if(!positionsToUpdate.isEmpty()){
        update positionsToUpdate;
    }
}
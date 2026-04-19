trigger JobApplicationDuplicateTrigger on Job_Application__c (before insert) {

    // Collect Position Ids and Candidate Ids from new applications
    Set<Id> positionIds  = new Set<Id>();
    Set<Id> candidateIds = new Set<Id>();

    for (Job_Application__c ja : Trigger.new) {
        if (ja.Position__c  != null) positionIds.add(ja.Position__c);
        if (ja.Candidate__c != null) candidateIds.add(ja.Candidate__c);
    }

    // Query existing applications for same position + candidate combo
    List<Job_Application__c> existingApps = [
        SELECT Id, Position__c, Candidate__c
        FROM Job_Application__c
        WHERE Position__c  IN :positionIds
          AND Candidate__c IN :candidateIds
    ];

    // Build a set of Position + Candidate combos already in the org
    Set<String> existingCombos = new Set<String>();
    for (Job_Application__c existing : existingApps) {
        existingCombos.add(String.valueOf(existing.Position__c) + '_' + String.valueOf(existing.Candidate__c));
    }

    // Flag duplicates
    for (Job_Application__c ja : Trigger.new) {
        String combo = String.valueOf(ja.Position__c) + '_' + String.valueOf(ja.Candidate__c);
        if (existingCombos.contains(combo)) {
            ja.addError('A Job Application for this candidate and position already exists!');
        }
    }
}


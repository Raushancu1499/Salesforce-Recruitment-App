global class AutoRejectBatch implements Database.Batchable<SObject> {

    // Step 1: Start Method (Fetch Records)
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        return Database.getQueryLocator(
            'SELECT Id, Status__c, Application_Date__c ' +
            'FROM Job_Application__c ' +
            'WHERE Status__c = \'Applied\''
        );
    }

    // Step 2: Execute Method (Process Records)
    global void execute(Database.BatchableContext bc, List<Job_Application__c> scope){
        
        List<Job_Application__c> toUpdate = new List<Job_Application__c>();

        for(Job_Application__c ja : scope){
            
            // 🔥 Changed -30 → -1 for testing
            if(ja.Application_Date__c != null &&
               ja.Application_Date__c < Date.today().addDays(-1)){
                
                ja.Status__c = 'Rejected';
                toUpdate.add(ja);

                System.debug('Rejecting Application: ' + ja.Id);
            }
        }
        
        // ✅ Update only required records (Best Practice)
        if(!toUpdate.isEmpty()){
            Database.update(toUpdate, false); // partial success
        }
    }

    // Step 3: Finish Method
    global void finish(Database.BatchableContext bc){
        System.debug('Batch Job Completed Successfully');
    }
}
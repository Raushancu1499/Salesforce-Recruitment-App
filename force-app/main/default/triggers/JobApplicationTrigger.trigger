trigger JobApplicationTrigger on Job_Application__c (before insert) {
    
    for(Job_Application__c ja : Trigger.new){
        
        // If Application Date is empty
        if(ja.Application_Date__c == null){
            ja.Application_Date__c = Date.today();
        }
    }
}
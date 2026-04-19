public with sharing class DashboardController {

    @AuraEnabled(cacheable=true)
    public static Map<String, Integer> getApplicationStats() {
        
        Map<String, Integer> stats = new Map<String, Integer>();

        stats.put('Total', [SELECT COUNT() FROM Job_Application__c]);
        stats.put('Applied', [SELECT COUNT() FROM Job_Application__c WHERE Status__c = 'Applied']);
        stats.put('Rejected', [SELECT COUNT() FROM Job_Application__c WHERE Status__c = 'Rejected']);
        stats.put('Interview', [SELECT COUNT() FROM Job_Application__c WHERE Status__c = 'Schedule Interview']);

        return stats;
    }
}
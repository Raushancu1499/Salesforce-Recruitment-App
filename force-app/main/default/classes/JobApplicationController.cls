public with sharing class JobApplicationController {

    // ---- For LWC: jobApplicationList ----

    @AuraEnabled(cacheable=true)
    public static List<Job_Application__c> getAllApplications() {
        return [
            SELECT Id, Name, Status__c, Application_Date__c, Position__c, Position__r.Name
            FROM Job_Application__c
            ORDER BY Application_Date__c DESC
            LIMIT 200
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Job_Application__c> getApplicationsByStatus(String status) {
        return [
            SELECT Id, Name, Status__c, Application_Date__c, Position__c, Position__r.Name
            FROM Job_Application__c
            WHERE Status__c = :status
            ORDER BY Application_Date__c DESC
            LIMIT 200
        ];
    }

    // ---- For VF Page: JobApplicationReport ----
    public List<Job_Application__c> applications { get; set; }
    public String statusFilter { get; set; }
    public Integer totalCount { get; set; }
    public Integer appliedCount { get; set; }
    public Integer rejectedCount { get; set; }
    public Integer interviewCount { get; set; }

    public JobApplicationController() {
        statusFilter = 'All';
        loadData();
    }

    public void filterByStatus() {
        loadData();
    }

    private void loadData() {
        if (statusFilter == 'All' || statusFilter == null) {
            applications = [
                SELECT Id, Name, Status__c, Application_Date__c, Position__r.Name
                FROM Job_Application__c
                ORDER BY Application_Date__c DESC
                LIMIT 500
            ];
        } else {
            applications = [
                SELECT Id, Name, Status__c, Application_Date__c, Position__r.Name
                FROM Job_Application__c
                WHERE Status__c = :statusFilter
                ORDER BY Application_Date__c DESC
                LIMIT 500
            ];
        }

        totalCount    = [SELECT COUNT() FROM Job_Application__c];
        appliedCount  = [SELECT COUNT() FROM Job_Application__c WHERE Status__c = 'Applied'];
        rejectedCount = [SELECT COUNT() FROM Job_Application__c WHERE Status__c = 'Rejected'];
        interviewCount= [SELECT COUNT() FROM Job_Application__c WHERE Status__c = 'Schedule Interview'];
    }
}

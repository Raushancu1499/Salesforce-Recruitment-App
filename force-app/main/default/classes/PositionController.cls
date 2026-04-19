public with sharing class PositionController {

    // ---- For LWC: positionList ----

    @AuraEnabled(cacheable=true)
    public static List<Position__c> getOpenPositions() {
        return [
            SELECT Id, Name, Position_Status__c, Min_Pay__c, Max_Pay__c,
                   Functional_Area__c
            FROM Position__c
            WHERE Position_Status__c = 'Open'
            ORDER BY Name ASC
            LIMIT 200
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Position__c> getAllPositions() {
        return [
            SELECT Id, Name, Position_Status__c, Min_Pay__c, Max_Pay__c,
                   Functional_Area__c
            FROM Position__c
            ORDER BY Name ASC
            LIMIT 200
        ];
    }

    // ---- For VF Page: PositionReport ----
    public List<Position__c> positions { get; set; }
    public Integer openCount { get; set; }
    public Integer closedCount { get; set; }
    public Integer totalPositions { get; set; }
    public String statusFilter { get; set; }

    public PositionController() {
        statusFilter = 'All';
        loadPositions();
    }

    public void filterPositions() {
        loadPositions();
    }

    private void loadPositions() {
        if (statusFilter == 'All' || statusFilter == null) {
            positions = [
                SELECT Id, Name, Position_Status__c, Min_Pay__c, Max_Pay__c, Functional_Area__c
                FROM Position__c
                ORDER BY Name ASC
                LIMIT 500
            ];
        } else {
            positions = [
                SELECT Id, Name, Position_Status__c, Min_Pay__c, Max_Pay__c, Functional_Area__c
                FROM Position__c
                WHERE Position_Status__c = :statusFilter
                ORDER BY Name ASC
                LIMIT 500
            ];
        }

        openCount      = [SELECT COUNT() FROM Position__c WHERE Position_Status__c = 'Open'];
        closedCount    = [SELECT COUNT() FROM Position__c WHERE Position_Status__c = 'Closed'];
        totalPositions = [SELECT COUNT() FROM Position__c];
    }
}

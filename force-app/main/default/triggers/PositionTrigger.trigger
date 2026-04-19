trigger PositionTrigger on Position__c (before insert, before update) {
    
    for(Position__c pos : Trigger.new){
        
        if(pos.Min_Pay__c != null && pos.Max_Pay__c != null){
            
            if(pos.Min_Pay__c > pos.Max_Pay__c){
                pos.addError('Min Pay cannot be greater than Max Pay');
            }
        }
    }
}
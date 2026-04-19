trigger CompanyTrigger on Company__c (before insert, before update) {

    for (Company__c comp : Trigger.new) {

        // Rule: Company Name must not be blank
        if (comp.Name == null || comp.Name.trim() == '') {
            comp.Name.addError('Company Name is required and cannot be blank.');
        }
    }
}


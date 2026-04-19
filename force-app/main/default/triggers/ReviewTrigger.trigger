trigger ReviewTrigger on Review__c (before insert, before update) {

    for (Review__c rev : Trigger.new) {

        // Rule 1: Rating must be between 1 and 5
        if (rev.Rating__c != null) {
            if (rev.Rating__c < 1 || rev.Rating__c > 5) {
                rev.Rating__c.addError('Rating must be between 1 and 5.');
            }
        }

        // Rule 2: Feedback (Comments) is required
        if (rev.Feedback__c == null || rev.Feedback__c.trim() == '') {
            rev.Feedback__c.addError('Please provide feedback/comments for this review.');
        }
    }
}


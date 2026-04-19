global class InterviewReminderBatch implements Database.Batchable<SObject> {

    // Step 1: Query Job Applications with 'Schedule Interview' status
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id, Name, Status__c, Application_Date__c, Position__c, ' +
            'Candidate__c, Candidate__r.Email, Candidate__r.Name ' +
            'FROM Job_Application__c ' +
            'WHERE Status__c = \'Schedule Interview\''
        );
    }

    // Step 2: Send reminder emails to candidates
    global void execute(Database.BatchableContext bc, List<Job_Application__c> scope) {

        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        for (Job_Application__c ja : scope) {

            String candidateEmail = (ja.Candidate__r != null) ? ja.Candidate__r.Email : null;

            if (candidateEmail != null) {

                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new List<String>{ candidateEmail });
                mail.setSubject('Interview Reminder - ' + ja.Name);
                mail.setPlainTextBody(
                    'Dear ' + ja.Candidate__r.Name + ',\n\n' +
                    'This is a reminder that your interview is coming up.\n' +
                    'Application Reference: ' + ja.Name + '\n\n' +
                    'Please be prepared and on time.\n\n' +
                    'Best Regards,\nRecruitment Team'
                );

                emails.add(mail);
                System.debug('Sending reminder for: ' + ja.Id);
            }
        }

        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }
    }

    // Step 3: Finish
    global void finish(Database.BatchableContext bc) {
        System.debug('InterviewReminderBatch completed successfully.');
    }
}

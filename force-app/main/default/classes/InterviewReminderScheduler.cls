global class InterviewReminderScheduler implements Schedulable {

    /**
     * Runs every day at 8:00 AM to send interview reminders.
     * To schedule: System.schedule('Daily Interview Reminder', '0 0 8 * * ?', new InterviewReminderScheduler());
     */
    global void execute(SchedulableContext sc) {
        InterviewReminderBatch batch = new InterviewReminderBatch();
        Database.executeBatch(batch, 200);
    }
}

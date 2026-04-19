global class AutoRejectScheduler implements Schedulable {

    global void execute(SchedulableContext sc) {
        
        // Call your Batch Class
        AutoRejectBatch batch = new AutoRejectBatch();
        Database.executeBatch(batch, 200);
    }
}
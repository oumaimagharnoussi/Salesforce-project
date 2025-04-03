global class inwiB2C_RattrapageCaseSN_Schedule implements Schedulable {
    /*global Integer timeIntervalInMinutes;
    global String dateFilter;
    global Integer limitRecords;
    global Integer batchSize;
    

    global inwiB2C_RattrapageCaseSN_Schedule(Integer timeIntervalInMinutes, String dateFilter, Integer limitRecords, Integer batchSize){
        this.dateFilter = dateFilter;
        this.limitRecords = limitRecords;
        this.batchSize = batchSize;
        this.timeIntervalInMinutes = timeIntervalInMinutes; 
    }
    */
    global void execute(SchedulableContext SC) {
        System.debug('executing at >> ' + datetime.now());
    }
}
@isTest
private class WarehouseCalloutServiceTest {
  @isTest static void testPostCallout() {
      // Set mock callout class 
      Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock()); 
      // This causes a fake response to be sent
      // from the class that implements HttpCalloutMock. 
      WarehouseCalloutService.runWarehouseEquipmentSync();
   
  }
   @isTest static void WarehouseSyncSchedule() {
    String CRON_EXP = '0 0 0 15 3 ? 2022';
     String jobId = System.schedule('WarehouseSyncScheduleTest',
            CRON_EXP, 
            new WarehouseSyncSchedule());         
   
  }
}
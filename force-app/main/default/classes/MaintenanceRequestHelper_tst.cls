@isTest 
public class MaintenanceRequestHelper_tst {
    @isTest static void TestMaintenanceRequest() {
        // Test data setup
        // Create an account with an opportunity, and then try to delete it
        
        Vehicle__c veh = new Vehicle__c(Name='Test');
        insert veh;
        Product2  prod= new Product2(Name='Test',Replacement_Part__c=true,Maintenance_Cycle__c=2);
        insert prod;
        Case cas =   new Case (
                Date_Reported__c = Date.today(),
                Date_Due__c      = Date.today().addDays(2),      
                Status           = 'New',
                Origin           = 'Web',
                Type             = 'Routine Maintenance',
                Subject          = 'Test',
                Vehicle__c       = veh.Id,
                Equipment__c     = prod.Id               
           );
        insert cas;
        Work_Part__c wp= new Work_Part__c(Equipment__c=prod.Id,Quantity__c=1,Maintenance_Request__c=cas.Id);
        insert wp;
        //Case cas = new Case(Name='Test Account');
        //insert cas;
        // Perform test
        Test.startTest();
        cas.Status='Closed';
        update cas;
        Test.stopTest();
        // Verify 
        // In this case the deletion should have been stopped by the trigger,
        // so verify that we got back an error.
    }
}
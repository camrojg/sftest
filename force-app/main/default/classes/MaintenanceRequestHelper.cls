public class MaintenanceRequestHelper {
    
    public static void updateWorkOrders(List<Case> listcases){
    Set<String> setCasesId = new Set<String>();
    Map<String,Case> MapCases= new  Map<String,Case> ();
    List<Case> lstnewcases = new List<Case>();
    Map<String,Decimal> mapShiftofFund =new  Map<String,Decimal>();
    for(Case objMant:listcases){
        if((objMant.Type=='Routine Maintenance' || objMant.Type=='Repair') && objMant.Status == 'Closed' ){
            setCasesId.add(objMant.Id);
            MapCases.put(objMant.Id,objMant);
        }    
    }
    List<AggregateResult> listWp =[SELECT Maintenance_Request__c, MIN(Equipment__r.Maintenance_Cycle__c) FROM Work_Part__c WHERE Maintenance_Request__c IN :setCasesId GROUP BY Maintenance_Request__c];
  
    for(AggregateResult aggResult : listWp)
    {
        mapShiftofFund.put((String)aggResult.get('Maintenance_Request__c'), (Decimal)aggResult.get('expr0'));
    }

    for (Id key : MapCases.keySet()) {
        Integer Numdays=0;
        if( mapShiftofFund.containskey(key))
            Numdays=Integer.valueOf((Decimal) mapShiftofFund.get(key));
        lstnewcases.add(
            new Case (
                Date_Reported__c = Date.today(),
                Date_Due__c      = Date.today().addDays(Numdays),      
                Status           = 'New',
                Origin           = 'Web',
                Type             = 'Routine Maintenance',
                Subject          = MapCases.get(key).Subject,
                Vehicle__c       = MapCases.get(key).Vehicle__c,
                Equipment__c     = MapCases.get(key).Equipment__c               
           )                  
       );

    }

 



    if(!lstnewcases.isEmpty())
        insert lstnewcases;
    }    
    
}
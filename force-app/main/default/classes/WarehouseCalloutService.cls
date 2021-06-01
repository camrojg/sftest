public with sharing class WarehouseCalloutService {

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    
    // complete this method to make the callout (using @future) to the
    // REST endpoint and update equipment on hand.
    @future (callout=true)
    public static void runWarehouseEquipmentSync(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(WAREHOUSE_URL);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        List<Product2> lstOfEqup = new List<Product2>();
        if (response.getStatusCode() == 200) {
            //SDASdas
            List<EquipmentMap> lstOfEquipments = (List<EquipmentMap>) JSON.deserialize(response.getBody(), List<EquipmentMap>.class);
            for(EquipmentMap Objequ: lstOfEquipments){
                Product2 prod = new Product2();
                prod.Cost__c = Objequ.Cost;
                prod.Lifespan_Months__c = Objequ.Lifespan;
                prod.Maintenance_Cycle__c = Objequ.MaintenancePeriod;
                prod.Name = Objequ.Name;
                prod.Current_Inventory__c = Objequ.Quantity;
                prod.Replacement_Part__c = Objequ.Replacement;
                prod.Warehouse_SKU__c = Objequ.Sku;
                lstOfEqup.add(prod);
            }
            if(!lstOfEqup.isEmpty())
               Upsert lstOfEqup Warehouse_SKU__c;
        }
    }
      public class EquipmentMap{

        public Integer MaintenancePeriod;
        public Integer Lifespan;
        public Integer Cost;
        public String  Sku;   
        public String  EquipmentId;
        public Boolean Replacement;
        public Integer Quantity;
        public String  Name;
  
    }
    
  
}
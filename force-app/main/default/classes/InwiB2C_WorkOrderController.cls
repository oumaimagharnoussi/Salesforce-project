public with sharing class InwiB2C_WorkOrderController {
    public String workOrderNumber { get; set; }
    public String workOrderStatus { get; set; }

        String procedureName = 'InwiB2C_GetInfoWoWotSN';
        Map<String, Object> ipInput = new Map<String, Object>();
        public Map<String, Object> ipOutput{ get; set; }
        Map<String, Object> ipOptions = new Map<String, Object>();
    
       public InwiB2C_WorkOrderController() {       
    
               
        String idOrder = ApexPages.currentPage().getParameters().get('id');

        // Appelez la VIP en passant l'OrderId pour récupérer les informations du Work order
        ipInput.put('OrderId', idOrder);
        ipOutput = (Map<String, Object>)(vlocity_cmt.IntegrationProcedureService.runIntegrationService(procedureName, ipInput, ipOptions)); 

        // Récupérez les informations du Work order depuis la réponse de la VIP
        workOrderNumber = (String)ipOutput.get('workOrderNumber');
        workOrderStatus = (String)ipOutput.get('workOrderStatus');    
    
        // Ajoutez des messages de débogage pour vérifier les valeurs
        System.debug('workOrderNumber: ' + workOrderNumber);
        System.debug('workOrderStatus: ' + workOrderStatus);
    }
}
public with sharing class InwiB2C_Document_Cameleons {
    public Date dueDate { get; set; }
    public String formattedDueDate { get; set; }

    public InwiB2C_Document_Cameleons(ApexPages.StandardController controller) {
        // Calcul de la date limite de paiement
        this.dueDate = InwiB2C_PaymentDueDateCalculator.calculateDueDate();

        // Conversion de la date au format jj/MM/yyyy
        this.formattedDueDate = DateTime.newInstance(dueDate.year(), dueDate.month(), dueDate.day()).format('dd/MM/yyyy');
    }
}

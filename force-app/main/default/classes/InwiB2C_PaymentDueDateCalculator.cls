public with sharing class InwiB2C_PaymentDueDateCalculator {
    public static Date calculateDueDate() {
        // Obtenir la date système actuelle
        Date today = System.today();
        
        // Ajouter 30 jours
        Date dueDate = today.addDays(30);

        // Vérifier si la date est valide (éviter 31 février, etc.)
        Integer lastDayOfMonth = Date.daysInMonth(dueDate.year(), dueDate.month());
        if (dueDate.day() > lastDayOfMonth) {
            dueDate = Date.newInstance(dueDate.year(), dueDate.month(), lastDayOfMonth);
        }

        return dueDate;
    }
}
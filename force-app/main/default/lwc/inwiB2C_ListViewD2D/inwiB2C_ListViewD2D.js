import { LightningElement, wire, api } from 'lwc';
import getOrderList from '@salesforce/apex/InwiB2C_ListViewsD2D.getOrdersForUserQueue';

export default class InwiB2C_ListViewD2D extends LightningElement {
    @api recordId;
    records;
    error;
    sortedBy = 'CreatedDate'; // Champ trié par défaut
    sortedDirection = 'asc'; // Direction du tri par défaut

    columns = [
        { label: 'Commandes', fieldName: 'OrderLink', type: 'url', typeAttributes: { label: { fieldName: 'OrderNumber' }, target: '_blank' }},
        { label: 'Statut', fieldName: 'inwiB2C_Statut__c', type: 'text' },
        { label: 'Type de commande', fieldName: 'inwib2c_TypeDeLaCommande__c', type: 'text' },
        { label: 'Date de création', fieldName: 'CreatedDate', type: 'date', sortable: true },
        { label: 'Offre', fieldName: 'InwiB2C_Offre__c', type: 'text' },
        { label: 'Type d\'offre', fieldName: 'InwiB2C_Type_Offer__c', type: 'text' },
        { label: 'POS Code', fieldName: 'POSCODE', type: 'text' },
        { label: 'Animateur D2D', fieldName: 'Animateur', type: 'text' }
    ];

    @wire(getOrderList, { accountId: '$recordId' })
    wiredOrders({ error, data }) {
        if (data) {
            this.records = data.map(order => ({
                ...order,
                OrderLink: `/BackOfficeDistributeurD2D/s/order/${order.Id}/view`, 
                InwiB2C_Statut_Order__c: order.Status,
                // Remove the prefix "InwiB2C_" from the beginning of the field
                Type_commande__c: order.inwib2c_TypeDeLaCommande__c ? order.inwib2c_TypeDeLaCommande__c.replace('inwiB2C_', '') : '' ,
                CreatedDate: order.CreatedDate,
                offre: order.InwiB2C_Offre__c,
                TypeOffre: order.InwiB2C_Type_Offer__c ,
                POSCODE: order.inwib2c_Partenaire__r.inwib2c_CodePartenaire__c
                ,
                Animateur: order.inwiB2C_Animateur_D2D__r.Name
            }));
            this.error = undefined;
        } else if (error) {
            this.error = error;
        }
    }

    handleSort(event) {
        const { fieldName, sortDirection } = event.detail;
        this.sortedBy = fieldName;
        this.sortedDirection = sortDirection;

        let cloneData = [...this.records];
        cloneData.sort((a, b) => {
            let aValue = a[fieldName] || '';
            let bValue = b[fieldName] || '';

            if (fieldName === 'CreatedDate') {
                aValue = new Date(aValue);
                bValue = new Date(bValue);
            }

            return sortDirection === 'asc'
                ? aValue > bValue ? 1 : -1
                : aValue < bValue ? 1 : -1;
        });

        this.records = cloneData;
    }
}
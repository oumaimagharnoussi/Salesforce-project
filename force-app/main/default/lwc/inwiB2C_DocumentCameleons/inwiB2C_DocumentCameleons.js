import { LightningElement, api } from 'lwc';

export default class InwiB2C_DocumentCameleons extends LightningElement {
    @api recordId; // Identifiant du record, transmis par OmniScript

    get vfPageUrl() {
        // URL de la page Visualforce
        return `/apex/InwiB2C_Document_Cameleons?id=${this.recordId}`;
    }
}
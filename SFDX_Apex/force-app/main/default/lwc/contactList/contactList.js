import { LightningElement,wire } from 'lwc';
import First_Name from '@salesforce/schema/Contact.FirstName';
import Last_Name from '@salesforce/schema/Contact.LastName';
import Email from '@salesforce/schema/Contact.Email';

import getContacts from '@salesforce/apex/ContactController.getContacts';
import { reduceErrors } from 'c/ldsUtils';
const columns = [
    { label: 'First Name', fieldName: First_Name.fieldApiName, type: 'text' },
    { label: 'Last Name', fieldName: Last_Name.fieldApiName, type: 'text' },
 { label: 'Email', fieldName: Email.fieldApiName, type: 'text' }
];

export default class ContactList extends LightningElement {

    columns = columns;  

    @wire(getContacts)
    contacts;

    get errors() {
    return (this.contacts.error) ?
        reduceErrors(this.contacts.error) : [];
}
}
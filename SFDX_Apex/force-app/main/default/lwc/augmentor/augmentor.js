import { LightningElement } from 'lwc';

export default class Augmentor extends LightningElement {
    //https://trailhead.salesforce.com/content/learn/projects/communicate-between-lightning-web-components/communicate-from-parent-to-child

    startCounter = 0;
    handleStartChange(event){
        this.startCounter = parseInt(event.target.value);
    }
    handleMaximizeCounter() {
    this.template.querySelector('c-numerator').maximizeCounter();
  }
}
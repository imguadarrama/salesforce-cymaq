import { LightningElement, api } from "lwc";

export default class MaqcareReportDetails extends LightningElement {
  @api report;

  get arrivalMessage() {
    const hours = this.report.Hours_Left__c;
    if (hours > 0) {
      return `A technician will arrive in less than ${Math.ceil(hours)} hours`;
    }
    return "Technician arrival is due now";
  }

  handleCancel() {
    this.dispatchEvent(new CustomEvent("cancel"));
  }
}
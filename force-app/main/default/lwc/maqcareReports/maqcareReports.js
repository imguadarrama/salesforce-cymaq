import { LightningElement, wire } from "lwc";
import { refreshApex } from "@salesforce/apex";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getReports from "@salesforce/apex/MaqcareReportController.getReports";
import fileReport from "@salesforce/apex/MaqcareReportController.fileReport";

export default class MaqcareReports extends LightningElement {
  description = "";
  wiredResult;
  reports;

  @wire(getReports)
  wiredReports(result) {
    this.wiredResult = result;
    this.reports = result.data;
  }

  handleChange(event) {
    this.description = event.target.value;
  }

  async handleSubmit() {
    try {
      await fileReport({ description: this.description });
      this.description = "";
      await refreshApex(this.wiredResult);
    } catch (error) {
      this.dispatchEvent(
        new ShowToastEvent({
          title: "Could not file report",
          message: error.body.message,
          variant: "error"
        })
      );
    }
  }
}

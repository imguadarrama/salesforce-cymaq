import { LightningElement, wire } from "lwc";
import { refreshApex } from "@salesforce/apex";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getReports from "@salesforce/apex/MaqcareReportController.getReports";
import fileReport from "@salesforce/apex/MaqcareReportController.fileReport";
import cancelReport from "@salesforce/apex/MaqcareReportController.cancelReport";

export default class MaqcareReports extends LightningElement {
  wiredResult;
  reports;

  @wire(getReports)
  wiredReports(result) {
    this.wiredResult = result;
    this.reports = result.data;
  }

  get activeReport() {
    return this.reports && this.reports[0];
  }

  get hasActiveReport() {
    return !!this.activeReport;
  }

  async handleCreate(event) {
    await this.run(
      () => fileReport({ description: event.detail }),
      "Could not file report"
    );
  }

  async handleCancel() {
    await this.run(
      () => cancelReport({ reportId: this.activeReport.Id }),
      "Could not cancel report"
    );
  }

  async run(action, errorTitle) {
    try {
      await action();
      await refreshApex(this.wiredResult);
    } catch (error) {
      this.dispatchEvent(
        new ShowToastEvent({
          title: errorTitle,
          message: error.body.message,
          variant: "error"
        })
      );
    }
  }
}

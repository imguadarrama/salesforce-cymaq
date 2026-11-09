import { LightningElement } from "lwc";

export default class MaqcareReportForm extends LightningElement {
  description = "";

  get isBlank() {
    return !this.description.trim();
  }

  handleChange(event) {
    this.description = event.target.value;
  }

  handleSubmit() {
    this.dispatchEvent(new CustomEvent("create", { detail: this.description }));
  }
}
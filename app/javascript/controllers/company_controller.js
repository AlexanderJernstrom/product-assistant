import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="company"
export default class extends Controller {
  static targets = ["form"];
  connect() {
    console.log("hello");
  }

  handleSubmit(event) {}
}

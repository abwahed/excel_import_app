import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  submitForm(event) {
    event.preventDefault()
    const form = event.target.closest('form')

    if (form) {
      form.requestSubmit();
    }
  }
}

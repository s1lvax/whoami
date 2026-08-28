import { Controller } from "@hotwired/stimulus"

// Copies data-clipboard-text-value; any element inside with data-action="clipboard#copy"
// triggers it and flips to "Copied" for a moment.
export default class extends Controller {
  static values = { text: String, done: { type: String, default: "Copied" } }

  async copy(event) {
    const trigger = event.currentTarget
    try {
      await navigator.clipboard.writeText(this.textValue)
    } catch {
      window.prompt("Copy this link", this.textValue)
      return
    }
    const original = trigger.innerHTML
    trigger.innerHTML = this.doneValue
    trigger.classList.add("is-done")
    setTimeout(() => { trigger.innerHTML = original; trigger.classList.remove("is-done") }, 1600)
  }
}

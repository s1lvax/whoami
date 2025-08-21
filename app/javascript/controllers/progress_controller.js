
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["bar"]
  static values = { value: Number } // 0..100

  connect() {
    // Run after paint so CSS transition kicks in
    requestAnimationFrame(() => this.apply())
  }

  valueValueChanged() { this.apply() }

  apply() {
    const pct = Math.max(0, Math.min(100, Number(this.valueValue || 0)))
    if (this.hasBarTarget) this.barTarget.style.width = pct + "%"
  }
}

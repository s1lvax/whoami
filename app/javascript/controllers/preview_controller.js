import { Controller } from "@hotwired/stimulus"

// Keeps the phone on the right in sync: any Turbo submit or frame load
// (add/edit/remove a link, work entry, profile, post) reloads the public page.
export default class extends Controller {
  static targets = ["frame", "panel"]

  reload() {
    if (!this.hasFrameTarget) return
    clearTimeout(this.timer)
    if (this.hasPanelTarget) this.panelTarget.classList.add("is-refreshing")
    this.timer = setTimeout(() => { this.frameTarget.src = this.frameTarget.src }, 250)
  }

  loaded() {
    if (this.hasPanelTarget) this.panelTarget.classList.remove("is-refreshing")
  }
}

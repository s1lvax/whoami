// username_check_controller.js
import { Controller } from "@hotwired/stimulus"

// Live handle availability. Debounces the check, then mirrors the result as a
// state class on the controller element (is-checking / is-available / is-taken)
// so the field, the button and the status line can all react.
export default class extends Controller {
  static targets = ["input", "submit"]

  connect() {
    this.timer = null
    const frame = document.getElementById("username_status")
    if (frame) {
      this.observer = new MutationObserver(() => this.sync())
      this.observer.observe(frame, { childList: true, subtree: true })
    }
    if (this.hasSubmitTarget) this.submitLabel = this.submitTarget.textContent
  }

  disconnect() { this.observer?.disconnect(); clearTimeout(this.timer) }

  changed() {
    const el = this.inputTarget
    const cleaned = el.value.toLowerCase().replace(/[^a-z0-9]/g, "")
    if (cleaned !== el.value) el.value = cleaned

    clearTimeout(this.timer)

    if (cleaned.length === 0) return this.renderLocal("Type a username…", "")
    if (cleaned.length < 3)   return this.renderLocal("Min 3 characters", "")
    if (cleaned.length > 30)  return this.renderLocal("Max 30 characters", "is-error")

    this.renderLocal("Checking…", "is-checking")

    this.timer = setTimeout(() => {
      const frame = document.getElementById("username_status")
      if (!frame) return
      const url = new URL("/onboarding/check_username", window.location.origin)
      url.searchParams.set("username", cleaned)
      frame.src = url.toString()
    }, 250)
  }

  renderLocal(text, cls) {
    const frame = document.getElementById("username_status")
    if (!frame) return
    frame.innerHTML = `<span class="status ${cls}">${text}</span>`
    this.sync()
  }

  sync() {
    const status = document.querySelector("#username_status .status")
    const el = this.element
    el.classList.remove("is-checking", "is-available", "is-taken")
    if (!status) return
    if (status.classList.contains("is-ok")) el.classList.add("is-available")
    else if (status.classList.contains("is-error")) el.classList.add("is-taken")
    else if (status.classList.contains("is-checking")) el.classList.add("is-checking")

    if (this.hasSubmitTarget) {
      const handle = this.inputTarget.value
      this.submitTarget.textContent = status.classList.contains("is-ok") && handle
        ? `Claim @${handle} →`
        : this.submitLabel
    }
  }
}


// username_check_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  connect() { this.timer = null }

  changed() {
    const el = this.inputTarget
    const cleaned = el.value.toLowerCase().replace(/[^a-z0-9]/g, "")
    if (cleaned !== el.value) el.value = cleaned

    clearTimeout(this.timer)

    if (cleaned.length === 0) return this.renderLocal("Type a username…", "text-[var(--muted)]")
    if (cleaned.length < 3)   return this.renderLocal("Min 3 characters", "text-[var(--muted)]")
    if (cleaned.length > 30)  return this.renderLocal("Max 30 characters", "text-red-400")

    this.renderLocal("Checking…", "text-[var(--muted)]")

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
    frame.innerHTML = `<span class="text-sm ${cls}">${text}</span>`
  }
}

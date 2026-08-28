import { Controller } from "@hotwired/stimulus"

// Flash toast: closes on X, or by itself after `delay` ms (pauses while hovered).
export default class extends Controller {
  static values = { delay: { type: Number, default: 4500 } }

  connect() {
    this.start()
    this.element.addEventListener("mouseenter", this.stop)
    this.element.addEventListener("mouseleave", this.start)
  }

  disconnect() { this.stop() }

  start = () => { this.stop(); this.timer = setTimeout(() => this.close(), this.delayValue) }
  stop  = () => clearTimeout(this.timer)

  close() {
    this.stop()
    this.element.classList.add("is-leaving")
    this.element.addEventListener("animationend", () => this.element.remove(), { once: true })
    setTimeout(() => this.element.remove(), 400) // in case animations are disabled
  }
}

import { Controller } from "@hotwired/stimulus"

// Sticky subscribe bar on posts: shows once the reader is invested (35% scrolled
// or 8s), hides while the end-of-post card is on screen, and stays dismissed
// for a month once closed.
export default class extends Controller {
  static values = { key: String, threshold: { type: Number, default: 0.35 }, delay: { type: Number, default: 8000 } }

  connect() {
    if (this.dismissed()) return
    this.shown = false
    this.onScroll = () => this.check()
    window.addEventListener("scroll", this.onScroll, { passive: true })
    this.timer = setTimeout(() => this.show(), this.delayValue)

    const card = document.querySelector("[data-subscribe-card]")
    if (card && "IntersectionObserver" in window) {
      this.io = new IntersectionObserver(([e]) => this.element.classList.toggle("is-eclipsed", e.isIntersecting), { threshold: 0.2 })
      this.io.observe(card)
    }
  }

  disconnect() {
    window.removeEventListener("scroll", this.onScroll)
    clearTimeout(this.timer)
    this.io?.disconnect()
  }

  check() {
    const max = document.documentElement.scrollHeight - window.innerHeight
    if (max > 0 && window.scrollY / max >= this.thresholdValue) this.show()
  }

  show() {
    if (this.shown) return
    this.shown = true
    this.element.hidden = false
    requestAnimationFrame(() => this.element.classList.add("is-visible"))
  }

  dismiss() {
    this.element.classList.remove("is-visible")
    setTimeout(() => { this.element.hidden = true }, 300)
    try { localStorage.setItem(this.keyValue, String(Date.now())) } catch {}
  }

  dismissed() {
    try {
      const at = Number(localStorage.getItem(this.keyValue))
      return at && Date.now() - at < 30 * 24 * 3600 * 1000
    } catch { return false }
  }
}

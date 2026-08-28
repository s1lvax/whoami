import { Controller } from "@hotwired/stimulus"

const KEY = "theme"

export default class extends Controller {
  connect() {
    this.sync()
  }

  toggle() {
    const next = this.current() === "dark" ? "light" : "dark"
    localStorage.setItem(KEY, next)
    this.apply(next)
  }

  sync() {
    this.apply(this.current())
  }

  current() {
    const stored = localStorage.getItem(KEY)
    if (stored === "light" || stored === "dark") return stored
    return window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light"
  }

  apply(theme) {
    document.documentElement.setAttribute("data-theme", theme)
    this.element.setAttribute("aria-pressed", theme === "dark" ? "true" : "false")
    this.element.setAttribute("aria-label", theme === "dark" ? "Switch to light mode" : "Switch to dark mode")
    window.dispatchEvent(new CustomEvent("theme:changed", { detail: { theme } }))
  }
}


import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["list", "template", "item", "destroy"]
  connect() {
    this.index = this.itemTargets.length
    this.max = 10
    this.reindex()
  }

  add() {
    if (this.itemTargets.length >= this.max) return
    const html = this.templateTarget.innerHTML.replaceAll("__INDEX__", String(this.index++))
    const node = document.createRange().createContextualFragment(html)
    this.listTarget.appendChild(node)
    this.reindex()
  }

  remove(event) {
    const card = event.target.closest("[data-links-target='item']")
    if (!card) return
    // If there is a hidden _destroy input, set it and hide; else remove node
    const destroy = card.querySelector("input[name$='[_destroy]']")
    if (destroy) {
      destroy.value = "1"
      card.style.display = "none"
    } else {
      card.remove()
    }
    this.reindex()
  }

  reindex() {
    // Update position fields in DOM order (skipping destroyed/hidden items)
    Array.from(this.listTarget.querySelectorAll("[data-links-target='item']")).forEach((el, idx) => {
      if (el.style.display === "none") return
      const pos = el.querySelector("input[name$='[position]']")
      if (pos) pos.value = idx
    })
  }
}

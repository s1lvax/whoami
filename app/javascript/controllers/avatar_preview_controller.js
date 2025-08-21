
// app/javascript/controllers/avatar_preview_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["img"]

  pick(event) {
    const file = event.target.files?.[0]
    if (!file) return
    const url = URL.createObjectURL(file)
    if (this.hasImgTarget) {
      this.imgTarget.src = url
      this.imgTarget.classList.remove("hidden")
    }
  }
}

import { Controller } from "@hotwired/stimulus"

// Live draft: while a form is being edited, paint the unsaved values into the
// preview iframe (same origin) so the owner sees the result before saving.
//   kind = "link" | "experience" | "profile"
//   url  = endpoint that renders the draft through the public components
//   id   = record id when editing (so the existing tile/row is replaced)
export default class extends Controller {
  static values = { kind: String, url: String, id: String }

  connect() {
    this.timer = null
    this.element.addEventListener("input", this.changed)
    this.element.addEventListener("submit", this.submitted)
  }

  disconnect() {
    this.element.removeEventListener("input", this.changed)
    this.element.removeEventListener("submit", this.submitted)
    if (!this.submitting) this.restore()
  }

  changed = () => {
    clearTimeout(this.timer)
    this.timer = setTimeout(() => this.paint(), 180)
  }

  submitted = () => { this.submitting = true }

  get doc() {
    const frame = document.querySelector(".ws-preview iframe")
    try { return frame?.contentDocument || null } catch { return null }
  }

  fields() {
    const out = {}
    for (const [name, value] of new FormData(this.element)) {
      const key = name.match(/\[([^\]]+)\]$/)?.[1] || name
      if (typeof value === "string") out[key] = value
    }
    return out
  }

  async paint() {
    const doc = this.doc
    if (!doc) return
    const f = this.fields()

    if (this.kindValue === "profile") {
      const name = [f.name, f.family_name].filter(Boolean).join(" ").trim()
      const h1 = doc.querySelector(".page-name")
      if (h1 && name) h1.textContent = name
      const bio = doc.querySelector(".page-bio")
      if (bio) bio.textContent = f.bio || ""
      return
    }

    const params = new URLSearchParams(f)
    if (this.idValue) params.set("except_id", this.idValue)
    const res = await fetch(`${this.urlValue}?${params}`, { headers: { Accept: "text/html" } })
    if (!res.ok) return
    const html = await res.text()
    const tpl = doc.createElement("template")
    tpl.innerHTML = html.trim()
    const node = tpl.content.firstElementChild
    if (!node) return
    node.dataset.draft = this.kindValue

    if (this.kindValue === "link") {
      // the endpoint returns the links section holding one row; we only want the row
      const row = node.querySelector(".b-link") || node
      row.dataset.draft = "link"
      const existing = this.idValue
        ? doc.querySelector(`.b-link[data-id="${this.idValue}"]`)
        : doc.querySelector('[data-draft="link"]')
      if (existing) { existing.replaceWith(row); return }
      let list = doc.querySelector(".poster-links")
      if (!list) {
        list = doc.createElement("section"); list.className = "poster-links"
        const hero = doc.querySelector(".b-id")
        hero ? hero.after(list) : doc.querySelector(".poster-body")?.append(list)
      }
      list.append(row)
    } else if (this.kindValue === "experience") {
      const work = doc.querySelector(".b-work")
      if (work) work.replaceWith(node)
      else (doc.querySelector(".b-writing") || doc.querySelector(".poster-foot"))?.before(node)
    }
  }

  restore() {
    const frame = document.querySelector(".ws-preview iframe")
    if (frame) frame.src = frame.src
  }
}

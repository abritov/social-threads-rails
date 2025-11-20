import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    timeout: { type: Number, default: 4000 }
  }

  connect() {
    // Check if a snackbar is already visible to prevent duplicates
    const existingSnackbar = document.querySelector('[data-controller="snackbar"]')
    if (existingSnackbar && existingSnackbar !== this.element) {
      this.element.remove()
      return
    }

    this.element.dataset.snackbarShown = "true"

    // Animate in after a brief delay to ensure DOM is ready
    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        this.element.classList.add("translate-y-0", "opacity-100")
        this.element.classList.remove("translate-y-4", "opacity-0")
      })
    })

    // Auto-dismiss after timeout
    this.timeoutId = setTimeout(() => {
      this.dismiss()
    }, this.timeoutValue)
  }

  disconnect() {
    if (this.timeoutId) {
      clearTimeout(this.timeoutId)
    }
  }

  dismiss() {
    this.element.classList.add("translate-y-4", "opacity-0")
    this.element.classList.remove("translate-y-0", "opacity-100")

    setTimeout(() => {
      this.element.remove()
    }, 300)
  }
}

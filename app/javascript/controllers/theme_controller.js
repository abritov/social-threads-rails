import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const savedTheme = localStorage.getItem('theme') || 'light'
    this.setTheme(savedTheme)
  }

  toggle() {
    const currentTheme = document.body.classList.contains('dark') ? 'dark' : 'light'
    const newTheme = currentTheme === 'dark' ? 'light' : 'dark'
    this.setTheme(newTheme)
  }

  setTheme(theme) {
    const sunIcon = this.element.querySelector('.sun-icon')
    const moonIcon = this.element.querySelector('.moon-icon')

    if (theme === 'dark') {
      document.body.classList.add('dark')
      if (sunIcon) sunIcon.style.display = 'block'
      if (moonIcon) moonIcon.style.display = 'none'
    } else {
      document.body.classList.remove('dark')
      if (sunIcon) sunIcon.style.display = 'none'
      if (moonIcon) moonIcon.style.display = 'block'
    }
    localStorage.setItem('theme', theme)
  }
}


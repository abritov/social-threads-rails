import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.setupTransitions()
  }

  setupTransitions() {
    // Animate new posts after Turbo Stream renders
    document.addEventListener('turbo:before-stream-render', () => {
      // Use a small delay to ensure DOM is updated
      requestAnimationFrame(() => {
        this.animateNewPosts()
      })
    })

    // Handle Unpoly navigation with View Transitions API
    if (typeof up !== 'undefined' && document.startViewTransition) {
      up.on('up:fragment:loaded', (event) => {
        const originalRender = event.renderOptions.onRendered

        event.renderOptions.onRendered = () => {
          document.startViewTransition(() => {
            if (originalRender) originalRender()
          })
        }
      })

      // Setup Unpoly compilers for comments
      up.compiler('.comment-item', (element) => {
        if (!element.dataset.animated) {
          element.dataset.animated = 'true'
          element.style.animation = 'fade-in 0.3s ease-out'
        }
      })
    }

    // Animate posts on initial page load
    this.animateNewPosts()
  }

  animateNewPosts() {
    document.querySelectorAll('.post-item:not([data-animated])').forEach(element => {
      element.dataset.animated = 'true'
      element.style.animation = 'slide-up 0.4s ease-out'
    })
  }
}

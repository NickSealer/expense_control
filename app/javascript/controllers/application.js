import { Application } from "@hotwired/stimulus"
import "@rails/request.js"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }

// app/javascript/controllers/file_preview_controller.js
import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="file-preview"
export default class extends Controller {
  static targets = ["input", "preview", "filename"]

  connect() {
    // console.log("FilePreview controller connected")
  }

  preview() {
    const file = this.inputTarget.files[0]
    const preview = this.previewTarget
    const filename = this.filenameTarget

    if (!file) {
      filename.textContent = "No file chosen"
      preview.classList.add("hidden")
      return
    }

    filename.textContent = file.name

    if (file.type.startsWith("image/")) {
      const reader = new FileReader()
      reader.onload = e => {
        preview.src = e.target.result
        preview.classList.remove("hidden")
      }
      reader.readAsDataURL(file)
    } else {
      preview.classList.add("hidden")
    }
  }
}

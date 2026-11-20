import { Controller } from "@hotwired/stimulus"
import { marked } from "marked";
import DOMPurify from "dompurify";

// Connects to data-controller="markdown"
export default class extends Controller {
  static targets = ["editor", "preview", "previewSwitch"]

  togglePreview() {
    const isPreviewMode = this.previewSwitchTarget.checked
    if (isPreviewMode) {
      const markdown = this.editorTarget.value
      this.previewTarget.innerHTML = DOMPurify.sanitize(marked.parse(markdown))
    }
    this.editorTarget.classList.toggle("hidden", isPreviewMode)
    this.previewTarget.classList.toggle("hidden", !isPreviewMode)
  }

  // updatePreview() {
  //   const markdown = this.editorTarget.value
  //   this.previewTarget.innerHTML = DOMPurify.sanitize(marked.parse(markdown))
  // }
}

import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="company-filter"
export default class extends Controller {
  static targets = [ "holding", "form", "etfs", "tags", "tagForm" ]
  connect() {
    console.log("Hello, Stimulus!")
  }

  submit() {
    let holdings = this.holdingTargets.filter((holding) => holding.checked )
    holdings = holdings.map((holding) => holding.value)

    if (holdings.length > 0) {
      holdings = holdings.length > 0 ? holdings.join(',') : ''
      const url = `${this.formTarget.action}/?holdings=${holdings}`

      fetch(url)
        .then(response => response.text())
        .then(html => {
          this.etfsTarget.innerHTML = html
        })
    } else {
      location.reload()
    }
  }

  submitTags(event) {
    event.currentTarget.parentElement.classList.toggle('active')

    let tags = this.tagsTargets.filter((tag) => tag.checked )
    tags = tags.map((tag) => tag.value)
    if (tags.length > 0) {
    tags = tags.length > 0 ? tags.join(',') : ''
    const url = `${this.tagFormTarget.action}/?tags=${tags}`

    fetch(url)
      .then(response => response.text())
      .then(html => {
        this.etfsTarget.innerHTML = html
      })
    } else {
      location.reload()
    }
  }
}

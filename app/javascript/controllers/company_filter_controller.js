import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="company-filter"
export default class extends Controller {
  static targets = [ "holding", "form", "etfs" ]
  connect() {
    console.log("Hello, Stimulus!")
  }

  submit() {
    console.log(this.formTarget.action)
    let holdings = this.holdingTargets.filter((holding) => holding.checked )
    holdings = holdings.map((holding) => holding.value)
    console.log(holdings)
    const url = `${this.formTarget.action}/?holdings=${holdings.join(',')}`

    fetch(url)
      .then(response => response.text())
      .then(html => {
        this.etfsTarget.innerHTML = html
      })
  }
}

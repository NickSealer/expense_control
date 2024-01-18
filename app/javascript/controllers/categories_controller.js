import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"

export default class extends Controller {
  static values = {categoryId: Number}

  colors(event) {
    let priority = event.target.selectedOptions[0].value;
    let id = this.categoryIdValue;

    get(`/colors?priority=${priority}&id=${id}`, {
      responseKind: 'turbo-stream'
    });
  }
}
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { reviewContent: String };

  generateResponse() {
    console.log("test");

    const csrfToken = document.querySelector("[name='csrf-token']").content;

    fetch(`/reviews/generate_response`, {
      method: "POST", // *GET, POST, PUT, DELETE, etc.
      mode: "cors", // no-cors, *cors, same-origin
      cache: "no-cache", // *default, no-cache, reload, force-cache, only-if-cached
      credentials: "same-origin", // include, *same-origin, omit
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken,
      },
      body: JSON.stringify({ review_content: "very nice restaurant" }), // body data type must match "Content-Type" header
    })
      .then((response) => response.json())
      .then((data) => {
        const responseElement = document.getElementById("aiResponse");
        responseElement.innerHTML = data.response; // Adjust based on actual response structure
      });
  }
}

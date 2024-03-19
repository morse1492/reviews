import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  generateResponse(event) {
    console.log("Fetching AI response...");
    const csrfToken = document.querySelector("[name='csrf-token']").content;
    const button = event.currentTarget;
    const cardBody = button.closest(".card-body");

    fetch(`/reviews/generate_response`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken,
      },
      body: JSON.stringify({
        review_content:
          "respond to review but make each response unique with some humor",
      }), // Adjust as necessary
    })
      .then((response) => response.json())
      .then((data) => {
        let responseContainer = cardBody.querySelector(".aiResponse");
        if (!responseContainer) {
          const headingContainer = document.createElement("div");
          headingContainer.className = "d-flex align-items-center mt-3";

          const logo = document.createElement("img");
          logo.src =
            "https://upload.wikimedia.org/wikipedia/commons/0/04/ChatGPT_logo.svg"; // Replace URL_TO_CHATGPT_LOGO with the actual URL to the ChatGPT logo
          logo.alt = "ChatGPT Logo";
          logo.style.width = "24px"; // Set the logo size as desired
          logo.style.marginRight = "10px";

          const heading = document.createElement("h6");
          heading.textContent = "ChatGPT Response:";

          headingContainer.appendChild(logo);
          headingContainer.appendChild(heading);

          responseContainer = document.createElement("div");
          responseContainer.className = "aiResponse alert alert-success mt-2";

          cardBody.appendChild(headingContainer);
          cardBody.appendChild(responseContainer);
        }
        responseContainer.style.display = "block"; // Make sure to show the response container
        this.displayResponseWordByWord(data.response, responseContainer);
      });
  }

  displayResponseWordByWord(response, element) {
    element.innerHTML = ""; // Clear previous content
    const words = response.split(" ");
    let index = 0;

    const addWord = () => {
      if (index < words.length) {
        element.innerHTML += `${words[index]} `;
        index++;
        setTimeout(addWord, 100); // Adjust speed as necessary
      }
    };

    addWord();
  }
}

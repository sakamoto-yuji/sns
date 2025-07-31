import { Controller } from "stimulus";

export default class extends Controller {
  static values = { userId: Number }

  async toggleFollow(event) {
    const button = event.target;
    const action = button.dataset.action;
    const url = action === "follow" ? "/user_follows" : `/user_follows/${this.userIdValue}`;
    const method = action === "follow" ? "POST" : "DELETE";

    try {
      const response = await fetch(url, {
        method: method,
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        },
        body: action === "follow" ? JSON.stringify({ user_id: this.userIdValue }) : null,
      });

      if (response.ok) {
        const data = await response.json();
        this.updateButton(button, data.status);
      } else {
        console.error("Failed to update follow status");
      }
    } catch (error) {
      console.error("Error:", error);
    }
  }

  updateButton(button, status) {
    if (status === "followed") {
      button.textContent = "フォロー中";
      button.className = "follow-btn btn btn-danger";
      button.dataset.followAction = "unfollow";
    } else if (status === "unfollowed") {
      button.textContent = "フォロー";
      button.className = "follow-btn btn btn-primary";
      button.dataset.followAction = "follow";
    }
  }
}


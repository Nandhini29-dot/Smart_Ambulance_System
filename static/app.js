document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll(".flash").forEach((item) => {
    window.setTimeout(() => {
      item.classList.add("flash-fade");
      window.setTimeout(() => item.remove(), 450);
    }, 6000);
  });
  document.querySelectorAll("form").forEach((form) => {
    form.addEventListener("submit", () => {
      const button = form.querySelector('button[type="submit"]');
      if (button && !button.dataset.noLoading) {
        button.dataset.originalText = button.textContent;
        button.disabled = true;
        button.textContent = "Please wait…";
      }
    });
  });
});

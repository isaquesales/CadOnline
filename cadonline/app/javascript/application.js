// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Theme toggle
document.addEventListener("DOMContentLoaded", () => {
  const root = document.documentElement;
  const btn  = document.getElementById("themeBtn");
  if (!btn) return;

  btn.addEventListener("click", () => {
    const next = root.getAttribute("data-theme") === "claro" ? "escuro" : "claro";
    root.setAttribute("data-theme", next);
    btn.textContent = next === "claro" ? "Claro" : "Escuro";
  });
});

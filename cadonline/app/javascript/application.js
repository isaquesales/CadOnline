import "@hotwired/turbo-rails"
import "controllers"
import { initDocumentEditor } from "lib/document_editor"

function initThemeToggle() {
  const root = document.documentElement;
  const btn = document.getElementById("themeBtn");
  if (!btn) return;

  btn.addEventListener("click", () => {
    const next = root.getAttribute("data-theme") === "claro" ? "escuro" : "claro";
    root.setAttribute("data-theme", next);
    btn.textContent = next === "claro" ? "Claro" : "Escuro";
  });
}

document.addEventListener("turbo:load", () => {
  initThemeToggle();
  initDocumentEditor();
});

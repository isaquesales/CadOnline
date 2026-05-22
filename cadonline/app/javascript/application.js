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

function initPrettyConfirm() {
  const modal = document.getElementById("confirmModal");
  const text = document.getElementById("confirmModalText");
  const ok = document.getElementById("confirmModalOk");
  const cancel = document.getElementById("confirmModalCancel");
  if (!modal || !text || !ok || !cancel) return;

  if (window.__prettyConfirmBound) return;
  window.__prettyConfirmBound = true;
  window.__prettyConfirmBypass = false;
  window.__prettyConfirmPendingSubmit = null;

  document.addEventListener("submit", (event) => {
    const form = event.target;
    if (!(form instanceof HTMLFormElement)) return;
    if (window.__prettyConfirmBypass) return;

    const message = form.dataset.confirm || form.dataset.turboConfirm;
    if (!message) return;

    event.preventDefault();
    window.__prettyConfirmPendingSubmit = form;
    text.textContent = message || "Tem certeza?";
    modal.hidden = false;
  }, true);

  ok.addEventListener("click", () => {
    modal.hidden = true;
    if (window.__prettyConfirmPendingSubmit) {
      window.__prettyConfirmBypass = true;
      HTMLFormElement.prototype.submit.call(window.__prettyConfirmPendingSubmit);
      window.__prettyConfirmBypass = false;
    }
    window.__prettyConfirmPendingSubmit = null;
  });

  cancel.addEventListener("click", () => {
    modal.hidden = true;
    window.__prettyConfirmPendingSubmit = null;
  });
}

function initSidebarRename() {
  document.querySelectorAll(".doc-title[contenteditable='true']").forEach((el) => {
    el.addEventListener("keydown", (event) => {
      if (event.key === "Enter") {
        event.preventDefault();
        el.blur();
      }
    });

    el.addEventListener("blur", async () => {
      const id = el.dataset.docId;
      const title = el.textContent.trim() || "Documento sem titulo";
      const csrf = document.querySelector("meta[name='csrf-token']")?.content || "";
      await fetch(`/documents/${id}`, {
        method: "PATCH",
        headers: { "Content-Type": "application/json", "X-CSRF-Token": csrf },
        body: JSON.stringify({ document: { title } })
      });
    });
  });
}

function initTopbarPrint() {
  const printBtn = document.getElementById("printTopbarBtn");
  if (!printBtn) return;
  printBtn.addEventListener("click", () => window.print());
}

document.addEventListener("turbo:load", () => {
  initThemeToggle();
  initDocumentEditor();
  initPrettyConfirm();
  initSidebarRename();
  initTopbarPrint();
});

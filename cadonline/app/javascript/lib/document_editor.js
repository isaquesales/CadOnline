const PX_PER_MM = 3.7795275591;

const DEFAULT_DATA = {
  blocks: [
    { type: "header", data: { text: "Documento", level: 2 } },
    { type: "paragraph", data: { text: "Digite seu conteúdo aqui..." } }
  ]
};

let editor;
let recalcSheets = null;
let saveTimer = null;

function buildEditorTools() {
  const tools = {
    header: { class: window.Header, inlineToolbar: true, config: { placeholder: "Título" } },
    list: { class: window.EditorjsList || window.List, inlineToolbar: true, config: { defaultStyle: "unordered", maxLevel: 1 } }
  };

  if (window.Quote) tools.quote = { class: window.Quote, inlineToolbar: true, config: { quotePlaceholder: "Citação", captionPlaceholder: "Fonte" } };
  if (window.Delimiter) tools.delimiter = { class: window.Delimiter };
  if (window.Table) tools.table = { class: window.Table, inlineToolbar: true, config: { rows: 2, cols: 3 } };
  if (window.Marker) tools.marker = { class: window.Marker };
  if (window.InlineCode) tools.inlineCode = { class: window.InlineCode };

  return tools;
}

function mmVarToPx(varName) {
  const value = Number.parseFloat(getComputedStyle(document.documentElement).getPropertyValue(varName));
  return Number.isFinite(value) ? value * PX_PER_MM : 0;
}

function renderSheetPlaceholders(canvas, sheetsLayer, editorShell) {
  const pageHeight = mmVarToPx("--sheet-height-mm");
  const pageContentHeight = pageHeight - mmVarToPx("--sheet-padding-top-mm") - mmVarToPx("--sheet-padding-bottom-mm");
  if (pageHeight <= 0 || pageContentHeight <= 0) return;

  const contentHeight = Math.max(editorShell.scrollHeight, pageContentHeight);
  const pageCount = Math.max(1, Math.ceil(contentHeight / pageContentHeight));

  sheetsLayer.innerHTML = "";
  for (let i = 0; i < pageCount; i += 1) {
    const page = document.createElement("section");
    page.className = "paper-sheet";
    sheetsLayer.appendChild(page);
  }

  canvas.style.setProperty("--sheet-count", pageCount.toString());
}

function documentId() {
  return document.querySelector(".document-workspace")?.dataset?.documentId;
}

async function updateDocument(extra = {}) {
  const id = documentId();
  if (!id) return;

  await fetch(`/documents/${id}`, {
    method: "PATCH",
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-Token": document.querySelector("meta[name='csrf-token']")?.content || ""
    },
    body: JSON.stringify({ document: extra })
  });
}

async function saveDocument(canvas) {
  if (!editor) return;
  const payload = await editor.save();

  await updateDocument({
    content: payload,
    paper_style: canvas.getAttribute("data-paper-style") || "ruled",
    paper_tone: canvas.dataset.paperTone || "default",
    title: document.getElementById("documentTitleInput")?.value || "Documento"
  });
}

function queueSave(canvas) {
  clearTimeout(saveTimer);
  saveTimer = setTimeout(() => saveDocument(canvas), 600);
}

function bindPaperStyle(canvas) {
  const styleSelect = document.getElementById("paperStyleSelect");
  const toneSelect = document.getElementById("paperToneSelect");
  const toneButtons = document.querySelectorAll(".tone-chip[data-tone-value]");
  const titleInput = document.getElementById("documentTitleInput");

  styleSelect?.addEventListener("change", () => {
    canvas.setAttribute("data-paper-style", styleSelect.value);
    if (recalcSheets) recalcSheets();
    queueSave(canvas);
  });

  function applyTone(toneValue) {
    canvas.dataset.paperTone = toneValue;
    canvas.classList.remove("paper-tone-none", "paper-tone-default", "paper-tone-ivory", "paper-tone-warm", "paper-tone-gray", "paper-tone-rose", "paper-tone-sky", "paper-tone-mint");
    canvas.classList.add(`paper-tone-${toneValue}`);
    if (toneSelect) toneSelect.value = toneValue;
    toneButtons.forEach((btn) => btn.classList.toggle("active", btn.dataset.toneValue === toneValue));
  }

  toneButtons.forEach((btn) => {
    btn.addEventListener("click", () => {
      applyTone(btn.dataset.toneValue || "default");
      queueSave(canvas);
    });
  });

  titleInput?.addEventListener("change", () => queueSave(canvas));
}

async function downloadCad(canvas) {
  if (!editor) return;

  const saved = await editor.save();
  const payload = {
    format: "cadonline-cad",
    version: 1,
    exported_at: new Date().toISOString(),
    paper_style: canvas.getAttribute("data-paper-style") || "ruled",
    data: saved
  };

  const blob = new Blob([JSON.stringify(payload, null, 2)], { type: "application/json" });
  const url = URL.createObjectURL(blob);
  const link = document.createElement("a");
  link.href = url;
  link.download = "documento.cad";
  link.click();
  URL.revokeObjectURL(url);
}

async function importCad(file, canvas) {
  const text = await file.text();
  const payload = JSON.parse(text);

  if (!payload || payload.format !== "cadonline-cad" || !payload.data) throw new Error("Arquivo .cad inválido.");

  await editor.render(payload.data);
  const style = payload.paper_style || "ruled";
  canvas.setAttribute("data-paper-style", style);

  const select = document.getElementById("paperStyleSelect");
  if (select) select.value = style;

  if (recalcSheets) recalcSheets();
  queueSave(canvas);
}

async function toggleFavorite() {
  const id = documentId();
  if (!id) return;

  await fetch(`/documents/${id}/toggle_favorite`, {
    method: "PATCH",
    headers: { "X-CSRF-Token": document.querySelector("meta[name='csrf-token']")?.content || "" }
  });

  window.location.reload();
}

function bindDocumentActions(canvas) {
  const exportBtn = document.getElementById("exportCadBtn");
  const importBtn = document.getElementById("importCadBtn");
  const importInput = document.getElementById("cadImportInput");
  const printBtn = document.getElementById("printTopbarBtn");
  const favoriteBtn = document.getElementById("favoriteDocumentBtn");

  exportBtn?.addEventListener("click", async () => { try { await downloadCad(canvas); } catch (_error) { alert("Não foi possível exportar o documento."); } });
  importBtn?.addEventListener("click", () => importInput?.click());
  importInput?.addEventListener("change", async (event) => {
    const file = event.target.files?.[0];
    if (!file) return;

    try { await importCad(file, canvas); } catch (_error) { alert("Falha ao importar arquivo .cad."); } finally { event.target.value = ""; }
  });

  printBtn?.addEventListener("click", () => window.print());
  favoriteBtn?.addEventListener("click", () => toggleFavorite());
}

async function initEditor(canvas, editorShell, sheetsLayer) {
  if (!window.EditorJS || !window.Header || !(window.EditorjsList || window.List)) return;

  const holder = document.getElementById("editorjs");
  const raw = holder?.dataset?.documentContent;
  let data = DEFAULT_DATA;
  if (raw) { try { data = JSON.parse(raw); } catch (_error) { data = DEFAULT_DATA; } }

  editor = new window.EditorJS({
    holder: "editorjs",
    placeholder: "Digite seu conteúdo aqui...",
    tools: buildEditorTools(),
    data,
    onReady: () => {
      renderSheetPlaceholders(canvas, sheetsLayer, editorShell);
      const startHint = document.getElementById("documentStartHint");
      if (startHint) startHint.hidden = true;
    },
    onChange: () => {
      renderSheetPlaceholders(canvas, sheetsLayer, editorShell);
      queueSave(canvas);
    }
  });
}

export function initDocumentEditor() {
  const canvas = document.getElementById("documentCanvas");
  const sheetsLayer = document.getElementById("documentSheets");
  const editorShell = document.getElementById("documentEditorShell");

  if (!canvas || !sheetsLayer || !editorShell) return;

  recalcSheets = () => renderSheetPlaceholders(canvas, sheetsLayer, editorShell);

  bindPaperStyle(canvas);
  bindDocumentActions(canvas);
  initEditor(canvas, editorShell, sheetsLayer);

  const observer = new ResizeObserver(recalcSheets);
  observer.observe(editorShell);
  window.addEventListener("resize", recalcSheets);
}

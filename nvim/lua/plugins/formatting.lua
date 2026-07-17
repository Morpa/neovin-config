-- Formatação automática ao salvar (format-on-save), igual ao comportamento padrão do Zed.
return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  opts = {
    formatters_by_ft = {
      -- biome só entra se o projeto tiver biome.json/biome.jsonc (condição já
      -- embutida no formatter do conform); senão cai pro prettier.
      javascript = { "biome", "prettier", stop_after_first = true },
      typescript = { "biome", "prettier", stop_after_first = true },
      typescriptreact = { "biome", "prettier", stop_after_first = true },
      javascriptreact = { "biome", "prettier", stop_after_first = true },
      json = { "biome", "prettier", stop_after_first = true },
      css = { "prettier" },
      html = { "prettier" },
      markdown = { "prettier" },
      rust = { "rustfmt" },
      go = { "gofmt" },
      lua = { "stylua" },
    },
    format_on_save = {
      timeout_ms = 1000,
      lsp_fallback = true, -- se não tiver formatter externo configurado, usa o do LSP
    },
  },
}

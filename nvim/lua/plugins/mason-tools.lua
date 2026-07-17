-- Garante que os formatters usados em formatting.lua (prettier, stylua) sejam
-- baixados automaticamente pelo Mason. rustfmt e gofmt já vêm com o toolchain
-- do Rust/Go que você já tem instalado, então não precisam entrar nessa lista.
return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  dependencies = { "mason.nvim" },
  opts = {
    ensure_installed = { "prettier", "stylua" },
  },
}

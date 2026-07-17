-- Fuzzy finder: buscar arquivos, texto no projeto, buffers abertos etc.
-- É o equivalente direto ao Cmd+P / Cmd+Shift+F do Zed.
return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- ordenação de resultados mais rápida (C nativo)
  },
  cmd = "Telescope",
  config = function()
    require("telescope").setup({})
    pcall(require("telescope").load_extension, "fzf")
  end,
}

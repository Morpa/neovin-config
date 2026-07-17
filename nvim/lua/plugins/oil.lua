-- Oil: edita o sistema de arquivos como se fosse um buffer de texto normal —
-- renomear, criar, apagar ou mover arquivos é só editar linhas e salvar (:w).
-- Complementa o neo-tree (árvore fixa) com uma edição rápida em float.
return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {},
  keys = {
    {
      "-",
      function() require("oil").toggle_float() end,
      desc = "Abrir explorador de arquivos (oil)",
    },
  },
}

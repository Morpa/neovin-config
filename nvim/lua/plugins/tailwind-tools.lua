-- Preview de cores das classes do Tailwind (ex: mostra o quadradinho colorido
-- ao lado de "bg-red-500") + comandos extras como ordenar/expandir classes.
return {
  "luckasRanarison/tailwind-tools.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  ft = { "html", "javascript", "typescript", "javascriptreact", "typescriptreact", "vue", "svelte" },
  opts = {
    -- tailwindcss já é configurado pelo lsp.lua (Mason + vim.lsp.enable);
    -- deixar o plugin também configurar gera conflito (initialize failed).
    server = {
      override = false,
    },
  },
}

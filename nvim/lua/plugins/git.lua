-- Sinais de git na coluna esquerda (linha adicionada/modificada/removida),
-- igual aos indicadores de diff que o Zed mostra na gutter.
return {
  -- Fugitive: comandos de git clássicos do Vim (:Git status, :Git blame,
  -- :Git log etc.), complementar ao Neogit — útil pra quem já conhece os
  -- comandos do fugitive ou quer algo mais leve que o painel completo.
  { "tpope/vim-fugitive", cmd = "Git" },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
  },

  -- Diffview: visualização de diff lado a lado, usada pelo Neogit ao abrir um arquivo
  { "sindrets/diffview.nvim", cmd = { "DiffviewOpen", "DiffviewFileHistory" } },

  -- Neogit: a "aba de git" completa — lista de arquivos staged/unstaged, área de
  -- commit, diff inline etc. É o equivalente mais próximo do painel de Source
  -- Control do VSCode / painel de git do Zed.
  {
    "NeogitOrg/neogit",
    dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
    cmd = "Neogit",
    keys = {
      { "<D-G>", ":Neogit<CR>", desc = "Abrir painel de git (Cmd+Shift+G)" },
      { "<leader>gg", ":Neogit<CR>", desc = "Abrir painel de git" },
    },
    opts = {},
  },
}

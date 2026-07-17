-- Catppuccin: único colorscheme da config (flavour "mocha", escuro). Além de
-- colorir o editor, integra nativamente com quase todos os outros plugins
-- (neo-tree, cmp, telescope, which-key, gitsigns, bufferline, treesitter,
-- LSP, Mason, indent-blankline...) e aplica as cores do tema também nos
-- ícones (nvim-web-devicons), então não precisa de um tema de ícones à parte.
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,    -- tema ativo, carrega logo na inicialização
    priority = 1000, -- antes de qualquer outro plugin, evita "flash" sem cor
    opts = {
      flavour = "mocha",
      integrations = {
        cmp = true,
        gitsigns = true,
        neotree = true,
        telescope = true,
        which_key = true,
        treesitter = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
        },
        mason = true,
        indent_blankline = { enabled = true },
        bufferline = true,
        illuminate = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },
}

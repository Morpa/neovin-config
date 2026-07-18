-- Kanagawa: tema principal da configuração. Mantém o editor com um visual
-- escuro e forte contraste, com destaque para syntax e integração com plugins
-- como snacks, cmp, telescope, which-key, gitsigns, treesitter, LSP e Mason.
return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,    -- tema ativo, carrega logo na inicialização
    priority = 1000, -- antes de qualquer outro plugin, evita "flash" sem cor
    config = function()
      require("kanagawa").setup({
        theme = "wave",
        compile = false,
        undercurl = true,
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = false,
        dimInactive = false,
        terminalColors = true,
        colors = {
          palette = {},
          theme = {
            all = {
              ui = {
                bg_gutter = "none",
              },
            },
          },
        },
        overrides = function()
          return {}
        end,
      })
      vim.cmd.colorscheme("kanagawa-wave")
    end,
  },
}

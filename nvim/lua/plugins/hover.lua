-- Hover/Documentation avançado com múltiplas opções e melhor visualização
-- O padrão K às vezes não funciona porque depende do LSP estar pronto

return {
  -- Hover melhorado com integração Noice e fallback automático
  {
    "lewis6991/hover.nvim",
    config = function()
      require("hover").setup({
        init = function()
          require("hover.providers.lsp")
          require("hover.providers.gh")
          require("hover.providers.gh_user")
          require("hover.providers.jira")
          require("hover.providers.man")
          require("hover.providers.dictionary")
        end,
        preview_opts = {
          border = "single",
          max_width = 120,
          max_height = 40,
        },
        preview_window = false,
        title = true,
        mouse_jumps = false,
      })
    end,
    keys = {
      { "gK", function() require("hover").hover() end, desc = "Hover (lewis6991)" },
      { "gH", function() require("hover").hover_select() end, desc = "Hover (seletar provider)" },
    },
  },

  -- Signature help melhorado e flutuante (mostra assinatura enquanto digita)
  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    config = function()
      require("lsp_signature").setup({
        bind = true,
        handler_opts = {
          border = "single",
        },
        hint_enable = true,
        hint_prefix = "📍 ",
        max_height = 12,
        max_width = 120,
        wrap = true,
        floating_window = true,
        floating_window_above_cur_line = true,
        -- Mostra continuamente enquanto você digita
        always_trigger = false,
        toggle_key = "<C-x><C-s>",
      })
    end,
  },

  -- Implementação customizada em lsp.lua com smart_hover() que tem tratamento de erros
  -- e múltiplas alternativas (K, <leader>hh, <leader>H)
}

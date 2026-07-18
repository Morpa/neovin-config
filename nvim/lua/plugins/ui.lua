-- Fecha o painel do explorer se já estiver aberto (procurando a janela pelo
-- filetype que o snacks.nvim usa pros seus buffers de picker/explorer);
-- senão, abre. Dá o comportamento de "toggle" que Cmd+B e <leader>e esperam.
local function toggle_explorer()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "snacks_picker_list" then
      vim.api.nvim_win_close(win, true)
      return
    end
  end
  Snacks.explorer()
end

return {
  -- Statusline (barra inferior com nome do arquivo, posição do cursor, git branch etc.)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
      require("lualine").setup({
        options = { theme = "kanagawa", globalstatus = true },
        sections = {
          lualine_y = {
            "progress", -- mantém o que já vinha por padrão (% do arquivo)
            -- ícone clicável no canto direito da barra inferior, igual aos
            -- ícones de painel que o Zed mostra na status bar
            {
              function() return " Terminal" end,
              on_click = function() vim.cmd("ToggleTerm") end,
            },
          },
        },
      })
    end,
  },

  -- Barra de abas no topo, mostrando cada buffer aberto como uma "tab" — igual ao Zed
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
      require("bufferline").setup({
        options = {
          diagnostics = "nvim_lsp", -- mostra contagem de erros/avisos na aba
          separator_style = "slant",
          always_show_bufferline = true,
          -- reserva o espaço da árvore de arquivos, senão as abas começam
          -- desenhando por cima dela em vez de começar depois
          offsets = {
            {
              filetype = "snacks_picker_list",
              text = "Explorador de arquivos",
              highlight = "Directory",
              separator = true,
            },
          },
        },
      })
    end,
  },

  -- Painel de arquivos lateral (explorer do snacks.nvim), igual ao painel
  -- esquerdo do Zed. Abre sozinho ao iniciar com `nvim <pasta>`
  -- (replace_netrw); Cmd+B / <leader>e alternam mostrar/esconder.
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    config = function(_, opts)
      require("snacks").setup(opts)
      -- Registra o atalho de liga/desliga do dim (usa o helper de toggle do
      -- próprio snacks, que também mostra a descrição no which-key).
      Snacks.toggle.dim():map("<leader>ud")
    end,
    opts = {
      explorer = {
        replace_netrw = true, -- abre sozinho no lugar do netrw ao iniciar numa pasta
      },
      -- Guias de indentação (substitui o indent-blankline.nvim), com a guia
      -- do escopo/bloco atual destacada.
      indent = {},
      -- Escurece o código fora do escopo atual quando ligado; começa
      -- desligado, liga/desliga com <leader>ud (ver keymap abaixo).
      dim = {},
      -- Destaca automaticamente outras ocorrências do símbolo sob o cursor
      -- (via LSP document highlight), sem precisar apertar nada.
      words = {},
    },
    keys = {
      { "<D-b>", toggle_explorer, desc = "Alternar painel de arquivos (Cmd+B)" },
      { "<leader>e", toggle_explorer, desc = "Alternar painel de arquivos" },
    },
  },

  -- Which-key: ao apertar <leader> e esperar, mostra um menu com todos os atalhos disponíveis.
  -- Ótimo enquanto você ainda está decorando os comandos. <leader>? (e Cmd+?)
  -- abrem a cheat sheet completa (cheatsheet.nvim), que cobre mais do que atalhos.
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        { "<leader>f", group = "Buscar" },
        { "<leader>g", group = "Git" },
        { "<leader>t", group = "Testes/Terminal" },
        { "<leader>x", group = "Diagnósticos" },
        { "<leader>b", group = "Buffers" },
        { "<leader>u", group = "Interface" },
      },
    },
  },

  -- Ícones de arquivo usados por vários plugins acima (snacks, bufferline, lualine,
  -- telescope, alpha). O Kanagawa (colorscheme.lua) tem integração nativa com o
  -- nvim-web-devicons e colore os ícones no tom do tema.
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    opts = {},
  },
}

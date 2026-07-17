return {
  -- Statusline (barra inferior com nome do arquivo, posição do cursor, git branch etc.)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
      require("lualine").setup({
        options = { theme = "catppuccin", globalstatus = true },
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
              filetype = "neo-tree",
              text = "Explorador de arquivos",
              highlight = "Directory",
              separator = true,
            },
          },
        },
      })
    end,
  },

  -- Painel de arquivos lateral (árvore do projeto), igual ao painel esquerdo do Zed.
  -- Abre sozinho ao iniciar (sem precisar lembrar de nenhum atalho); <leader>e só
  -- serve pra esconder/mostrar de novo caso você queira mais espaço na tela.
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    lazy = false,
    keys = { { "<leader>e", ":Neotree toggle<CR>", desc = "Alternar painel de arquivos" } },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        filesystem = {
          follow_current_file = { enabled = true }, -- destaca o arquivo aberto na árvore
          use_libuv_file_watcher = true,             -- atualiza a árvore quando arquivos mudam no disco
        },
        window = {
          width = 34,
          auto_expand_width = false, -- nunca redimensiona sozinho por causa de nome de arquivo comprido
        },
      })

      -- Com `wrap = false` global, mover o cursor pra um nome de arquivo comprido
      -- fazia o Vim rolar a janela horizontalmente pra manter o cursor visível —
      -- dava a impressão da árvore inteira "pulando" pra esquerda/direita.
      -- Ligando wrap só nessa janela, o texto quebra a linha em vez de rolar.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "neo-tree",
        callback = function()
          vim.wo.wrap = true
        end,
      })

      -- Abre automaticamente ao entrar no Neovim, se você abriu uma pasta (ex: `nvim .`).
      -- Quando não há argumento nenhum (`nvim` sozinho), deixa a tela de abertura
      -- pro alpha-nvim em vez de forçar a árvore de arquivos.
      vim.api.nvim_create_autocmd("VimEnter", {
        once = true,
        callback = function()
          if vim.fn.argc() > 0 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
            require("neo-tree.command").execute({ toggle = false, dir = vim.fn.getcwd() })
          end
        end,
      })
    end,
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
      },
    },
  },

  -- Ícones de arquivo usados por vários plugins acima (neo-tree, bufferline, lualine,
  -- telescope, alpha). O catppuccin (colorscheme.lua) tem integração nativa com o
  -- nvim-web-devicons e colore os ícones no tom do tema.
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    opts = {},
  },
}

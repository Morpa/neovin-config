-- Recursos modernos do Neovim: breadcrumbs, symbol outline, smart highlights, etc.

return {
  -- Breadcrumbs: mostra o caminho de navegação (type > method > linha) como no VSCode
  {
    "SmiteshP/nvim-navic",
    dependencies = "neovim/nvim-lspconfig",
    config = function()
      require("nvim-navic").setup({
        icons = {
          File = "📄 ",
          Module = "📦 ",
          Namespace = "🔒 ",
          Package = "📦 ",
          Class = "🏛️  ",
          Method = "🔧 ",
          Property = "🎯 ",
          Field = "📍 ",
          Constructor = "🔨 ",
          Enum = "📋 ",
          Interface = "🔌 ",
          Function = "ƒ ",
          Variable = "📦 ",
          Constant = "🔴 ",
          String = "📄 ",
          Number = "🔢 ",
          Boolean = "✓ ",
          Array = "📊 ",
          Object = "⚙️  ",
          Operator = "➕ ",
          TypeParameter = "🔤 ",
        },
        highlight = true,
        separator = " > ",
      })

      -- Integra com lualine (mostrar breadcrumbs na statusline)
      local status_ok, lualine = pcall(require, "lualine")
      if status_ok then
        lualine.setup({
          options = { theme = "kanagawa", globalstatus = true },
          sections = {
            lualine_c = {
              {
                function() return require("nvim-navic").get_location() end,
                cond = function() return require("nvim-navic").is_available() end,
              },
            },
            lualine_y = { "progress" },
          },
        })
      end
    end,
  },

  -- Symbol Outline: mostra a estrutura do arquivo (classes, funções, etc.) como no VSCode
  {
    "simrat39/symbols-outline.nvim",
    config = function()
      require("symbols-outline").setup({
        highlight_hovered_item = true,
        show_guides = true,
        auto_preview = true,
        position = "right",
        width = 25,
      })
    end,
    keys = {
      { "<leader>so", ":SymbolsOutline<CR>", desc = "Alternar symbol outline" },
    },
  },

  -- nvim-treesitter-context: mostra o contexto (função/classe) enquanto você scrolla
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("treesitter-context").setup({
        enable = true,
        max_lines = 0,
        min_window_height = 0,
        line_numbers = true,
        multiline_threshold = 20,
        trim_scope = "outer",
        mode = "cursor",
        separator = nil,
        zindex = 20,
      })
    end,
  },

  -- Twilight: escurece o código fora do escopo atual enquanto você trabalha
  {
    "folke/twilight.nvim",
    config = function()
      require("twilight").setup({
        dimming = {
          alpha = 0.25,
          color = { "Normal", "#ffffff" },
          term_blend = 45,
        },
        context = 10,
        line_numbers = false,
      })
    end,
    keys = {
      { "<leader>uw", ":Twilight<CR>", desc = "Alternar twilight (focus mode)" },
    },
  },

  -- vim-illuminate: destaca automaticamente todas as ocorrências da palavra sob o cursor (sem Ctrl+D)
  {
    "RRethy/vim-illuminate",
    config = function()
      require("illuminate").configure({
        providers = {
          "lsp",
          "treesitter",
          "regex",
        },
        delay = 100,
        large_file_cutoff = 2000,
        large_file_overrides = {
          providers = { "lsp" },
        },
      })
    end,
  },

  -- Gitsigns avançado com inline diffs (mostra o diff inline, não só a marca)
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "│" },
          change = { text = "│" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
        },
        current_line_blame = true, -- mostra o blame da linha atual na statusline
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "eol",
          delay = 1000,
        },
        diff_opts = { internal = true },
      })
    end,
  },

  -- Navbuddy: navegação ao estilo "Go to symbol" de forma interativa
  {
    "SmiteshP/nvim-navbuddy",
    dependencies = {
      "SmiteshP/nvim-navic",
      "MunifTanjim/nui.nvim"
    },
    config = function()
      require("nvim-navbuddy").setup({
        icons = {
          File = "📄",
          Module = "📦",
          Namespace = "🔒",
          Package = "📦",
          Class = "🏛️",
          Method = "🔧",
          Property = "🎯",
          Field = "📍",
          Constructor = "🔨",
          Enum = "📋",
          Interface = "🔌",
          Function = "ƒ",
          Variable = "📦",
          Constant = "🔴",
          String = "📄",
          Number = "🔢",
          Boolean = "✓",
          Array = "📊",
          Object = "⚙️",
          Operator = "➕",
          TypeParameter = "🔤",
          Null = "Ø",
        },
      })
    end,
    keys = {
      { "<leader>nb", ":Navbuddy<CR>", desc = "Navbuddy (go to symbol)" },
    },
  },

  -- Colorizer: colore automaticamente hex colors, rgb(), etc. no seu código
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        "*", -- highlight all filetypes
        css = { rgb_fn = true },
        html = { names = false },
      }, { names = true })
    end,
  },
}

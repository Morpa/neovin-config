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
        { "<leader>c", group = "Código" },
        { "<leader>d", group = "Debug" },
        { "<leader>h", group = "Hover/Help" },
        { "<leader>l", group = "LSP" },
        { "<leader>s", group = "Símbolos/Snippets" },
        { "<leader>t", group = "Testes" },
        { "<leader>x", group = "Diagnósticos" },
        { "<leader>b", group = "Buffers" },
        { "<leader>u", group = "Interface" },
        { "<leader>w", group = "Workspace" },
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

  -- Harpoon: marca/favorita arquivos pra acesso rápido (como bookmarks do VSCode)
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup({})
      local conf = require("telescope.config").values
      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end
        require("telescope.pickers")
          .new({}, {
            prompt_title = "Harpoon",
            finder = require("telescope.finders").new_table({
              results = file_paths,
            }),
            previewer = conf.file_previewer({}),
            sorter = conf.generic_sorter({}),
          })
          :find_map_apply(require("telescope.actions"), require("telescope.actions").select_default)
      end
    end,
    keys = {
      { "<leader>ha", function() require("harpoon"):list():add() end, desc = "Harpoon add" },
      { "<leader>hr", function() require("harpoon"):list():remove() end, desc = "Harpoon remove" },
      { "<leader>hm", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Harpoon menu" },
      { "<leader>h1", function() require("harpoon"):list():select(1) end, desc = "Harpoon 1" },
      { "<leader>h2", function() require("harpoon"):list():select(2) end, desc = "Harpoon 2" },
      { "<leader>h3", function() require("harpoon"):list():select(3) end, desc = "Harpoon 3" },
      { "<leader>h4", function() require("harpoon"):list():select(4) end, desc = "Harpoon 4" },
    },
  },

  -- Smart-open: busca ultra-rápida com histórico e favoritosNui: componentes UI moderno (usado por vários plugins)
  {
    "MunifTanjim/nui.nvim",
    lazy = true,
  },

  -- Noice: melhor renderização de comandos, search e mensagens
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        routes = {
          {
            filter = {
              event = "msg_show",
              kind = "",
              find = "written",
            },
            opts = { skip = true },
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
        },
      })
    end,
    keys = {
      { "<leader>nd", function() require("noice").dismiss() end, desc = "Descartar notificações" },
      { "<leader>nh", function() require("noice").history() end, desc = "Histórico de mensagens" },
    },
  },

  -- Notify: notificações melhores (integrada com Noice)
  {
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup({
        background_colour = "#1a1a1a",
        fps = 30,
        icons = {
          DEBUG = "🐛",
          ERROR = "❌",
          INFO = "ℹ️",
          TRACE = "✓",
          WARN = "⚠️",
        },
        level = vim.log.levels.WARN, -- só WARN e ERROR (silencia INFO)
        minimum_width = 50,
        render = "default",
        stages = "static",
        timeout = 4000, -- aumentado: mais tempo pra ver
        top_down = true,
      })
      vim.notify = require("notify")
      
      -- Silencia notificações do LSP (diagnostics, progress)
      local notify = require("notify")
      vim.notify = function(msg, level, opts)
        if msg:match("diagnostic") or msg:match("progress") or msg:match("Initializing") then
          return -- ignora notificações chatas do LSP
        end
        notify(msg, level, opts)
      end
    end,
  },
}

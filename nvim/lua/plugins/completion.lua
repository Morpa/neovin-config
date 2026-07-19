-- Autocomplete enquanto você digita, puxando sugestões do LSP — igual à experiência do Zed.
return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",     -- fonte: sugestões vindas do LSP
    "hrsh7th/cmp-buffer",        -- fonte: palavras já usadas no buffer atual
    "hrsh7th/cmp-path",          -- fonte: caminhos de arquivo
    "hrsh7th/cmp-nvim-lua",      -- fonte: Lua API (pro init.lua)
    "L3MON4D3/LuaSnip",          -- motor de snippets (necessário pro cmp expandir snippets do LSP)
    "saadparwaiz1/cmp_luasnip",
    "rafamadriz/friendly-snippets", -- coleção pronta de snippets (JS, Python, etc.)
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    require("luasnip.loaders.from_vscode").lazy_load()

    -- Tab "esperto" (estilo supertab), com prioridade:
    -- 1. se o Copilot tem uma sugestão fantasma visível, Tab aceita ela;
    -- 2. senão, se o menu do cmp está aberto, Tab navega pro próximo item;
    -- 3. senão, se o luasnip pode expandir/saltar um snippet, Tab salta;
    -- 4. senão, comportamento padrão do Tab (indentar, etc).
    local function tab_complete(fallback)
      local copilot_ok, copilot_suggestion = pcall(require, "copilot.suggestion")
      if copilot_ok and copilot_suggestion.is_visible() then
        copilot_suggestion.accept()
      elseif cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end

    local function shift_tab_complete(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),  -- rola a documentação pra cima
        ["<C-f>"] = cmp.mapping.scroll_docs(4),   -- rola a documentação pra baixo
        ["<C-Space>"] = cmp.mapping.complete(),   -- força abrir o menu de sugestões
        ["<C-e>"] = cmp.mapping.abort(),          -- fecha o menu sem confirmar
        ["<CR>"] = cmp.mapping.confirm({ select = true }), -- confirma a sugestão selecionada
        ["<C-n>"] = cmp.mapping.select_next_item(), -- navegar o menu explicitamente
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<Tab>"] = cmp.mapping(tab_complete, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(shift_tab_complete, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
        { name = "luasnip" },
      }, {
        { name = "buffer" },
        { name = "path" },
      }),
      formatting = {
        format = function(entry, vim_item)
          -- Adiciona ícones de tipo (como em IDEs modernas)
          local kind_icons = {
            Text = "📝",
            Method = "🔧",
            Function = "ƒ",
            Constructor = "🔨",
            Field = "📍",
            Variable = "📦",
            Class = "🏛️",
            Interface = "🔌",
            Module = "📦",
            Property = "🎯",
            Unit = "⚙️",
            Value = "💾",
            Enum = "📋",
            Keyword = "🔑",
            Snippet = "✂️",
            Color = "🎨",
            File = "📄",
            Reference = "📚",
            Folder = "📁",
            EnumMember = "👥",
            Constant = "🔴",
            Struct = "🏗️",
            Event = "📡",
            Operator = "➕",
            TypeParameter = "🔤",
          }
          vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind] or "", vim_item.kind)
          vim_item.menu = ({
            nvim_lsp = "[LSP]",
            nvim_lua = "[Lua]",
            luasnip = "[Snippet]",
            buffer = "[Buffer]",
            path = "[Path]",
          })[entry.source.name]
          return vim_item
        end,
      },
    })
  end,
}

-- Git integration avançada com UI moderna, equivalente ao Source Control do VSCode

return {
  -- Fugitive: comandos de git clássicos do Vim (:Git status, :Git blame,
  -- :Git log etc.), complementar ao Neogit — útil pra quem já conhece os
  -- comandos do fugitive ou quer algo mais leve que o painel completo.
  { "tpope/vim-fugitive", cmd = "Git" },

  -- Gitsigns: sinais de git na coluna esquerda (linha adicionada/modificada/removida),
  -- com blame inline e diff virtual
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
        current_line_blame = true,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "eol",
          delay = 1000,
          ignore_whitespace = true,
        },
        numhl = false,
        linehl = false,
        word_diff = false,
        watch_gitdir = {
          follow_files = true,
        },
        diff_opts = { internal = true },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, {expr=true})
          map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, {expr=true})

          -- Actions
          map('n', '<leader>hs', gs.stage_hunk, { desc = "Stage hunk" })
          map('n', '<leader>hu', gs.undo_stage_hunk, { desc = "Undo stage hunk" })
          map('n', '<leader>hr', gs.reset_hunk, { desc = "Reset hunk" })
          map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line("."), vim.fn.line("v")} end, { desc = "Stage hunk (visual)" })
          map('v', '<leader>hu', function() gs.undo_stage_hunk {vim.fn.line("."), vim.fn.line("v")} end, { desc = "Undo stage hunk (visual)" })
          map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line("."), vim.fn.line("v")} end, { desc = "Reset hunk (visual)" })
          map('n', '<leader>hR', gs.reset_buffer, { desc = "Reset buffer" })
          map('n', '<leader>hp', gs.preview_hunk, { desc = "Preview hunk" })
          map('n', '<leader>hb', function() gs.blame_line{full=true} end, { desc = "Blame line (full)" })
          map('n', '<leader>hd', gs.diffthis, { desc = "Diff this" })
          map('n', '<leader>hD', function() gs.diffthis('~') end, { desc = "Diff this (~)" })
          map('n', '<leader>htd', gs.toggle_deleted, { desc = "Toggle deleted" })
        end
      })
    end,
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
      { "<leader>gc", ":Neogit commit<CR>", desc = "Commit interativo" },
      { "<leader>gp", ":Neogit pull<CR>", desc = "Pull" },
      { "<leader>gP", ":Neogit push<CR>", desc = "Push" },
    },
    opts = {
      kind = "tab", -- abre em uma nova aba ao invés de split
      disable_line_numbers = false,
    },
  },

  -- Enhanced Diffview com telescope integration
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewFileHistory",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewRefresh",
    },
  },

  -- Git Conflict (Neovim 0.11+): resolver conflitos visualmente
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    config = function()
      require("git-conflict").setup({
        default_mappings = true,
        default_commands = true,
        disable_diagnostics = false,
        list_opener = "copen",
        markers = { current = "ours", incoming = "theirs", divider = "divider" },
      })
    end,
    keys = {
      { "<leader>co", ":GitConflictChooseOurs<CR>", desc = "Choose ours (git conflict)" },
      { "<leader>ct", ":GitConflictChooseTheirs<CR>", desc = "Choose theirs (git conflict)" },
      { "<leader>cb", ":GitConflictChooseBoth<CR>", desc = "Choose both (git conflict)" },
      { "<leader>cx", ":GitConflictChooseNone<CR>", desc = "Choose none (git conflict)" },
    },
  },
}

-- Debugging e execução de testes com UI moderno, como VSCode

return {
  -- nvim-dap: debugging protocol (integração com debuggers reais)
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui", -- UI moderna pra debugger
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text", -- mostra variáveis inline
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Setup da UI
      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        layouts = {
          {
            elements = {
              "scopes",
              "breakpoints",
              "stacks",
              "watches",
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              "repl",
              "console",
            },
            size = 10,
            position = "bottom",
          },
        },
        floating = {
          max_height = nil,
          max_width = nil,
          border = "single",
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
        windows = { indent = 1 },
        render = {
          max_type_length = nil,
          max_value_length = 100,
        },
      })

      -- Abre UI do debugger automaticamente
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      -- Virtual text para variáveis
      require("nvim-dap-virtual-text").setup()
    end,
    keys = {
      { "<leader>db", ":DapToggleBreakpoint<CR>", desc = "Toggle breakpoint" },
      { "<leader>dc", ":DapContinue<CR>", desc = "Continue debugging" },
      { "<leader>do", ":DapStepOver<CR>", desc = "Step over" },
      { "<leader>di", ":DapStepInto<CR>", desc = "Step into" },
      { "<leader>du", ":DapStepOut<CR>", desc = "Step out" },
      { "<leader>dq", ":DapTerminate<CR>", desc = "Terminate debugger" },
    },
  },

  -- nvim-neotest: teste framework com UI visual
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- adaptadores para diferentes linguagens
      "nvim-neotest/neotest-jest",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-go",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-jest")({
            jestCommand = "npm test --",
            jestConfigFile = "jest.config.js",
            env = { CI = true },
            cwd = function(_)
              return vim.fn.getcwd()
            end,
          }),
          require("neotest-python")({
            dap = { justMyCode = true },
          }),
          require("neotest-go"),
        },
        icons = {
          expanded = "▾",
          child_indent = "│",
          child_prefix = "├",
          collapsed = "▸",
          failed = "✗",
          passed = "✓",
          running = "⟳",
          skipped = "⊘",
          unknown = "?",
        },
      })
    end,
    keys = {
      { "<leader>tt", ":Neotest run<CR>", desc = "Rodar testes (current file)" },
      { "<leader>tn", ":Neotest run --no-coverage<CR>", desc = "Rodar teste next" },
      { "<leader>ts", ":Neotest summary<CR>", desc = "Abrir summary de testes" },
      { "<leader>ta", ":Neotest attach<CR>", desc = "Attach to test" },
      { "<leader>td", ":Neotest debug<CR>", desc = "Debug test" },
      { "<leader>to", ":Neotest output<CR>", desc = "Ver output do teste" },
    },
  },

  -- vim-test: suporte a testes com múltiplos runners (Jest, Pytest, etc.)
  {
    "vim-test/vim-test",
    keys = {
      { "<leader>t.", ":TestNearest<CR>", desc = "Rodar teste mais próximo" },
      { "<leader>tf", ":TestFile<CR>", desc = "Rodar todos os testes do arquivo" },
      { "<leader>ts", ":TestSuite<CR>", desc = "Rodar suite de testes" },
      { "<leader>tl", ":TestLast<CR>", desc = "Rodar último teste" },
      { "<leader>tv", ":TestVisit<CR>", desc = "Visitar último teste" },
    },
    config = function()
      vim.cmd([[let test#strategy = "neovim"]])
      vim.cmd([[let test#neovim#term_opts = { 'modifiable': v:false }]])
    end,
  },

  -- Better quickfix window
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = {},
  },
}

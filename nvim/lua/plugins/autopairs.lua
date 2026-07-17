-- Autopairs: fecha automaticamente parênteses, colchetes, chaves e aspas
-- (abrir "{" já insere o "}" e deixa o cursor entre os dois).
return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  dependencies = { "hrsh7th/nvim-cmp" },
  opts = {},
  config = function(_, opts)
    local autopairs = require("nvim-autopairs")
    autopairs.setup(opts)

    -- Integra com o nvim-cmp: confirmar uma função no autocomplete já insere
    -- os parênteses "()" (ex: aceitar "console.log" vira "console.log()").
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local cmp = require("cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
}

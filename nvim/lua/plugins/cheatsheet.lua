-- Cheat sheet completa e pesquisável dentro do próprio Neovim: não só
-- atalhos, também comandos e fluxos comuns (ver nvim/cheatsheet.txt). Abre
-- com :Cheatsheet, <leader>? ou Cmd+? — busca fuzzy via Telescope.
return {
  "sudormrfbin/cheatsheet.nvim",
  cmd = "Cheatsheet",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("cheatsheet").setup({
      -- Só a cheat sheet personalizada deste repo (nvim/cheatsheet.txt, lida
      -- automaticamente de ~/.config/nvim/cheatsheet.txt); sem os bundles
      -- genéricos de linguagens/plugins que vêm por padrão (ficaria poluído).
      bundled_cheatsheets = false,
      bundled_plugin_cheatsheets = false,
      include_only_installed_plugins = true,
    })
  end,
}

-- Bootstrap do lazy.nvim: baixa o gerenciador de plugins na primeira execução
-- (se ele ainda não existir localmente) e depois carrega todos os arquivos
-- dentro de lua/plugins/ como especificações de plugins.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  install = { colorscheme = { "catppuccin" } },
  checker = { enabled = true, notify = false }, -- avisa quando há updates de plugin, sem popup chato
})

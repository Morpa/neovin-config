-- Ponto de entrada do Neovim. Carrega, em ordem:
-- 1. opções gerais (lua/config/options.lua)
-- 2. atalhos de teclado (lua/config/keymaps.lua)
-- 3. bootstrap do lazy.nvim + carregamento de todos os plugins em lua/plugins/*.lua
-- 4. helpers customizados (hover-helper, samurai-dojo, etc)

require("config.options")
require("config.keymaps")
require("config.lazy")
require("config.autocmds")
require("config.hover-helper").setup()       -- Setup do helper de hover/documentação
require("config.samurai-dojo").setup()       -- Setup da filosofia Samurai Code

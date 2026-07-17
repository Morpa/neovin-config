-- Alpha: tela inicial (dashboard) mostrada quando você abre `nvim` sem
-- argumento nenhum — atalhos rápidos pra achar/recentemente abrir arquivos,
-- em vez de uma tela em branco. Quando você abre uma pasta (`nvim .`), quem
-- assume a tela é o neo-tree (ver autocmd em ui.lua).
return {
  "goolord/alpha-nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  -- NÃO usar event = "VimEnter": o alpha registra seu próprio autocmd de
  -- VimEnter dentro do setup() pra decidir se mostra o dashboard, e se o
  -- lazy.nvim só carregar o plugin QUANDO o VimEnter disparar, esse novo
  -- autocmd é registrado tarde demais e nunca dispara (testado headless:
  -- ficava com buffer vazio, sem dashboard). Carregando sem lazy, o
  -- autocmd do alpha já existe antes do VimEnter real acontecer.
  lazy = false,
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.startify")

    -- Logo grande em blocos, no lugar do cabeçalho pequeno (cursiva) que o
    -- tema startify usa por padrão.
    dashboard.section.header.val = {
      [[ ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗]],
      [[ ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║]],
      [[ ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║]],
      [[ ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║]],
      [[ ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║]],
      [[ ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
    }

    alpha.setup(dashboard.opts)
  end,
}

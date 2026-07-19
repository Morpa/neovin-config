-- Alpha: tela inicial (dashboard) mostrada quando você abre `nvim` sem
-- argumento nenhum — atalhos rápidos pra achar/recentemente abrir arquivos,
-- em vez de uma tela em branco. Quando você abre uma pasta (`nvim .`), quem
-- assume a tela é o explorer do snacks.nvim (replace_netrw, ver ui.lua).
return {
  "goolord/alpha-nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = false,
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Logo SAMURAI em estilo japonês 🗡️ (versão épica)
    dashboard.section.header.val = {
      [[        ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
      [[        ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
      [[        　　　　　　　　　　　　　　　 ╔═══════╗　　　　　　　　 ]],
      [[        　　　　　　　　　　　　　　　 ║ ⚔️ ║　　　　　　　　 ]],
      [[        　　　　　　　　　　　　　　　 ╠═════╣　　　　　　　　 ]],
      [[        　　　╔═════╦═════╦═════╦═════╬═════╬═════╦═════╦═════╗　]],
      [[        　　　║ Ｓ ║ Ａ ║ Ｍ ║ Ｕ ║ Ｒ ║ Ａ ║ Ｉ ║ 刀 ║　]],
      [[        　　　╚═════╩═════╩═════╩═════╩═════╩═════╩═════╩═════╝　]],
      [[        　　　　　　　　　 🥋 CODE NINJA WARRIOR 🥋　　　　　　　 ]],
      [[        　　　　　　　　　　　　　　　 刀 刀 刀　　　　　　　　 ]],
      [[        ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
      [[        ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    }
    dashboard.section.header.opts.hl = "AlphaHeader"

    -- Botões de ação rápida com tema SAMURAI 🗡️
    dashboard.section.buttons.val = {
      dashboard.button("f", "🔍 Buscar caminho (Ninja Scout)", ":Telescope find_files<CR>"),
      dashboard.button("r", "⏳ Recentes (Memória Samurai)", ":Telescope oldfiles<CR>"),
      dashboard.button("g", "🔎 Procurar no código (Busca Profunda)", ":Telescope live_grep<CR>"),
      dashboard.button("c", "⚙️  Configuração (Temperar a Lâmina)", ":edit $MYVIMRC<CR>"),
      dashboard.button("l", "🛠️  Ferramentas (Forja)", ":Mason<CR>"),
      dashboard.button("q", "🚪 Retirar-se (Seppuku)", ":qa<CR>"),
    }

    -- Footer com filosofia SAMURAI
    local function footer()
      local quotes = {
        "🗡️  A lâmina do código é afiada - mantenha-a limpa",
        "⛩️  O verdadeiro Samurai domina Vim - <leader>? para aprender",
        "🌸 Wa (和) - Harmonia com o código",
        "🥋 Bushin (武士) - O caminho do guerreiro do código",
        "💎 Meiyo (名誉) - Honre seu código",
        "🎯 Zanshin (残心) - Permaneça focado",
      }
      
      local quote = quotes[math.random(#quotes)]
      return {
        "",
        quote,
        "📖 Docs: https://neovim.io/doc/ | Type :help para dominar",
        "",
      }
    end
    dashboard.section.footer.val = footer()
    dashboard.section.footer.opts.hl = "AlphaFooter"

    alpha.setup(dashboard.opts)
  end,
}

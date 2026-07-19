-- Opções gerais do editor (equivalente ao "settings.json" do Zed)

-- O fnm só é ativado no PATH pelo fish (ver ~/.config/fish/config.fish).
-- Se o Neovim for aberto a partir de algo que não passa pelo shell de login
-- (ex: um launcher gráfico), node/npm/tsc podem sumir do PATH e LSPs que
-- dependem deles (ts_ls) falham com "Could not find a valid TypeScript
-- installation". O alias "default" do fnm é um caminho estável que sempre
-- aponta pra versão ativa, então prependemos ele aqui direto como safety-net.
do
    local fnm_default_bin = vim.fn.expand("~/.local/share/fnm/aliases/default/bin")
    if vim.fn.isdirectory(fnm_default_bin) == 1 then
        vim.env.PATH = fnm_default_bin .. ":" .. vim.env.PATH
    end
end

local opt = vim.opt

opt.number = true          -- mostra número da linha atual
opt.relativenumber = false -- deixa false pra ficar mais parecido com o Zed (números absolutos)
opt.cursorline = true      -- destaca a linha onde está o cursor
opt.wrap = false           -- não quebra linhas longas visualmente
opt.scrolloff = 8          -- mantém 8 linhas de contexto ao rolar
opt.signcolumn = "yes"     -- coluna fixa pra ícones de git/diagnóstico (evita "pulo" de layout)

-- Indentação: 2 espaços, sem tabs reais (padrão comum em JS/TS; ajustado por linguagem depois se precisar)
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- Busca
opt.ignorecase = true
opt.smartcase = true -- ignora case, exceto se você digitar letra maiúscula
opt.hlsearch = true
opt.incsearch = true

-- Aparência
opt.termguicolors = true -- cores de 24-bit (necessário pra temas modernos)
opt.background = "dark"
opt.mouse = "a"          -- mouse funciona em todos os modos (clicar em abas, ícones, redimensionar painel etc.)
vim.g.guifont = "Iosevka Nerd Font Propo:h16"
if vim.g.neovide then
    vim.o.guifont = vim.g.guifont
elseif vim.fn.has("gui_running") == 1 then
    vim.o.guifont = vim.g.guifont
end

-- Formato do cursor por modo: bloco parado no modo Normal (padrão do Vim),
-- mas uma barra vertical piscando no modo de inserção e dentro do terminal —
-- igual ao cursor "de texto" do Zed e de qualquer terminal de verdade.
opt.guicursor = table.concat({
    "n-v-c:block",                                     -- Normal/Visual/Command: bloco sólido
    "i-ci-ve:ver25-blinkwait300-blinkoff300-blinkon300", -- Inserção: barra piscando
    "t:ver25-blinkwait300-blinkoff300-blinkon300",     -- Terminal: barra piscando
    "r-cr:hor20",                                      -- Replace: sublinhado
    "o:hor50",                                         -- Operator-pending: meio sublinhado
}, ",")

-- Splits abrem do jeito "natural" (embaixo/direita), como a maioria dos editores modernos
opt.splitright = true
opt.splitbelow = true

-- Arquivos
opt.swapfile = false
opt.backup = false
opt.undofile = true  -- histórico de undo persiste entre sessões
opt.updatetime = 250 -- LSP e git-signs reagem mais rápido

-- Barra de status é feita por plugin (lualine), então escondemos a nativa
opt.laststatus = 3 -- uma única statusline global (janela unificada, como no Zed)

-- Usa espaço em branco visível pra tab/trailing (ajuda a notar bagunça de indentação)
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Esconde o "~" que alguns temas deixam visível nas linhas depois do fim do buffer.
opt.fillchars = { eob = " " }

-- Clipboard do sistema (copiar/colar igual qualquer app do macOS)
opt.clipboard = "unnamedplus"

-- Shell usado pelo terminal integrado e por comandos tipo :!. O padrão do
-- Neovim é /bin/zsh e não lê seu shell de login do macOS — por isso resolvemos
-- o fish via $PATH (funciona em Apple Silicon e Intel), com fallback pro
-- shell padrão do sistema caso o fish não esteja instalado.
do
    local fish_path = vim.fn.exepath("fish")
    if fish_path ~= "" then
        opt.shell = fish_path
    end
end

vim.g.mapleader = " " -- barra de espaço como tecla líder (padrão da maioria das configs modernas)
vim.g.maplocalleader = " "

-- Título da janela/aba do terminal: em vez do nome do buffer com foco (ex: o
-- nome interno do buffer do painel de arquivos lateral quando o cursor está
-- nele), sempre mostra o nome da pasta do projeto (cwd).
opt.title = true
opt.titlestring = "%{fnamemodify(getcwd(), ':t')}"

-- Mostra o diagnóstico (erro/aviso do LSP) automaticamente num float quando o
-- cursor fica parado numa linha que tem diagnóstico — sem precisar chamar
-- vim.diagnostic.open_float() manualmente toda vez.
vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
        vim.diagnostic.open_float(nil, { focus = false })
    end,
})

-- A mensagem de "written" (ou qualquer outra) fica grudada na linha de
-- comando até algo a sobrescrever — trocar de buffer sozinho não faz isso.
-- Limpa a mensagem sempre que você entra em um buffer novo.
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        vim.defer_fn(function()
            vim.cmd("echon ''")
        end, 0)
    end,
})

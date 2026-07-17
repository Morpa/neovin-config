-- Atalhos de teclado. <leader> = barra de espaço (definido em options.lua)
-- Muitos desses atalhos só funcionam depois que os plugins carregarem (telescope, snacks etc.)
local map = vim.keymap.set

-- Movimentação entre janelas (splits) com Ctrl+hjkl, como em qualquer editor com painéis
map("n", "<C-h>", "<C-w>h", { desc = "Ir para janela à esquerda" })
map("n", "<C-j>", "<C-w>j", { desc = "Ir para janela abaixo" })
map("n", "<C-k>", "<C-w>k", { desc = "Ir para janela acima" })
map("n", "<C-l>", "<C-w>l", { desc = "Ir para janela à direita" })

-- Criar splits (painéis lado a lado / em cima e embaixo), equivalente a abrir
-- arquivos lado a lado no Zed
map("n", "<leader>|", ":vsplit<CR>", { desc = "Split vertical (lado a lado)" })
map("n", "<leader>-", ":split<CR>", { desc = "Split horizontal (em cima/embaixo)" })

-- Navegação entre buffers/abas, parecido com Cmd+Shift+] / [ do Zed
map("n", "<S-l>", ":bnext<CR>", { desc = "Próximo buffer" })
map("n", "<S-h>", ":bprevious<CR>", { desc = "Buffer anterior" })
map("n", "<leader>bd", ":bdelete<CR>", { desc = "Fechar buffer" })

-- Salvar e sair
map("n", "<leader>w", ":w<CR>", { desc = "Salvar arquivo" })
map("n", "<leader>q", ":q<CR>", { desc = "Fechar janela" })

-- Busca fuzzy (telescope), equivalente ao Cmd+P / Cmd+Shift+F do Zed
map("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Buscar arquivos" })
map("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Buscar texto no projeto" })
map("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Buscar entre buffers abertos" })
map("n", "<leader>fr", ":Telescope oldfiles<CR>", { desc = "Arquivos recentes" })

-- Diagnósticos (erros/avisos do LSP), equivalente ao painel de problemas do Zed
map("n", "<leader>xx", ":Trouble diagnostics toggle<CR>", { desc = "Alternar lista de diagnósticos" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Próximo diagnóstico" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Diagnóstico anterior" })

-- Terminal integrado (toggleterm), equivalente ao terminal embutido do Zed
map("n", "<leader>t", ":ToggleTerm<CR>", { desc = "Alternar terminal" })
map("t", "<Esc>", [[<C-\><C-n>]], { desc = "Sair do modo terminal" })

-- Mantém o texto selecionado ao indentar com < e > (sem isso, cada indent te tira da seleção)
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Atalhos com Cmd que imitam o Zed/VSCode/qualquer editor "normal" de Mac, pra
-- não precisar decorar os comandos no estilo Vim (<leader>...) de cara.
-- Funcionam tanto no Ghostty (protocolo de teclado do Kitty) quanto seriam
-- usados no Neovide; não dependem de GUI.

-- Cmd+C / Cmd+V / Cmd+S como em qualquer app do macOS (por padrão Vim usa outras teclas pra isso)
map("v", "<D-c>", '"+y', { desc = "Copiar (Cmd+C)" })
map({ "n", "v" }, "<D-v>", '"+p', { desc = "Colar (Cmd+V)" })
map("i", "<D-v>", "<C-r>+", { desc = "Colar (Cmd+V) no modo inserção" })
map({ "n", "i", "v" }, "<D-s>", "<Esc>:w<CR>", { desc = "Salvar (Cmd+S)" })
map({ "n", "i", "v" }, "<D-q>", "<Esc>:qa<CR>", { desc = "Sair (Cmd+Q)" })

-- Cmd+/ comenta/descomenta a linha (ou a seleção) — usa o suporte nativo do próprio Neovim.
-- Em teclado ABNT, "/" só sai com Shift, então esse combo vira fisicamente
-- Cmd+Shift+/ (= Cmd+?), que o macOS intercepta globalmente pra abrir a busca
-- do menu Help ANTES de chegar no Ghostty/Neovim (ver instruções no README pra
-- liberar isso em Ajustes do Sistema > Teclado > Atalhos de Teclado > Atalhos
-- de App). Por isso <leader>/ existe como alternativa que sempre funciona.
map("n", "<D-/>", "gcc", { desc = "Comentar/descomentar linha (Cmd+/)", remap = true })
map("v", "<D-/>", "gc", { desc = "Comentar/descomentar seleção (Cmd+/)", remap = true })
map("n", "<leader>/", "gcc", { desc = "Comentar/descomentar linha", remap = true })
map("v", "<leader>/", "gc", { desc = "Comentar/descomentar seleção", remap = true })

-- Cmd+P busca arquivo, Cmd+F busca dentro do arquivo atual, Cmd+Shift+F busca
-- texto no projeto — igual ao Zed
map("n", "<D-p>", ":Telescope find_files<CR>", { desc = "Buscar arquivo (Cmd+P)" })
map("n", "<D-f>", "/", { desc = "Buscar no arquivo atual, inline (Cmd+F)" })
map("n", "<D-F>", ":Telescope live_grep<CR>", { desc = "Buscar texto no projeto (Cmd+Shift+F)" })
map("n", "<D-P>", ":Telescope commands<CR>", { desc = "Paleta de comandos (Cmd+Shift+P)" })

-- n/N navegam pra próxima/anterior ocorrência da busca; o hlslens só
-- adiciona o contador "3/12" perto do cursor (o comportamento de navegação
-- em si já é nativo do Vim).
local hlslens_opts = { noremap = true, silent = true }
map("n", "n", [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], hlslens_opts)
map("n", "N", [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], hlslens_opts)

-- Esc limpa o destaque da busca atual (:noh), além do comportamento normal do Esc
map("n", "<Esc>", ":noh<CR>", { desc = "Limpar destaque de busca" })

-- Cmd+Z desfaz, Cmd+Shift+Z refaz
-- (Cmd+W fica por conta do Ghostty, que fecha a aba/surface; pra fechar o
-- buffer dentro do Neovim use <leader>bd.)
map({ "n", "v" }, "<D-z>", "u", { desc = "Desfazer (Cmd+Z)" })
map({ "n", "v" }, "<D-Z>", "<C-r>", { desc = "Refazer (Cmd+Shift+Z)" })
map("i", "<D-z>", "<Esc>u", { desc = "Desfazer (Cmd+Z)" })
map("i", "<D-Z>", "<Esc><C-r>", { desc = "Refazer (Cmd+Shift+Z)" })

-- Option+Cima/Baixo move a linha (ou seleção) inteira pra cima/baixo — igual ao Zed/VSCode
map("n", "<M-Up>", ":move .-2<CR>==", { desc = "Mover linha pra cima" })
map("n", "<M-Down>", ":move .+1<CR>==", { desc = "Mover linha pra baixo" })
map("v", "<M-Up>", ":move '<-2<CR>gv=gv", { desc = "Mover seleção pra cima" })
map("v", "<M-Down>", ":move '>+1<CR>gv=gv", { desc = "Mover seleção pra baixo" })

-- Shift+Option+Baixo duplica a linha (ou seleção) logo abaixo, cursor fica na cópia — igual ao Zed/VSCode
map("n", "<M-S-Down>", ":t.<CR>", { desc = "Duplicar linha pra baixo" })
map("v", "<M-S-Down>", ":t'><CR>`[V`]", { desc = "Duplicar seleção pra baixo" })

-- Cmd+] / Cmd+[ indenta/desindenta, mantendo a seleção
map("v", "<D-]>", ">gv", { desc = "Indentar seleção (Cmd+])" })
map("v", "<D-[>", "<gv", { desc = "Desindentar seleção (Cmd+[)" })
map("n", "<D-]>", ">>", { desc = "Indentar linha (Cmd+])" })
map("n", "<D-[>", "<<", { desc = "Desindentar linha (Cmd+[)" })

-- Cmd+1 até Cmd+9 pula direto pra aba N, igual ao Zed
for i = 1, 9 do
  map("n", "<D-" .. i .. ">", function()
    require("bufferline").go_to(i, true)
  end, { desc = "Ir para aba " .. i })
end

-- Abre a cheat sheet completa (atalhos, comandos, plugins e fluxos).
-- Sem atalho Cmd: Cmd+? é fisicamente o mesmo combo que Cmd+/ em teclado
-- ABNT, e o macOS rouba os dois pra busca do menu Help (ver nota acima).
map("n", "<leader>?", ":Cheatsheet<CR>", { desc = "Abrir cheat sheet" })

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

-- LSP avançado (chamados pela keybind quando o LSP está ativo, mas deixamos aqui pro which-key)
-- Ver lsp.lua pra mapeamentos reais (gd, gr, K, etc.)
map("n", "<leader>lm", ":Mason<CR>", { desc = "Gerenciador de LSP/formatadores" })

-- Git avançado (além dos basics do neogit)
map("n", "<leader>gh", ":Telescope git_branches<CR>", { desc = "Branches do Git" })
map("n", "<leader>gc", ":Telescope git_commits<CR>", { desc = "Commits do Git" })
map("n", "<leader>gs", ":Telescope git_stash<CR>", { desc = "Stash do Git" })

-- Snippets e autocomplete
map("n", "<leader>se", ":Telescope luasnip<CR>", { desc = "Explorar snippets" })

-- Marca/bookmarks (usando snacks ou built-in do Vim)
map("n", "m<space>", ":BookmarksList<CR>", { desc = "Listar marcas", noremap = true })

-- Atalhos em modo insert (completions avançadas já no arquivo)
map("i", "<C-x><C-k>", "<C-o>:lua vim.lsp.buf.signature_help()<CR>", { noremap = true, desc = "Ver assinatura LSP" })
map("i", "<C-x><C-d>", "<C-o>:lua vim.lsp.buf.hover()<CR>", { noremap = true, desc = "Ver docs LSP" })

-- Grupo de atalhos para DOCUMENTAÇÃO/HOVER (mais opções que K que às vezes pode não funcionar)
-- <leader>h = tudo relacionado a help/hover
map("n", "<leader>hh", function()
  local clients = vim.lsp.get_active_clients({ bufnr = 0 })
  if #clients == 0 then
    vim.notify("⚠️  Nenhum LSP ativo neste buffer", vim.log.levels.WARN)
    return
  end
  vim.lsp.buf.hover()
end, { desc = "Hover/Documentação (LSP)" })

map("n", "<leader>hs", vim.lsp.buf.signature_help, { desc = "Signature help" })
map("n", "<leader>hi", vim.lsp.buf.implementation, { desc = "Implementação" })
map("n", "<leader>ht", vim.lsp.buf.type_definition, { desc = "Type definition" })

-- Alternativas também em modo visual (pra quando tiver selecionado)
map("v", "<leader>hh", function()
  vim.lsp.buf.hover()
end, { desc = "Hover/Documentação" })

-- Mantém o texto selecionado ao indentar com < e > (sem isso, cada indent te tira da seleção)
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Atalhos com Cmd que imitam o Zed/VSCode/qualquer editor "normal" de Mac, pra
-- não precisar decorar os comandos no estilo Vim (<leader>...) de cara.
-- Funcionam tanto no Ghostty (protocolo de teclado do Kitty) quanto seriam
-- usados no Neovide; não dependem de GUI.

-- Ctrl+C / Ctrl+V / Ctrl+S para copiar/colar/salvar — funciona em qualquer OS
map("v", "<C-c>", '"+y', { desc = "Copiar (Ctrl+C)" })
map({ "n", "v" }, "<C-v>", '"+p', { desc = "Colar (Ctrl+V)" })
map("i", "<C-v>", "<C-r>+", { desc = "Colar (Ctrl+V) no modo inserção" })
map({ "n", "i", "v" }, "<C-s>", "<Esc>:w<CR>", { desc = "Salvar (Ctrl+S)" })

-- Ctrl+A seleciona tudo (select all) — igual ao VSCode e qualquer editor moderno
map("n", "<C-a>", "ggVG", { desc = "Selecionar tudo (Ctrl+A)" })
map("i", "<C-a>", "<Esc>ggVG", { desc = "Selecionar tudo (Ctrl+A)" })
map("v", "<C-a>", "ggVG", { desc = "Selecionar tudo (Ctrl+A)" })

-- Atalhos de seleção adicionais (úteis no dia-a-dia)
map("n", "<leader>sa", "ggVG", { desc = "Selecionar tudo" })
map("v", "<leader>sa", "ggVG", { desc = "Selecionar tudo (reseleciona)" })

-- Ctrl+/ comenta/descomenta a linha (ou a seleção) — usa o suporte nativo do próprio Neovim.
map("n", "<C-/>", "gcc", { desc = "Comentar/descomentar linha (Ctrl+/)", remap = true })
map("v", "<C-/>", "gc", { desc = "Comentar/descomentar seleção (Ctrl+/)", remap = true })
map("n", "<leader>/", "gcc", { desc = "Comentar/descomentar linha", remap = true })
map("v", "<leader>/", "gc", { desc = "Comentar/descomentar seleção", remap = true })

-- Ctrl+P busca arquivo, Ctrl+F busca dentro do arquivo atual, Ctrl+Shift+F busca
-- texto no projeto — igual ao Zed
map("n", "<C-p>", ":Telescope find_files<CR>", { desc = "Buscar arquivo (Ctrl+P)" })
map("n", "<C-f>", "/", { desc = "Buscar no arquivo atual, inline (Ctrl+F)" })
map("n", "<C-S-f>", ":Telescope live_grep<CR>", { desc = "Buscar texto no projeto (Ctrl+Shift+F)" })
map("n", "<C-S-p>", ":Telescope commands<CR>", { desc = "Paleta de comandos (Ctrl+Shift+P)" })

-- n/N navegam pra próxima/anterior ocorrência da busca; o hlslens só
-- adiciona o contador "3/12" perto do cursor (o comportamento de navegação
-- em si já é nativo do Vim).
local hlslens_opts = { noremap = true, silent = true }
map("n", "n", [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], hlslens_opts)
map("n", "N", [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], hlslens_opts)

-- Esc limpa o destaque da busca atual (:noh), além do comportamento normal do Esc
map("n", "<Esc>", ":noh<CR>", { desc = "Limpar destaque de busca" })

-- Ctrl+Z desfaz, Ctrl+Shift+Z refaz
map({ "n", "v" }, "<C-z>", "u", { desc = "Desfazer (Ctrl+Z)" })
map({ "n", "v" }, "<C-S-z>", "<C-r>", { desc = "Refazer (Ctrl+Shift+Z)" })
map("i", "<C-z>", "<Esc>u", { desc = "Desfazer (Ctrl+Z)" })
map("i", "<C-S-z>", "<Esc><C-r>", { desc = "Refazer (Ctrl+Shift+Z)" })

-- Option+Cima/Baixo move a linha (ou seleção) inteira pra cima/baixo — igual ao Zed/VSCode
map("n", "<M-Up>", ":move .-2<CR>==", { desc = "Mover linha pra cima" })
map("n", "<M-Down>", ":move .+1<CR>==", { desc = "Mover linha pra baixo" })
map("v", "<M-Up>", ":move '<-2<CR>gv=gv", { desc = "Mover seleção pra cima" })
map("v", "<M-Down>", ":move '>+1<CR>gv=gv", { desc = "Mover seleção pra baixo" })

-- Shift+Option+Baixo duplica a linha (ou seleção) logo abaixo, cursor fica na cópia — igual ao Zed/VSCode
map("n", "<M-S-Down>", ":t.<CR>", { desc = "Duplicar linha pra baixo" })
map("v", "<M-S-Down>", ":t'><CR>`[V`]", { desc = "Duplicar seleção pra baixo" })

-- Ctrl+] / Ctrl+[ indenta/desindenta, mantendo a seleção
map("v", "<C-]>", ">gv", { desc = "Indentar seleção (Ctrl+])" })
map("v", "<C-[>", "<gv", { desc = "Desindentar seleção (Ctrl+[)" })
map("n", "<C-]>", ">>", { desc = "Indentar linha (Ctrl+])" })
map("n", "<C-[>", "<<", { desc = "Desindentar linha (Ctrl+[)" })

-- Ctrl+1 até Ctrl+9 pula direto pra aba N
for i = 1, 9 do
  map("n", "<C-" .. i .. ">", function()
    require("bufferline").go_to(i, true)
  end, { desc = "Ir para aba " .. i })
end

-- Abre a cheat sheet completa (atalhos, comandos, plugins e fluxos).
-- Sem atalho Cmd: Cmd+? é fisicamente o mesmo combo que Cmd+/ em teclado
-- ABNT, e o macOS rouba os dois pra busca do menu Help (ver nota acima).
map("n", "<leader>?", ":Cheatsheet<CR>", { desc = "Abrir cheat sheet" })

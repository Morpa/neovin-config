# Atalhos únicos, busca inline e troca de sidebar — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reduzir a confusão entre atalhos `Cmd+...` e `<leader>...` na documentação, trocar a busca dentro do arquivo (`Cmd+F`) por uma busca inline (estilo VSCode/Zed), e substituir a barra lateral de arquivos (neo-tree) por `snacks.nvim` explorer.

**Architecture:** Mudanças isoladas em arquivos de config Lua já existentes (`nvim/lua/plugins/*.lua`, `nvim/lua/config/*.lua`) mais dois arquivos de documentação (`README.md`, `nvim/cheatsheet.txt`). Nenhuma automação de teste existe neste repo — verificação é manual (abrir o Neovim e observar o comportamento), como já documentado no spec.

**Tech Stack:** Neovim 0.12 + lazy.nvim, Lua. Plugin novo: `kevinhwang91/nvim-hlslens` (contador de ocorrências de busca). Troca de plugin: `nvim-neo-tree/neo-tree.nvim` → `folke/snacks.nvim` (módulo `explorer`).

## Global Constraints

- Não remover nenhum keymap funcional do `keymaps.lua` só por estar "duplicado" na documentação — os atalhos `<leader>...` equivalentes a um `Cmd+...` continuam funcionando, só saem das tabelas do README/cheatsheet.
- Rust, Go e TypeScript (LSP, formatação, testes) e Flutter/Dart (fora de escopo) não são tocados neste plano.
- Este repositório (`~/Documents/DEV/nvim-config`) **não é um repositório git** — não existem passos de `git commit` neste plano. Cada tarefa termina com "salvar o arquivo" e uma verificação manual.
- Verificação automática mínima disponível: `nvim --headless -u nvim/init.lua -c 'qa!'` a partir da raiz do repo falha alto (mensagem de erro Lua) se algum arquivo editado tiver erro de sintaxe — rode isso após cada edição antes da checagem visual.

## Setup (antes da Task 1)

Nesta máquina, `~/.config/nvim` ainda não existe (config nunca foi instalada aqui) — é possível confirmar com `ls ~/.config/nvim`, que hoje retorna "No such file or directory". Para poder testar ao vivo cada mudança sem copiar arquivos toda hora, crie um link simbólico apontando pra este repo:

```bash
ln -s ~/Documents/DEV/nvim-config/nvim ~/.config/nvim
```

A partir daí, qualquer edição feita nos arquivos deste repo já é a config ativa do Neovim imediatamente — não precisa rodar `install.sh` nem copiar nada entre as tasks. (Se depois quiser separar backup de config ativa como o README sugere, isso pode ser revisitado, mas está fora do escopo deste plano.)

---

### Task 1: Consolidar atalhos duplicados no README + seção "Primeiros dias"

**Files:**
- Modify: `README.md`

**Interfaces:** Nenhuma (documentação pura, não afeta nenhuma outra task).

- [ ] **Step 1: Remover a linha duplicada da árvore de arquivos na tabela "Arquivos e projeto"**

Em `README.md`, na tabela sob `### Arquivos e projeto`, remova esta linha (o `Cmd+B` acima dela já cobre a ação):

```markdown
| `space e` | Alternar árvore de arquivos (alternativa) |
```

A tabela final dessa seção deve ficar:

```markdown
### Arquivos e projeto
| Atalho | Ação |
|---|---|
| `Cmd+P` | Buscar arquivo pelo nome |
| `Cmd+F` | Buscar dentro do arquivo atual |
| `Cmd+Shift+F` | Buscar texto em todo o projeto |
| `Cmd+Shift+P` | Paleta de comandos |
| `Cmd+B` | Mostrar/esconder árvore de arquivos |
| `space f r` | Arquivos recentes |
| `space f b` | Buscar entre buffers abertos |
| `-` | Editar arquivos/pastas como texto (oil.nvim) |
```

(A descrição de `Cmd+F` muda de "buscar dentro do arquivo atual" pra remover qualquer menção a popup — o texto final vem da Task 3, que mexe nessa mesma linha de novo. Aqui só remova a duplicata de `space e`.)

- [ ] **Step 2: Consolidar Cmd+/ e space / em uma linha só, na tabela "Edição"**

Troque estas duas linhas da tabela sob `### Edição`:

```markdown
| `Cmd+/` | Comentar/descomentar linha ou seleção |
| `space /` | Comentar/descomentar (alternativa, sempre funciona) |
```

por uma linha só:

```markdown
| `Cmd+/` (ou `space /` em teclado ABNT) | Comentar/descomentar linha ou seleção |
```

O aviso detalhado sobre teclado ABNT logo abaixo da tabela **não muda** — continua explicando por que `Cmd+/` falha em ABNT e como corrigir de vez.

- [ ] **Step 3: Remover a linha duplicada do painel de git na tabela "Git"**

Remova esta linha da tabela sob `### Git` (o `Cmd+Shift+G` acima já cobre a ação):

```markdown
| `space g g` | Abrir painel de git completo (alternativa) |
```

- [ ] **Step 4: Adicionar a seção "Primeiros dias" logo no início de "## Atalhos"**

Logo depois da linha `as teclas Cmd chegam normalmente ao Neovim via protocolo de teclado do Kitty —` `não é mais um recurso exclusivo do Neovide.` (final do parágrafo de abertura da seção `## Atalhos`) e antes de `### Arquivos e projeto`, insira:

```markdown
### Primeiros dias

Antes de tentar decorar tudo, só isso já resolve 90% do dia a dia:

| Atalho | Ação |
|---|---|
| `Cmd+P` | Buscar arquivo pelo nome |
| `Cmd+Shift+F` | Buscar texto em todo o projeto |
| `Cmd+F` | Buscar dentro do arquivo atual |
| `Cmd+B` | Mostrar/esconder árvore de arquivos |
| `Cmd+S` | Salvar arquivo |
| `Cmd+Z` / `Cmd+Shift+Z` | Desfazer / refazer |
| `Cmd+/` | Comentar/descomentar linha ou seleção |
| `Cmd+Shift+G` | Abrir painel de git completo |
| `space t` | Abrir/esconder terminal integrado |
| `space t t` | Rodar o teste mais próximo do cursor |
| `space ?` | Abrir a cheat sheet completa |
| `space` (segurar ~1s) | Mostrar todos os atalhos disponíveis (which-key) |

O resto da lista abaixo é referência — não precisa memorizar, só volta aqui (ou aperta `space` e espera, ou abre `:Cheatsheet`) quando precisar de algo específico.
```

- [ ] **Step 5: Verificar sintaxe geral e revisar visualmente**

Rode, a partir da raiz do repo:

```bash
nvim --headless -u nvim/init.lua -c 'qa!'
```

Expected: nenhuma saída de erro (README não é carregado pelo Neovim, então este comando só confirma que nenhuma outra edição acidental quebrou a config; se não editou nenhum `.lua` ainda, deve sempre passar limpo).

Abra `README.md` num visualizador de markdown (ou `cat README.md` mesmo) e confirme:
- Não há mais nenhuma linha com a palavra "(alternativa)" nas tabelas de atalhos.
- A seção "Primeiros dias" aparece antes de "Arquivos e projeto".

- [ ] **Step 6: Salvar**

Arquivo já foi salvo pelo editor de texto/Edit tool — sem commit (repo não é git). Confirme com `git status` que retorna "Not a git repository" (esperado) ou, se em algum momento este repo virar um repositório git, faça o commit normalmente.

---

### Task 2: Reorganizar `nvim/cheatsheet.txt` com a mesma lógica de entrada única

**Files:**
- Modify: `nvim/cheatsheet.txt`

**Interfaces:** Nenhuma (arquivo de dados lido pelo plugin `cheatsheet.nvim` via `:Cheatsheet`; formato é `Descrição | comando-ou-tecla`, uma entrada por linha, agrupada em seções `## nome @tag1 @tag2`).

- [x] **Step 1: Remover a entrada duplicada de busca de arquivo**

Na seção `## arquivos-e-projeto`, remova:

```
Buscar arquivo pelo nome (alternativa) | <leader>ff
```

- [x] **Step 2: Remover a entrada duplicada de busca no projeto**

Na mesma seção, remova:

```
Buscar texto em todo o projeto (alternativa) | <leader>fg
```

- [x] **Step 3: Remover a entrada duplicada da árvore de arquivos**

Na mesma seção, remova:

```
Mostrar/esconder árvore de arquivos (alternativa) | <leader>e
```

(A linha `Mostrar/esconder árvore de arquivos (Cmd+B) | :Neotree toggle` também será atualizada na Task 4, quando o comando deixar de ser `:Neotree toggle`. Aqui só remova a duplicata.)

- [x] **Step 4: Consolidar a entrada de comentar linha**

Troque:

```
Comentar/descomentar linha ou seleção (Cmd+/, ou space / se o teclado for ABNT) | gcc
```

Não muda — essa linha já está no formato de entrada única (o texto entre parênteses já documenta a exceção ABNT sem duplicar a linha inteira). Pule este step sem alterações; ele existe só pra confirmar, na revisão, que essa entrada não precisa de mudança.

- [x] **Step 5: Remover a entrada duplicada do painel de git**

Na seção `## git`, remova:

```
Abrir painel de git completo (alternativa) | <leader>gg
```

- [x] **Step 6: Verificar o arquivo final**

Rode:

```bash
grep -n "alternativa" nvim/cheatsheet.txt
```

Expected: nenhuma linha retornada (todas as entradas "(alternativa)" foram removidas).

Abra o Neovim (`nvim` — com o symlink do Setup, já é a config ativa) e rode `:Cheatsheet`, digite "arquivo" e confirme que aparecem as entradas sem duplicata.

- [x] **Step 7: Salvar**

Commit realizado: 9bdf258

---

### Task 3: Busca inline no arquivo atual (`Cmd+F`) com `nvim-hlslens`

**Files:**
- Create: `nvim/lua/plugins/hlslens.lua`
- Modify: `nvim/lua/config/keymaps.lua:73` (linha do mapeamento de `Cmd+F`)
- Modify: `README.md` (linha de `Cmd+F` na tabela "Arquivos e projeto" e na seção "Primeiros dias", ambas já criadas/editadas na Task 1)
- Modify: `nvim/cheatsheet.txt` (linha de busca no arquivo atual)

**Interfaces:**
- Consome: `opt.incsearch` e `opt.hlsearch`, já `true` em `nvim/lua/config/options.lua:34-35` (nenhuma mudança necessária nesse arquivo — só confirmar na Step 1).
- Produz: `Cmd+F` (`<D-f>` em modo normal) abre busca nativa (`/`) em vez de popup do Telescope. `n`/`N` passam a acionar também `require("hlslens").start()` pra atualizar o contador de ocorrências.

- [x] **Step 1: Confirmar que incsearch/hlsearch já estão ligados**

Rode:

```bash
grep -n "incsearch\|hlsearch" nvim/lua/config/options.lua
```

Expected:
```
34:opt.hlsearch = true
35:opt.incsearch = true
```

Se por acaso estiver `false` em algum dos dois, troque pra `true` agora. (Na config atual, já é `true` — nenhuma mudança esperada aqui.)

- [x] **Step 2: Criar o plugin `nvim-hlslens`**

Crie `nvim/lua/plugins/hlslens.lua`:

```lua
-- nvim-hlslens: mostra um contador "3/12" (posição atual / total de
-- ocorrências) perto do cursor durante a navegação com n/N — é o que dá a
-- sensação de "barra de busca inline" do VSCode/Zed, sem precisar de popup.
return {
  "kevinhwang91/nvim-hlslens",
  event = "VeryLazy",
  config = function()
    require("hlslens").setup()
  end,
}
```

- [x] **Step 3: Rodar sync do lazy.nvim pra instalar o plugin novo**

Com o symlink do Setup em vigor, rode:

```bash
nvim --headless "+Lazy! sync" +qa
```

Expected: sem erro na saída; `kevinhwang91/nvim-hlslens` aparece instalado em `nvim --headless "+Lazy! sync" +qa` (ou verifique depois com `:Lazy` dentro do Neovim, procurando "nvim-hlslens" na lista).

> **Nota pós-execução:** o `Lazy! sync` desta task também bumpou, de forma
> colateral, o commit fixado do `nvim-lspconfig` (não relacionado a esta
> task) em `nvim/lazy-lock.json`. Corrigido revertendo só a linha do
> `nvim-lspconfig` no lock file e rodando `Lazy! restore` pra recolocar o
> plugin instalado em disco no commit fixado original, mantendo o
> `nvim-hlslens` novo intacto. Ver commit `1480c04`.

- [x] **Step 4: Trocar o mapeamento de `Cmd+F` em `keymaps.lua`**

Em `nvim/lua/config/keymaps.lua`, troque a linha (atualmente linha 73):

```lua
map("n", "<D-f>", ":Telescope current_buffer_fuzzy_find<CR>", { desc = "Buscar no arquivo atual (Cmd+F)" })
```

por:

```lua
map("n", "<D-f>", "/", { desc = "Buscar no arquivo atual, inline (Cmd+F)" })
```

- [x] **Step 5: Adicionar `n`/`N` com contador do hlslens e `Esc` pra limpar destaque**

Logo abaixo da linha do Step 4 (ainda em `keymaps.lua`), adicione:

```lua
-- n/N navegam pra próxima/anterior ocorrência da busca; o hlslens só
-- adiciona o contador "3/12" perto do cursor (o comportamento de navegação
-- em si já é nativo do Vim).
local hlslens_opts = { noremap = true, silent = true }
map("n", "n", [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], hlslens_opts)
map("n", "N", [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], hlslens_opts)

-- Esc limpa o destaque da busca atual (:noh), além do comportamento normal do Esc
map("n", "<Esc>", ":noh<CR>", { desc = "Limpar destaque de busca" })
```

- [x] **Step 6: Verificar sintaxe**

```bash
nvim --headless -u nvim/init.lua -c 'qa!'
```

Expected: sem saída de erro.

- [ ] **Step 7: Verificação manual da busca inline** (pendente — requer humano abrindo o Neovim interativamente; não é verificável em modo headless)

Abra um arquivo com texto repetido (ex: `nvim README.md`), aperte `Cmd+F`, digite uma palavra que apareça várias vezes (ex: `atalho`) e dê Enter. Confirme:
- Todas as ocorrências ficam destacadas no próprio texto (sem popup cobrindo nada).
- Um contador tipo "[3/12]" aparece perto do cursor.
- `n` avança pra próxima ocorrência, `N` volta, atualizando o contador.
- `Esc` limpa o destaque.
- `Cmd+Shift+F` (busca no projeto inteiro) continua abrindo o Telescope normalmente, sem regressão.

- [x] **Step 8: Atualizar a linha de `Cmd+F` no README (tabela + "Primeiros dias")**

Em `README.md`, na tabela `### Arquivos e projeto` (editada na Task 1), confirme/ajuste a linha pra:

```markdown
| `Cmd+F` | Buscar dentro do arquivo atual (inline: destaca no texto, `n`/`N` navega, `Esc` limpa) |
```

Na seção "Primeiros dias" (criada na Task 1), a linha de `Cmd+F` já existe — ajuste a descrição pra bater com a mesma redação:

```markdown
| `Cmd+F` | Buscar dentro do arquivo atual (`n`/`N` navega, `Esc` limpa) |
```

Logo abaixo da tabela `### Arquivos e projeto`, adicione uma nota curta diferenciando os dois tipos de busca (só se ainda não houver nenhuma nota ali):

```markdown
> `Cmd+F` busca só no arquivo aberto (inline, nativo do Vim). `Cmd+Shift+F`
> busca em todo o projeto (Telescope, abre um popup com os resultados). Use
> `Cmd+F` quando já sabe em que arquivo está o trecho; `Cmd+Shift+F` quando
> não sabe em qual arquivo procurar.
```

- [x] **Step 9: Atualizar `nvim/cheatsheet.txt`**

Na seção `## arquivos-e-projeto`, troque:

```
Buscar dentro do arquivo atual (Cmd+F) | :Telescope current_buffer_fuzzy_find
```

por:

```
Buscar dentro do arquivo atual, inline (Cmd+F, n/N navega, Esc limpa) | /
```

- [x] **Step 10: Salvar**

~~Sem commit (repo não é git) — arquivos já salvos pelo editor.~~ Nota:
o repo passou a ser git; commitado normalmente (`b850a8f` implementação +
`1480c04` correção do lock file). Ver
`.superpowers/sdd/task-3-report.md` para o relatório completo, incluindo
a verificação manual (Step 7) ainda pendente por um humano.

---

### Task 4: Trocar a sidebar de neo-tree pra snacks.nvim explorer

**Files:**
- Modify: `nvim/lua/plugins/ui.lua` (bloco do neo-tree → bloco do snacks.nvim, offset do bufferline)
- Modify: `nvim/lua/config/keymaps.lua` (remover mapeamento antigo de `Cmd+B`, que passa a viver dentro do plugin spec do snacks)
- Modify: `nvim/lua/plugins/colorscheme.lua` (integração `neotree` → `snacks`)
- Modify: `nvim/lua/plugins/alpha.lua` (comentário mencionando neo-tree)
- Modify: `nvim/lua/config/options.lua` (comentário de exemplo mencionando neo-tree)
- Modify: `README.md` (seção "Tema")
- Modify: `nvim/cheatsheet.txt` (comando de `:Neotree toggle` → novo comando)

**Interfaces:**
- Consome: nenhuma das outras tasks.
- Produz: `Snacks.explorer()` (função global exposta pelo plugin `folke/snacks.nvim` depois do `setup()`), usada pelo toggle de `Cmd+B` / `<leader>e`. Filetype do buffer do explorer: `"snacks_picker_list"` (usado no offset do bufferline).

- [x] **Step 1: Substituir o bloco do neo-tree em `ui.lua`**

Em `nvim/lua/plugins/ui.lua`, remova o bloco inteiro do `nvim-neo-tree/neo-tree.nvim` (da linha que começa em `-- Painel de arquivos lateral (árvore do projeto)...` até o fechamento `},` logo antes do bloco do which-key) e substitua por:

```lua
  -- Painel de arquivos lateral (explorer do snacks.nvim), igual ao painel
  -- esquerdo do Zed. Abre sozinho ao iniciar com `nvim <pasta>`
  -- (replace_netrw); Cmd+B / <leader>e alternam mostrar/esconder.
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      explorer = {
        replace_netrw = true, -- abre sozinho no lugar do netrw ao iniciar numa pasta
      },
    },
    keys = {
      { "<D-b>", toggle_explorer, desc = "Alternar painel de arquivos (Cmd+B)" },
      { "<leader>e", toggle_explorer, desc = "Alternar painel de arquivos" },
    },
  },
```

Note que `toggle_explorer` ainda não existe — vem no próximo step.

- [x] **Step 2: Definir a função `toggle_explorer` no topo do arquivo**

No topo de `nvim/lua/plugins/ui.lua`, logo antes de `return {`, adicione:

```lua
-- Fecha o painel do explorer se já estiver aberto (procurando a janela pelo
-- filetype que o snacks.nvim usa pros seus buffers de picker/explorer);
-- senão, abre. Dá o comportamento de "toggle" que Cmd+B e <leader>e esperam.
local function toggle_explorer()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "snacks_picker_list" then
      vim.api.nvim_win_close(win, true)
      return
    end
  end
  Snacks.explorer()
end
```

- [x] **Step 3: Atualizar o offset do bufferline**

Ainda em `nvim/lua/plugins/ui.lua`, no bloco `akinsho/bufferline.nvim`, troque:

```lua
          offsets = {
            {
              filetype = "neo-tree",
              text = "Explorador de arquivos",
              highlight = "Directory",
              separator = true,
            },
          },
```

por:

```lua
          offsets = {
            {
              filetype = "snacks_picker_list",
              text = "Explorador de arquivos",
              highlight = "Directory",
              separator = true,
            },
          },
```

- [x] **Step 4: Remover o mapeamento antigo de `Cmd+B` em `keymaps.lua`**

Em `nvim/lua/config/keymaps.lua`, remova estas duas linhas (o toggle de `Cmd+B` agora vive dentro do plugin spec do snacks, feito na Step 1):

```lua
-- Cmd+B esconde/mostra a árvore de arquivos lateral
map("n", "<D-b>", ":Neotree toggle<CR>", { desc = "Alternar árvore de arquivos (Cmd+B)" })
```

Também remova, perto do topo do arquivo, a linha de comentário:

```lua
-- Painel de arquivos (neo-tree), equivalente ao painel de projeto do Zed
map("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Alternar painel de arquivos" })
```

(Essa segunda linha também some — o `<leader>e` passa a ser definido dentro do plugin spec do snacks, junto com o `Cmd+B`, na mesma função `toggle_explorer`.)

Por fim, na linha de comentário do topo do arquivo (linha 2), troque:

```lua
-- Muitos desses atalhos só funcionam depois que os plugins carregarem (telescope, neo-tree etc.)
```

por:

```lua
-- Muitos desses atalhos só funcionam depois que os plugins carregarem (telescope, snacks etc.)
```

- [x] **Step 5: Atualizar a integração do catppuccin**

Em `nvim/lua/plugins/colorscheme.lua`, troque:

```lua
        neotree = true,
```

por:

```lua
        snacks = { enabled = true },
```

E no comentário do topo do arquivo (linhas 2-4), troque `neo-tree` por `snacks` na lista de integrações.

- [x] **Step 6: Atualizar o comentário do `alpha.lua`**

Em `nvim/lua/plugins/alpha.lua`, troque o comentário (linha 3-4):

```lua
-- em vez de uma tela em branco. Quando você abre uma pasta (`nvim .`), quem
-- assume a tela é o neo-tree (ver autocmd em ui.lua).
```

por:

```lua
-- em vez de uma tela em branco. Quando você abre uma pasta (`nvim .`), quem
-- assume a tela é o explorer do snacks.nvim (replace_netrw, ver ui.lua).
```

- [x] **Step 7: Atualizar o comentário de exemplo em `options.lua`**

Em `nvim/lua/config/options.lua`, no comentário sobre o título da janela (linhas 90-92), troque a menção ao neo-tree por um exemplo genérico:

```lua
-- Título da janela/aba do terminal: em vez do nome do buffer com foco (ex: o
-- estranho "neo-tree filesystem [1]" quando o cursor está no painel de
-- arquivos), sempre mostra o nome da pasta do projeto (cwd).
```

por:

```lua
-- Título da janela/aba do terminal: em vez do nome do buffer com foco (ex: o
-- nome interno do buffer do painel de arquivos lateral quando o cursor está
-- nele), sempre mostra o nome da pasta do projeto (cwd).
```

- [x] **Step 8: Rodar sync do lazy.nvim (instala snacks.nvim, remove neo-tree/nui)**

```bash
nvim --headless "+Lazy! sync" +qa
```

Expected: sem erro na saída. Depois, abra o Neovim e rode `:Lazy`, confirme que `snacks.nvim` está instalado e que `neo-tree.nvim` / `nui.nvim` não aparecem mais na lista (ou aparecem marcados como "not loaded"/removível — rode `:Lazy clean` se sobrar algo órfão).

> **Nota de execução:** rodado com `nvim --headless "+Lazy! install" +qa` seguido de
> `nvim --headless "+Lazy! clean" +qa` em vez de `Lazy! sync`, pra evitar o problema já
> visto na Task 3 (sync atualiza TODOS os plugins pro commit mais recente, não só
> instala/remove os do spec). Resultado: `snacks.nvim` clonado, `neo-tree.nvim` e
> `nui.nvim` removidos; `git diff nvim/lazy-lock.json` confirmou que nenhum outro plugin
> teve o commit alterado.

- [x] **Step 9: Verificar sintaxe**

```bash
nvim --headless -u nvim/init.lua -c 'qa!'
```

Expected: sem saída de erro. Confirmado: sem saída.

- [x] **Step 10: Verificação manual do explorer novo** (parcial — ver nota)

> **Nota de execução:** os itens 10.1-10.5 abaixo exigem visualizar a UI (icones, painel
> abrindo/fechando, jump horizontal, dashboard do alpha) e não podem ser confirmados por
> um agente headless. O que foi verificado sem interface: `Snacks` está definido e
> `Snacks.explorer()` executa sem erro Lua (via `pcall` numa sessão headless), e abrir o
> Neovim headless numa pasta ou sem argumento não produz mensagens de erro. **A
> verificação visual completa (10.1-10.5) continua pendente e precisa ser feita por um
> humano.**

1. Rode `nvim ~/Documents/DEV/nvim-config` (ou qualquer outra pasta) e confirme que o explorer abre sozinho, do lado esquerdo, com ícones de arquivo, indicadores de git e diagnóstico visíveis.
2. Aperte `Cmd+B` — o painel esconde. Aperte de novo — reabre.
3. Aperte `<leader>e` (space, depois e) — mesmo comportamento de toggle.
4. Abra um arquivo com nome longo dentro da árvore e confirme que o nome não faz a tela "pular" horizontalmente de forma estranha (se acontecer, é o mesmo problema que o `wrap` resolvia pro neo-tree — nesse caso, volte aqui e registre o achado antes de prosseguir, já que este plano não cobre um fix pra isso).
5. Rode `nvim` sem argumento nenhum — confirme que quem aparece é a tela do alpha (dashboard), não o explorer.

- [x] **Step 11: Atualizar a seção "Tema" do README**

Em `README.md`, na seção `## Tema`, troque a lista de integrações (linha que cita "neo-tree, cmp, telescope, which-key, gitsigns, bufferline, treesitter, LSP, Mason, indent-blankline") trocando `neo-tree` por `snacks` (o explorer de arquivos).

- [x] **Step 12: Atualizar `nvim/cheatsheet.txt`**

Na seção `## arquivos-e-projeto`, troque:

```
Mostrar/esconder árvore de arquivos (Cmd+B) | :Neotree toggle
```

por:

```
Mostrar/esconder árvore de arquivos (Cmd+B) | <D-b>
```

- [x] **Step 13: Salvar**

> **Nota de execução:** ao contrário do previsto aqui, o repo É git — commit criado
> normalmente (`4b6d15e`, "Trocar sidebar de neo-tree pra snacks.nvim explorer"), cobrindo
> os 8 arquivos do escopo (`README.md`, `nvim/cheatsheet.txt`, `nvim/lazy-lock.json`,
> `nvim/lua/config/keymaps.lua`, `nvim/lua/config/options.lua`, `nvim/lua/plugins/alpha.lua`,
> `nvim/lua/plugins/colorscheme.lua`, `nvim/lua/plugins/ui.lua`). Ver
> `.superpowers/sdd/task-4-report.md` para o relatório completo, incluindo a verificação
> manual (Step 10) ainda pendente por um humano, e uma referência solta a "neo-tree" fora
> do escopo (`nvim/lua/plugins/oil.lua:3`) encontrada mas não corrigida.

---

### Task 5 (opcional): `snacks.indent`, `snacks.dim` e `snacks.words`

Descoberto ao revisar https://codeberg.org/drawings_and_code/dotfiles como referência — três módulos do mesmo `folke/snacks.nvim` já instalado na Task 4, fora do design original, adicionados a pedido do usuário depois de ver as ideias.

- `snacks.indent` substitui o `indent-blankline.nvim` atual (guias verticais de indentação), com a guia do escopo atual destacada/animada.
- `snacks.dim` escurece o código fora do escopo atual (função/bloco), sob demanda via atalho (não fica ligado o tempo todo).
- `snacks.words` destaca automaticamente outras ocorrências do símbolo sob o cursor (via LSP document highlight), sem precisar apertar nada.

**Files:**
- Modify: `nvim/lua/plugins/ui.lua` (bloco do `folke/snacks.nvim`, criado/editado na Task 4)
- Delete: `nvim/lua/plugins/indent-blankline.lua`
- Modify: `nvim/lua/plugins/colorscheme.lua` (remover integração `indent_blankline`)
- Modify: `README.md` (seção "Tema" e tabela de atalhos)
- Modify: `nvim/cheatsheet.txt`

**Interfaces:**
- Consome: o bloco `folke/snacks.nvim` já existente em `ui.lua` (criado na Task 4).
- Produz: atalho `<leader>ud` pra ligar/desligar o dim.

**Depende da Task 4** (o bloco do `snacks.nvim` em `ui.lua` precisa existir antes de editar seus `opts`).

- [ ] **Step 1: Adicionar `indent`, `dim` e `words` aos `opts` do snacks.nvim**

Em `nvim/lua/plugins/ui.lua`, no bloco `folke/snacks.nvim` (criado na Task 4), troque:

```lua
    opts = {
      explorer = {
        replace_netrw = true, -- abre sozinho no lugar do netrw ao iniciar numa pasta
      },
    },
```

por:

```lua
    opts = {
      explorer = {
        replace_netrw = true, -- abre sozinho no lugar do netrw ao iniciar numa pasta
      },
      -- Guias de indentação (substitui o indent-blankline.nvim), com a guia
      -- do escopo/bloco atual destacada.
      indent = {},
      -- Escurece o código fora do escopo atual quando ligado; começa
      -- desligado, liga/desliga com <leader>ud (ver keymap abaixo).
      dim = {},
      -- Destaca automaticamente outras ocorrências do símbolo sob o cursor
      -- (via LSP document highlight), sem precisar apertar nada.
      words = {},
    },
```

- [ ] **Step 2: Adicionar o atalho de toggle do dim**

Ainda no mesmo bloco de `nvim/lua/plugins/ui.lua`, troque `opts = { ... }` sozinho (sem `config`) por um `config` que chama `setup` e registra o toggle. Troque:

```lua
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
```

por:

```lua
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    config = function(_, opts)
      require("snacks").setup(opts)
      -- Registra o atalho de liga/desliga do dim (usa o helper de toggle do
      -- próprio snacks, que também mostra a descrição no which-key).
      Snacks.toggle.dim():map("<leader>ud")
    end,
    opts = {
```

(O restante do bloco — `keys`, e o fechamento do `opts` — continua igual, só a linha `opts = {` ganha o `config` acima dela.)

- [ ] **Step 3: Remover o plugin `indent-blankline.nvim`**

Delete o arquivo `nvim/lua/plugins/indent-blankline.lua` inteiro (o `snacks.indent` do Step 1 assume essa função).

- [ ] **Step 4: Remover a integração `indent_blankline` do catppuccin**

Em `nvim/lua/plugins/colorscheme.lua`, remova a linha:

```lua
        indent_blankline = { enabled = true },
```

(A integração `snacks = { enabled = true }`, já adicionada na Task 4, cobre os grupos de destaque do `snacks.indent`/`snacks.dim`/`snacks.words` — não existe uma chave separada por módulo do snacks no catppuccin.)

No comentário do topo do mesmo arquivo (linhas 2-4), remova "indent-blankline" da lista de integrações.

- [ ] **Step 5: Rodar sync do lazy.nvim**

```bash
nvim --headless "+Lazy! sync" +qa
```

Expected: sem erro; `indent-blankline.nvim` deixa de aparecer na lista de plugins instalados (rode `:Lazy clean` dentro do Neovim se sobrar órfão).

- [ ] **Step 6: Verificar sintaxe**

```bash
nvim --headless -u nvim/init.lua -c 'qa!'
```

Expected: sem saída de erro.

- [ ] **Step 7: Verificação manual**

1. Abra um arquivo de código com blocos aninhados (ex: qualquer `.lua` deste próprio repo) e confirme que as guias de indentação aparecem, com a guia do bloco/escopo atual visualmente destacada.
2. Coloque o cursor em cima de uma variável usada várias vezes no arquivo e confirme que as outras ocorrências visíveis na tela ficam destacadas automaticamente, sem apertar nada.
3. Aperte `<leader>ud` — o código fora da função/bloco atual escurece. Aperte de novo — volta ao normal.

- [ ] **Step 8: Atualizar o README**

Na seção `## Tema`, troque "indent-blankline" por "indent/dim/words do snacks.nvim" na lista de integrações.

Na tabela `### Código (LSP)` (ou em "Primeiros dias", se fizer sentido mais adiante), adicione:

```markdown
| `space u d` | Ligar/desligar o "dim" (escurece código fora do escopo atual) |
```

- [ ] **Step 9: Atualizar `nvim/cheatsheet.txt`**

Na seção `## lsp-e-codigo`, adicione:

```
Ligar/desligar o dim (escurece fora do escopo atual) | <leader>ud
```

- [ ] **Step 10: Salvar**

Sem commit (repo não é git) — arquivos já salvos pelo editor.

---

## Ordem de execução

Tasks 1, 2 e 3 são independentes entre si. Task 4 é independente das anteriores. **Task 5 depende da Task 4** (edita o mesmo bloco `snacks.nvim` que a Task 4 cria). Ordem sugerida: 1 → 2 → 3 → 4 → 5.

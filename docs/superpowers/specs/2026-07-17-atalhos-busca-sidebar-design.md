# Design: reduzir confusão de atalhos, busca inline no arquivo, trocar sidebar

Data: 2026-07-17

## Contexto

A config já cobre bem TypeScript, Rust e Go (LSP via mason-lspconfig, format-on-save
via conform.nvim, testes via vim-test). Flutter/Dart fica fora de escopo por ora
(decisão do usuário: "esquece o flutter por enquanto").

O problema real reportado, nos primeiros dias de uso, é:

1. Mistura de dois estilos de atalho (`Cmd+...` estilo Zed/Mac e `<leader>...`
   estilo Vim) sem critério claro de quando usar qual.
2. Busca dentro do arquivo atual (`Cmd+F`) abre um popup do Telescope, mas o
   usuário quer uma busca inline (estilo VSCode/Zed): destaque no próprio
   texto, navegação com próximo/anterior, sem popup cobrindo o código.
3. A barra lateral de arquivos (neo-tree) tem visual "sem graça" comparado a
   outros editores/configs — o usuário quer trocar de plugin.

## 1. Referência única de atalhos

**Regra:** uma ação = um atalho documentado. Onde existe `Cmd+...`, essa é a
única entrada nas tabelas do README e no `cheatsheet.txt`. Onde não existe
`Cmd` (git, testes, terminal, diagnósticos, splits), `<leader>...` é a única
entrada. Não há mais colunas "atalho principal / alternativa" lado a lado.

- Nenhum keymap existente é removido de `keymaps.lua` — os duplicados (ex:
  `<leader>e` quando já existe `Cmd+B`) continuam funcionando, só saem da
  documentação principal. Ficam descobríveis via which-key (`space` e
  esperar) e `:Cheatsheet`, sem precisar ser memorizados.
- Novo bloco **"Primeiros dias"** no topo do README: lista curta (~12-15
  atalhos) cobrindo o essencial pra sobreviver na primeira semana — abrir
  arquivo, salvar, buscar (arquivo e projeto), git, terminal, testes,
  desfazer/refazer.
- `cheatsheet.txt` reorganizado com a mesma lógica de entrada única por ação,
  mantendo a estrutura de seções já existente (Arquivos, Abas, Edição, Código,
  Git, Testes, Terminal, Janelas).

## 2. Busca inline no arquivo (`Cmd+F`)

**Mudança de mapeamento:** `Cmd+F` deixa de abrir
`Telescope current_buffer_fuzzy_find` e passa a mapear para `/` (busca nativa
do Vim), aproveitando `incsearch` (destaca enquanto digita) e `hlsearch`
(mantém destaque após confirmar) — confirmar que ambas as opções estão
ligadas em `options.lua`, ligando se necessário.

**Novo plugin:** `kevinhwang91/nvim-hlslens` (`lua/plugins/hlslens.lua`) —
mostra um contador tipo "3/12" (posição atual / total de ocorrências) perto do
cursor durante a navegação. É o que dá a sensação de "barra de busca inline"
do VSCode/Zed sem precisar de popup.

- `n` / `N` navegam para a próxima/anterior ocorrência (nativo do Vim,
  hlslens só melhora o feedback visual).
- `Esc` limpa o destaque (`:noh`).
- `Cmd+Shift+F` (busca no projeto, via Telescope `live_grep`) não muda. README
  ganha uma nota explícita diferenciando os dois: `Cmd+F` = neste arquivo,
  `Cmd+Shift+F` = no projeto inteiro.

## 3. Sidebar: neo-tree → snacks.nvim explorer

**Troca de plugin:** remove o bloco `nvim-neo-tree/neo-tree.nvim` de
`lua/plugins/ui.lua` e adiciona `folke/snacks.nvim` com o módulo `explorer`
habilitado (ícones, status de git e diagnósticos integrados — mesma família
de plugins do which-key já usado nesta config, e o explorer que o LazyVim
adota atualmente).

- Mesmos atalhos continuam apontando pro explorer: `Cmd+B` e `<leader>e`.
- Mantém o comportamento de auto-abrir ao iniciar o Neovim apontando para uma
  pasta (`nvim .`), e não abrir quando iniciado sem argumento (fica com a
  tela do alpha-nvim).
- Ajusta o offset do `bufferline` (hoje reserva espaço checando
  `filetype == "neo-tree"`) para o filetype correto do snacks explorer.
- Remove a dependência `nvim-neo-tree/neo-tree.nvim`; `MunifTanjim/nui.nvim`
  só sai se nenhum outro plugin instalado depender dela (verificar antes de
  remover — não remover às cegas).

## Fora de escopo

- Suporte a Flutter/Dart (LSP, formatter, testes) — adiado a pedido do
  usuário.
- Qualquer mudança em Rust/Go/TypeScript LSP, formatação ou test runner —
  já estão satisfatórios.

## Testes / verificação manual

Como é config de editor, não há suíte automatizada. Verificação após a
implementação:

1. Abrir um projeto (`nvim .`) e conferir que o explorer novo abre sozinho,
   com ícones/git/diagnósticos visíveis, e que `Cmd+B` / `<leader>e`
   escondem/mostram.
2. Abrir um arquivo com texto repetido, apertar `Cmd+F`, digitar um termo,
   conferir destaque inline + contador do hlslens, navegar com `n`/`N`,
   limpar com `Esc`.
3. Conferir que `Cmd+Shift+F` (busca no projeto) continua funcionando via
   Telescope, sem regressão.
4. Ler o README do início ao fim como se fosse a primeira vez usando a
   config, conferindo que não há mais atalho duplicado nas tabelas.

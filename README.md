# Config de Neovim (estilo Zed, rodando no terminal)

Backup pessoal da minha configuração de Neovim, pensada pra rodar no
**terminal** (uso o [Ghostty](https://ghostty.org)) com uma experiência
parecida com a do Zed: árvore de arquivos, abas, busca fuzzy, LSP,
autocomplete, autopairs, Copilot, terminal integrado com fish, painel de git,
runner de testes etc.

## Instalar num Mac novo

```bash
git clone <onde-quer-que-voce-suba-isso> nvim-config
cd nvim-config
./install.sh
```

O script:
1. Instala via Homebrew: `neovim`, `fd`, `ripgrep`, `tree-sitter-cli`, `make`,
   `fish` e o terminal `ghostty` (cask).
2. Instala a fonte Iosevka Nerd Font (ícones da árvore/statusline), se nenhuma
   nerd font já estiver presente.
3. Instala o `typescript` globalmente via npm (necessário pro `ts_ls`
   funcionar em projetos sem `node_modules` local).
4. Copia a pasta `nvim/` deste repo para `~/.config/nvim` (fazendo backup do
   que já existir lá).
5. Roda a sincronização de plugins (lazy.nvim) e instala os language
   servers/formatters via Mason.

Depois de rodar, abra qualquer projeto com:

```bash
nvim ~/caminho/do/projeto
```

Se usar o GitHub Copilot, autentique uma vez dentro do Neovim com
`:Copilot auth` (só é necessário se este Mac ainda não tiver um token salvo em
`~/.config/github-copilot/`).

## O que tem aqui

- `nvim/` — cópia completa de `~/.config/nvim` (init.lua + lua/config +
  lua/plugins + cheatsheet.txt).
- `install.sh` — instalador para um Mac novo.

## Cheat sheet dentro do próprio Neovim

Além das tabelas abaixo, esta config tem uma cheat sheet **completa e
pesquisável** (atalhos, comandos e fluxos — não só teclas) via
[`cheatsheet.nvim`](https://github.com/sudormrfbin/cheatsheet.nvim), com
conteúdo em `nvim/cheatsheet.txt`. Abra com:

- `:Cheatsheet`
- `<leader>?`

(Sem atalho `Cmd`: em teclado ABNT, `Cmd+?` é fisicamente o mesmo combo que
`Cmd+/`, ver aviso na seção **Edição** abaixo.)

E busque por qualquer palavra (`git`, `teste`, `tema`, `lazy` etc.) — o
Telescope filtra em tempo real.

> Também dá pra apertar `space` sozinho e esperar ~1 segundo — o **which-key**
> mostra na tela todos os atalhos disponíveis a partir dali (agrupados por
> prefixo: Buscar, Git, Testes/Terminal, Diagnósticos, Buffers).

## Atalhos

`Leader` = barra de espaço. `Cmd` = tecla ⌘. Rodando no Ghostty (Neovim 0.12),
as teclas Cmd chegam normalmente ao Neovim via protocolo de teclado do Kitty —
não é mais um recurso exclusivo do Neovide.

### Primeiros dias

Antes de tentar decorar tudo, só isso já resolve 90% do dia a dia:

| Atalho | Ação |
|---|---|
| `Cmd+P` | Buscar arquivo pelo nome |
| `Cmd+Shift+F` | Buscar texto em todo o projeto |
| `Cmd+F` | Buscar dentro do arquivo atual (`n`/`N` navega, `Esc` limpa) |
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

### Arquivos e projeto
| Atalho | Ação |
|---|---|
| `Cmd+P` | Buscar arquivo pelo nome |
| `Cmd+F` | Buscar dentro do arquivo atual (inline: destaca no texto, `n`/`N` navega, `Esc` limpa) |
| `Cmd+Shift+F` | Buscar texto em todo o projeto |
| `Cmd+Shift+P` | Paleta de comandos |
| `Cmd+B` | Mostrar/esconder árvore de arquivos |
| `space f r` | Arquivos recentes |
| `space f b` | Buscar entre buffers abertos |
| `-` | Editar arquivos/pastas como texto (oil.nvim) |

> `Cmd+F` busca só no arquivo aberto (inline, nativo do Vim). `Cmd+Shift+F`
> busca em todo o projeto (Telescope, abre um popup com os resultados). Use
> `Cmd+F` quando já sabe em que arquivo está o trecho; `Cmd+Shift+F` quando
> não sabe em qual arquivo procurar.

### Abas / buffers
| Atalho | Ação |
|---|---|
| `Cmd+1`…`Cmd+9` | Ir direto para a aba N |
| `Shift+L` | Próximo buffer |
| `Shift+H` | Buffer anterior |
| `space b d` | Fechar buffer atual |

> `Cmd+W` fecha a aba/surface do **Ghostty** (não o buffer do Neovim) — pra
> fechar só o buffer, use `space b d`.

### Edição
| Atalho | Ação |
|---|---|
| `Cmd+/` (ou `space /` em teclado ABNT) | Comentar/descomentar linha ou seleção |
| `Cmd+S` | Salvar arquivo |
| `Cmd+Z` | Desfazer |
| `Cmd+Shift+Z` | Refazer |
| `Cmd+D` | Selecionar próxima ocorrência (multi-cursor) |
| `Option+↑` / `↓` | Mover linha (ou seleção) para cima/baixo |
| `Shift+Option+↓` | Duplicar linha (ou seleção) para baixo |
| `Cmd+]` / `Cmd+[` | Indentar / desindentar |
| `{` `(` `[` `"` `'` | Fecha automaticamente o par (nvim-autopairs) |

> **Teclado ABNT (Cmd+/ não funciona, abre a busca do menu Help):** em
> teclado brasileiro, digitar `/` já exige Shift, então `Cmd+/` é fisicamente
> o mesmo combo que `Cmd+Shift+/` (= `Cmd+?`) — e o macOS intercepta isso
> globalmente pra abrir a busca do menu **Help** de qualquer app (incluindo o
> Ghostty), antes mesmo de chegar no Neovim. Não dá pra corrigir só pelo
> config do Ghostty; o jeito é liberar esse atalho pro Ghostty em
> **Ajustes do Sistema → Teclado → Atalhos de Teclado → Atalhos de App**:
> adicione um atalho para o app **Ghostty**, título do menu **Search** (ou
> deixe em branco/outra tecla), sobrescrevendo o padrão do Help. Até lá, use
> `space /` — funciona sempre, independente de teclado.

### Código (LSP)
| Atalho | Ação |
|---|---|
| `gd` | Ir para definição |
| `gr` | Ver referências |
| `K` | Ver documentação (hover) |
| `space r n` | Renomear símbolo |
| `space c a` | Ações de código (code action) |
| `]d` / `[d` | Próximo / anterior diagnóstico |
| `space x x` | Lista de diagnósticos (Trouble) |
| `space u d` | Ligar/desligar o "dim" (escurece código fora do escopo atual) |

### Autocomplete (nvim-cmp)
| Atalho | Ação |
|---|---|
| `Tab` | Se houver sugestão fantasma do Copilot, aceita ela; senão navega pro próximo item do menu (ou salta snippet) |
| `Shift+Tab` | Item anterior do menu (ou salta snippet pra trás) |
| `Ctrl+N` / `Ctrl+P` | Navegar o menu do autocomplete explicitamente |
| `Enter` | Confirmar item selecionado |
| `Ctrl+Space` | Forçar abrir o menu de sugestões |
| `Ctrl+E` | Fechar o menu sem confirmar |

### Copilot
| Atalho | Ação |
|---|---|
| `Tab` | Aceitar sugestão fantasma inteira |
| `Ctrl+]` | Próxima sugestão alternativa |
| `Ctrl+[` | Sugestão alternativa anterior |
| `Ctrl+E` | Descartar sugestão atual |

### Git
| Atalho | Ação |
|---|---|
| `Cmd+Shift+G` | Abrir painel de git completo (Neogit) |
| `:Git` | Status de git estilo clássico (vim-fugitive) |
| `s` | Dentro do Neogit: dar stage no arquivo/hunk |
| `u` | Dentro do Neogit: tirar do stage |
| `x` | Dentro do Neogit: descartar mudanças do arquivo/hunk |
| `c` | Dentro do Neogit: abrir caixa de commit |
| `p` | Dentro do Neogit: push |

### Testes (vim-test)
| Atalho | Ação |
|---|---|
| `space t t` | Rodar o teste mais próximo do cursor |
| `space t f` | Rodar todos os testes do arquivo atual |
| `space t a` | Rodar a suíte de testes inteira |
| `space t l` | Repetir o último teste rodado |
| `space t v` | Ir para o arquivo de teste correspondente |

### Terminal
| Atalho | Ação |
|---|---|
| `space t` | Abrir/esconder terminal integrado (toggleterm) |
| `Esc` | Sair do modo de digitação (dentro do terminal) |
| digitar `exit` | Encerrar o shell e fechar o painel sozinho |

### Janelas / splits
| Atalho | Ação |
|---|---|
| `Ctrl+H`/`J`/`K`/`L` | Mover entre janelas (esquerda/baixo/cima/direita) |
| `space \|` | Split vertical (lado a lado) |
| `space -` | Split horizontal (em cima/embaixo) |
| `space q` | Fechar janela |

### Terminal (Ghostty)
| Atalho | Ação |
|---|---|
| `Cmd+=` / `Cmd+-` | Aumentar/diminuir fonte (nativo do Ghostty) |
| `Cmd+0` | Resetar zoom da fonte |
| `Cmd+W` | Fechar aba/surface do Ghostty |
| `Cmd+D` | Multi-cursor no Neovim (liberado no Ghostty; splits ficam em `Cmd+Shift+D`) |

## Tema

O tema é o **Catppuccin** (flavour `mocha`, escuro) — único colorscheme
instalado, com integração nativa em quase todos os plugins (snacks, cmp,
telescope, which-key, gitsigns, bufferline, treesitter, LSP, Mason,
indent/dim/words do snacks.nvim) e também nos ícones de arquivo (`nvim-web-devicons`).

Pra trocar de flavour (`latte`, `frappe`, `macchiato`, `mocha`):
```vim
:colorscheme catppuccin-latte
```

## Atualizar este backup depois de mexer na config

```bash
rsync -a --delete ~/.config/nvim/ ~/Documents/DEV/nvim-config/nvim/
```

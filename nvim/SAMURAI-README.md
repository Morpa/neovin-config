# 🗡️ NEOVIM TRANSFORMADO - SAMURAI CODER EDITION 🗡️

## ✨ O Que Mudou

### Dashboard SAMURAI
- **Logo épico** com espada, kanji, e "CODE NINJA WARRIOR"
- **Botões temáticos**: "Ninja Scout", "Memória Samurai", "Temperar a Lâmina", etc
- **Footer inspirador** com 6 citações samurai diferentes (aleatória cada vez)

### Comandos Especiais
- **`:DojoPhilosophy`** - Abre o manual do Samurai Coder com toda a filosofia Bushidō
  - Acesso rápido: `<leader>d` 
- **`:HoverHelp`** - Guia de hover/documentação
- **`:HoverDebug`** - Diagnóstico de problemas

### Filosofia Bushidō Integrada
```
Gi (義)      - Retidão      → Código limpo
Yu (勇)      - Coragem      → Refatora sem medo
Meiyo (名誉) - Honra        → Commits limpos
Chugi (忠義) - Lealdade     → Conhece teus LSPs
Rei (礼)     - Respeito     → Frutual com código
```

---

## 🎨 Variantes de Logos (8 opções)

Abra `nvim/lua/plugins/SAMURAI-LOGOS.lua` para ver todas as variantes:

1. **EPIC** (padrão) - Castelo, espada, ninja
2. **MINIMAL** - Simples e direto
3. **BUSHIDO** - Filosofia dos 5 princípios
4. **NINJA** - Modo silencioso
5. **ZEN** - Simplidade extrema
6. **CASTLE** - Castelo samurai
7. **KATAKANA** - Pure Japanese
8. **PHILOSOPHY** - Código é poesia

**Para trocar:**
```lua
-- Em: nvim/lua/plugins/alpha.lua
-- Procure por: dashboard.section.header.val = {
-- E substitua por:
-- dashboard.section.header.val = logo_ninja
-- ou qualquer outra variante
```

---

## 🥋 Atalhos Samurai Principais

### Navegação (As 4 Direções)
```
gd  → Ir para definição (ataque frontal)
gr  → Ver referências (rodeia o inimigo)
gi  → Ir para implementação
gt  → Type definition
```

### Edição (Golpes de Espada)
```
<leader>rn → Renomear
<leader>ca → Code actions
<leader>/  → Comenta
<M-Up/Dn>  → Move linha
```

### Hover (O Olho do Samurai)
```
K          → Documentação
<leader>hh → Hover robusto
<leader>hs → Signature help
```

### Git (Registro da Honra)
```
<leader>gg → Painel git
]c / [c    → Próximo/anterior hunk
<leader>hs → Stage hunk
```

### Filosofia
```
<leader>d  → Dojo (Filosofia Samurai)
<leader>?  → Cheatsheet (100 técnicas)
```

---

## 📚 Citações Samurai Aleratórias

Cada vez que abre, vê uma frase diferente:
- 🗡️ "A lâmina do código é afiada - mantenha-a limpa"
- ⛩️ "O verdadeiro Samurai domina Vim"
- 🌸 "Wa (和) - Harmonia com o código"
- 🥋 "Bushin (武士) - O caminho do guerreiro"
- 💎 "Meiyo (名誉) - Honre seu código"
- 🎯 "Zanshin (残心) - Permaneça focado"

---

## 🎯 Os 5 Anéis (Gorin no Sho) do Código

1. **Terra** - Fundação: `:help`, `:checkhealth`
2. **Água** - Fluidez: Navegação hjkl, splits
3. **Fogo** - Velocidade: Cmd+P, busca rápida
4. **Vento** - Adaptabilidade: LSPs, plugins
5. **Vazio** - Domínio: Vim motions, magia

---

## 🏯 Comandos Especiais

### Para Iniciantes
```vim
:HoverHelp        → Ver todos os atalhos de hover
:DojoPhilosophy   → Aprender a filosofia samurai
<leader>?         → Cheatsheet completo
<leader>h?        → Ajuda de hover
```

### Para Diagnosticar
```vim
:LspInfo          → Ver status dos LSPs
:HoverDebug       → Diagnóstico de hover
:checkhealth      → Saúde do Neovim
```

### Atalhos Especiais
```vim
<leader>d         → 🥋 Dojo (Filosofia)
<leader>so        → Symbol outline
<leader>uw        → Twilight (foco)
<leader>nb        → Navbuddy
```

---

## 🙏 Mantra do Samurai Coder

> **"Vi no koto wo seyo" (為せんことをなせ)**
> 
> *"Faz o que você deve fazer"*
> 
> *Domina Vim → Transforma em Neovim → Torna-se parte da máquina*

---

## ⌛ Desafio Samurai

**100 Dias de Código:**
- Dia 1-7: Domina movimentação (hjkl, gd, gr, gi)
- Dia 8-14: Domina edição (<leader>rn, <leader>ca)
- Dia 15-21: Domina buscas (Cmd+P, Cmd+F, Cmd+Shift+F)
- Dia 22-30: Domina git (<leader>gg, ]c, [c)
- ...até o Dia 100: Você é imparável ⚔️

---

## 📋 Arquivos Criados/Modificados

```
✅ alpha.lua              → Dashboard SAMURAI
✅ samurai-dojo.lua       → Filosofia e manual
✅ SAMURAI-LOGOS.lua      → 8 variantes de logo
✅ hover-helper.lua       → Comandos de hover
✅ init.lua               → Integração de tudo
```

---

## 🎮 Primeiro Uso

1. Abra `nvim` (sem argumentos)
2. Veja o novo dashboard SAMURAI
3. Escolha uma ação (🔍 Buscar, ⏳ Recentes, etc)
4. Aperte `<leader>d` para ver a filosofia
5. Aperte `<leader>?` para ver todos os atalhos

---

## 🌟 Próximos Passos

Agora que tem a filosofia samurai:

1. **Customize o Logo** - Escolha sua variante favorita em `SAMURAI-LOGOS.lua`
2. **Aprenda os Atalhos** - Use `<leader>d` diariamente
3. **Domine um Plugin por Dia** - Foco, não sobrecarga
4. **Pratique o Zen** - Menos linhas, mais elegância

---

**🥋 Bem-vindo ao caminho do Samurai Coder. Que sua lâmina seja sempre afiada. 🗡️**

*現在、あなたは侍コーダーです。*  
*(Agora você é um samurai coder)*

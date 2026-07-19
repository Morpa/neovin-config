# 📚 Guia Completo - Hover/Documentação Agora Funciona!

## ✅ O Que Foi Feito

Melhorei COMPLETAMENTE o sistema de hover/documentação:

### 1. **K (Hover Principal) - Agora Robusto**
- ✅ Tratamento de erros inteligente
- ✅ Verifica se LSP está ativo
- ✅ Mostra notificação se falhar
- ✅ Feedback visual melhor

### 2. **Múltiplas Alternativas**
Se `K` não funcionar, você tem várias opções:

```
PRIMARY:
  K              → Hover LSP (agora com tratamento de erro)
  <leader>hh     → Hover robusto (mais confiável)

SECONDARY:
  gK             → Hover via hover.nvim
  gH             → Hover com seletor de provider
  <C-k> (insert) → Signature help automático

EXTRA:
  <leader>hs     → Signature help (mostra parâmetros)
  <leader>hi     → Ir pra implementação
  <leader>ht     → Ir pra type definition
```

### 3. **Comandos de Diagnóstico**
Se `K` ainda não funcionar, use estes comandos:

```vim
:HoverHelp       → Mostra guia visual de atalhos
:HoverDebug      → Diagnostica por que K não funciona
:LspInfo         → Ver status de todos os LSPs
```

### 4. **Plugins Novos**
```lua
hover.nvim          → Múltiplos providers de hover
lsp_signature.nvim  → Signature help melhorado
```

---

## 🚀 Como Testar Agora

### Passo 1: Abrir um arquivo
```bash
nvim seu_arquivo.ts   # TypeScript
nvim seu_arquivo.py   # Python  
nvim seu_arquivo.go   # Go
nvim init.lua         # Lua
```

### Passo 2: Colocar Cursor Sobre uma Função
```typescript
// Coloca cursor aqui:
const result = Math.sqrt(16)
                ↑
                aperta K
```

### Passo 3: Ver Documentação
Você vai ver um popup com:
- 📖 Documentação da função
- 🔧 Tipo de retorno
- 📍 Parâmetros
- 💡 Exemplos (se houver)

### Se K não funcionar:
```
1. Espera 2 segundos (LSP demora pra iniciar)
2. Tenta <leader>hh (alternativa mais robusta)
3. Tenta :HoverDebug (diagnostica o problema)
4. Tenta :LspInfo (verifica se LSP está instalado)
```

---

## 🎯 Atalhos Rápidos (Cole no Which-Key)

```
<leader>h*:
  hh  → Hover/Documentação (PRIMARY - mais confiável)
  hs  → Signature help (parâmetros)
  hi  → Implementação
  ht  → Type definition
  h?  → Ajuda de hover (guia visual)
  hd  → Debug (diagnostica problema)
```

---

## 🔍 Diagnóstico Passo-a-Passo

### "Apertei K e não funciona"
```vim
:HoverDebug
```
Este comando vai mostrar:
- ✅ Se LSP está ativo
- ✅ Qual arquivo está aberto
- ✅ Qual tipo de arquivo é
- ✅ Sugestões de solução

### Exemplos de Output:
```
✅ LSP está rodando! Tenta:
  • K ou <leader>hh pra hover
  • gd pra ir pra definição
```
**Solução**: LSP tá ok, tenta `<leader>hh`

```
⚠️ Nenhum LSP ativo!
Sugestões:
• Espera 2-3 segundos (LSP demora pra iniciar)
• Tenta: :e (recarrega arquivo)
• Tenta: <leader>lm (Mason, instala LSP)
```
**Solução**: LSP não iniciou, espera ou instala

---

## 💡 Dicas Pro

### 1. **Scroll na Documentação**
```vim
K (abre hover)
<C-f>  → Scroll pra baixo
<C-b>  → Scroll pra cima
q      → Fecha
```

### 2. **Signature Help Automático**
Enquanto digita uma função:
```typescript
Math.sqrt(  ← Aparece signature help automaticamente
          ↑ Mostra parâmetros aqui
```

### 3. **Combina com Outros Atalhos**
```vim
gd (ir pra def) → K (ver docs) → gr (ver referências)
```

### 4. **Em Modo Insert**
```vim
Ctrl+K → Mostra assinatura enquanto digita
Ctrl+X Ctrl+D → Hover inline
```

---

## 🆘 Troubleshooting Avançado

### "Hover mostra HTML/Markdown estranho"
**Solução**: Tenta `gH` (seletor de provider)

### "Signature help não aparece"
**Solução**: `<C-x><C-s>` para toggle lsp_signature

### "LSP para de funcionar depois de um tempo"
**Solução**: `:e` (recarrega arquivo) ou `:LspRestart`

### "Instalei LSP mas não funciona"
**Solução**: 
```vim
:Mason          → Verifica se está instalado
:LspInfo        → Verifica se está ativo
:e              → Recarrega arquivo
```

---

## 📝 Resumo Final

| Cenário | Atalho | Fallback |
|---------|--------|----------|
| Ver docs | `K` | `<leader>hh` |
| Ver parâmetros | `<C-k>` (insert) | `<leader>hs` |
| Diagnosticar | `:HoverDebug` | `:LspInfo` |
| Ajuda | `<leader>h?` | `:HoverHelp` |

---

**🎉 Pronto! Agora você tem o melhor sistema de documentação do Neovim!**

Teste agora: `nvim init.lua` e aperta `K` sobre uma função Lua 😎

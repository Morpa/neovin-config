-- Cheatsheet customizado e helper commands pra hover/docs

local M = {}

M.setup = function()
  -- Comando pra mostrar info sobre LSP/Hover
  vim.api.nvim_create_user_command("HoverHelp", function()
    local lines = {
      "╔════════════════════════════════════════════════╗",
      "║  🎯 DOCUMENTAÇÃO / HOVER - GUIA RÁPIDO        ║",
      "╚════════════════════════════════════════════════╝",
      "",
      "PRIMARY (use estes sempre):",
      "  K              → Hover LSP (documentação)",
      "  <leader>hh     → Hover (alternativa robusta)",
      "  <leader>hs     → Signature help (parâmetros)",
      "",
      "SECONDARY (se primary não funcionar):",
      "  gK             → Hover (hover.nvim provider)",
      "  gH             → Hover (seletar provider)",
      "  <C-k> (insert) → Signature help (automático)",
      "",
      "INFORMAÇÕES:",
      "  <leader>hi     → Ir pra implementação",
      "  <leader>ht     → Ir pra type definition",
      "  :LspInfo       → Ver status do LSP",
      "  :set filetype? → Ver tipo de arquivo",
      "",
      "DIAGNOSTICAR PROBLEMAS:",
      "  • LSP não ativo?       → Espera 2s e tenta de novo",
      "  • K não funciona?      → Tenta <leader>hh",
      "  • Arquivo não reconhecido? → :e (recarrega)",
      "  • LSP não instalado?   → <leader>lm (Mason)",
      "",
      "🔧 Dica: Coloca cursor sobre função e aperta K",
    }
    
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(buf, "filetype", "help")
    
    -- Abre em split
    vim.cmd("new | b" .. buf)
    vim.cmd("set modifiable=false")
  end, {})

  -- Comando pra diagnosticar problema de Hover
  vim.api.nvim_create_user_command("HoverDebug", function()
    local clients = vim.lsp.get_active_clients({ bufnr = 0 })
    local ft = vim.bo.filetype
    local buf_name = vim.fn.bufname()
    
    local info = {
      "═══════════════════════════════════════",
      "DEBUG INFO - HOVER/LSP",
      "═══════════════════════════════════════",
      "Buffer: " .. buf_name,
      "File Type: " .. ft,
      "Active LSPs: " .. #clients,
    }
    
    if #clients > 0 then
      for i, client in ipairs(clients) do
        table.insert(info, "  [" .. i .. "] " .. client.name .. " (" .. client.id .. ")")
      end
    else
      table.insert(info, "  ⚠️  Nenhum LSP ativo!")
    end
    
    table.insert(info, "")
    table.insert(info, "Sugestões:")
    if #clients == 0 then
      table.insert(info, "• Espera 2-3 segundos (LSP demora pra iniciar)")
      table.insert(info, "• Tenta: :e (recarrega arquivo)")
      table.insert(info, "• Tenta: <leader>lm (Mason, instala LSP)")
    else
      table.insert(info, "✅ LSP está rodando! Tenta:")
      table.insert(info, "• K ou <leader>hh pra hover")
      table.insert(info, "• gd pra ir pra definição")
    end
    
    vim.notify(table.concat(info, "\n"), vim.log.levels.INFO)
  end, {})

  -- Atalho rápido pra diagnosticar
  vim.keymap.set("n", "<leader>hd", ":HoverDebug<CR>", { desc = "Debug hover (LSP status)" })
  vim.keymap.set("n", "<leader>h?", ":HoverHelp<CR>", { desc = "Ajuda hover/documentação" })
end

return M

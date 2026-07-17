-- GitHub Copilot: sugestão de código "fantasma" (ghost text) enquanto você digita,
-- igual ao Copilot no VSCode/Zed. Precisa de assinatura ativa do GitHub Copilot.
--
-- Depois de instalado, rode `:Copilot auth` uma vez dentro do Neovim — ele vai
-- mostrar um código e um link (github.com/login/device); abra o link, cole o
-- código e autorize. Isso só pode ser feito por você, manualmente.
return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
      -- accept = false: o Tab não é mapeado aqui, quem decide o que o Tab faz
      -- é o nvim-cmp (completion.lua) — se há sugestão fantasma do Copilot
      -- visível, Tab aceita ela; senão, Tab navega o menu do autocomplete.
      keymap = {
        accept = false,
        next = "<C-]>",     -- próxima sugestão alternativa
        prev = "<C-[>",     -- sugestão alternativa anterior
        dismiss = "<C-e>",  -- descarta a sugestão atual
      },
    },
    panel = { enabled = false }, -- usamos só o ghost text, não o painel lateral de múltiplas sugestões
  },
}

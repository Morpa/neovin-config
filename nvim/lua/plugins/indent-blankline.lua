-- Guias verticais de indentação (aquelas linhas finas mostrando os níveis de
-- indentação), facilita ver a que bloco cada linha pertence em código aninhado.
return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = { "BufReadPre", "BufNewFile" },
  opts = {},
}

-- vim-test: roda os testes do projeto de dentro do Neovim, sem precisar
-- decorar o comando de cada framework (jest, rspec, go test etc. — ele detecta
-- sozinho pelo tipo de arquivo). Usa a estratégia "neovim" (terminal embutido
-- nativo), então não depende de tmux/vimux.
return {
  "vim-test/vim-test",
  keys = {
    { "<leader>tt", ":TestNearest<CR>", desc = "Rodar teste mais próximo" },
    { "<leader>tf", ":TestFile<CR>", desc = "Rodar testes do arquivo" },
    { "<leader>ta", ":TestSuite<CR>", desc = "Rodar suíte de testes inteira" },
    { "<leader>tl", ":TestLast<CR>", desc = "Repetir o último teste" },
    { "<leader>tv", ":TestVisit<CR>", desc = "Ir para o arquivo de teste" },
  },
  init = function()
    vim.g["test#strategy"] = "neovim"
  end,
}

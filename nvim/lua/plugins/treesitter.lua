-- Treesitter: faz o Neovim entender a estrutura real do código (não só regex),
-- o que dá highlight muito mais preciso — perto do que o Zed entrega por padrão.
--
-- Usamos a branch "main" (a mantida ativamente) em vez da "master" (arquivada
-- há mais de um ano) porque a "master" não acompanha as mudanças internas do
-- Neovim recente e causava um erro de highlight ("attempt to call method
-- 'range'") ao editar arquivos.
local languages = {
  "typescript", "tsx", "javascript",
  "rust", "go", "gomod", "gowork",
  "lua", "json", "yaml", "markdown", "markdown_inline",
  "html", "css", "bash",
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  lazy = false,
  config = function()
    require("nvim-treesitter").setup()
    require("nvim-treesitter").install(languages)

    -- Liga o highlight baseado em treesitter para essas linguagens (a branch
    -- "main" não faz mais isso sozinha — precisa ser ligado por filetype)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = languages,
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })
  end,
}

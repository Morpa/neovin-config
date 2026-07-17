-- Multi-cursor: seleciona a próxima ocorrência de uma palavra e edita as duas ao mesmo tempo,
-- igual ao Cmd+D do Zed/VSCode.
return {
  "mg979/vim-visual-multi",
  branch = "master",
  event = "VeryLazy",
  init = function()
    -- precisa ser definido antes do plugin carregar; troca o padrão (Ctrl+N) por Cmd+D
    vim.g.VM_maps = {
      ["Find Under"] = "<D-d>",
      ["Find Subword Under"] = "<D-d>",
    }
  end,
}

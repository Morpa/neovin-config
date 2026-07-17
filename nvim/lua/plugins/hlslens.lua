-- nvim-hlslens: mostra um contador "3/12" (posição atual / total de
-- ocorrências) perto do cursor durante a navegação com n/N — é o que dá a
-- sensação de "barra de busca inline" do VSCode/Zed, sem precisar de popup.
return {
  "kevinhwang91/nvim-hlslens",
  event = "VeryLazy",
  config = function()
    require("hlslens").setup()
  end,
}

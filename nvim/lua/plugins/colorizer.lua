-- Colore o próprio texto de códigos de cor no arquivo (#ff0000, rgb(...), nomes
-- como "red") com a cor real, de fundo — útil em CSS/Tailwind e em qualquer lugar.
return {
  "catgoose/nvim-colorizer.lua",
  event = { "BufReadPre", "BufNewFile" },
  opts = {},
}

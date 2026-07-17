-- Terminal integrado dentro do editor, igual ao terminal embutido do Zed (Ctrl+`).
-- Suporta múltiplos terminais numerados, como abas de terminal (tipo tmux/Termux).
-- Resolve o caminho do fish via $PATH em vez de fixar "/opt/homebrew/bin/fish",
-- pra funcionar tanto em Mac Apple Silicon (/opt/homebrew) quanto Intel (/usr/local).
-- Se o fish não estiver instalado, cai de volta pro shell padrão do sistema.
local fish_path = vim.fn.exepath("fish")
if fish_path == "" then
  fish_path = vim.o.shell
end

return {
  "akinsho/toggleterm.nvim",
  version = "*",
  cmd = { "ToggleTerm", "TermSelect", "ToggleTermToggleAll" },
  keys = {
    { "<c-\\>", desc = "Alternar terminal (Ctrl+\\)" },
    { "<c-`>", ":ToggleTerm<CR>", desc = "Alternar terminal (Ctrl+`, igual ao Zed)" },
    -- alternativa com Cmd, caso o teclado seja ABNT2 (aí o "`" costuma ser tecla
    -- morta e o Ctrl+` acima pode não disparar)
    { "<D-j>", ":ToggleTerm<CR>", desc = "Alternar/esconder terminal 1 (Cmd+J)" },
    -- Cmd+Shift+J abre um terminal NOVO (numerado), sem fechar os que já existem —
    -- pra ter vários terminais em paralelo, como abas separadas de tmux/Termux
    {
      "<D-J>",
      function()
        local count = require("toggleterm.terminal").get_all(true)
        vim.cmd((#count + 1) .. "ToggleTerm")
      end,
      desc = "Abrir novo terminal (Cmd+Shift+J)",
    },
    -- Lista/escolhe entre os terminais abertos, como trocar de aba no tmux
    { "<leader>tl", ":TermSelect<CR>", desc = "Listar/trocar de terminal" },
  },
  opts = {
    open_mapping = [[<c-\>]],
    direction = "horizontal",
    size = 15,
    shell = fish_path, -- fixo no fish; vim.o.shell por padrão aponta pro /bin/zsh, não lê seu shell de login do macOS
    start_in_insert = true, -- entra digitando direto no shell (senão as teclas viram comandos do Vim)
    close_on_exit = true,
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)

    -- Reforço extra: garante que SEMPRE que um terminal ganha foco, o cursor
    -- entra digitando (modo terminal), nunca parado em modo Normal — usa
    -- vim.schedule pra rodar depois do redraw, evitando corrida de eventos.
    local function enter_insert()
      vim.schedule(function()
        if vim.bo.buftype == "terminal" then
          vim.cmd.startinsert()
        end
      end)
    end

    vim.api.nvim_create_autocmd("TermOpen", {
      pattern = "term://*",
      callback = function()
        vim.opt_local.number = false
        vim.opt_local.signcolumn = "no"
        enter_insert()
      end,
    })
    vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
      pattern = "term://*",
      callback = enter_insert,
    })

    -- Enquanto digita DENTRO do terminal (modo terminal), Esc sai pro modo
    -- Normal do terminal (padrão do Vim — precisa pra rolar a tela, copiar
    -- texto etc.). Apertando Cmd+J de novo a partir daí esconde o painel.
    vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Sair do modo de digitação do terminal" })
  end,
}

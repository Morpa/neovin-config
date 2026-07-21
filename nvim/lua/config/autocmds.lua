vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        local last_line = vim.api.nvim_buf_line_count(0)
        local last_content = vim.api.nvim_buf_get_lines(0, last_line - 1, last_line, false)[1]
        -- só insere se a última linha não estiver já vazia (evita acumular linhas em branco a cada save)
        if last_content ~= "" then
            vim.api.nvim_buf_set_lines(0, last_line, last_line, false, { "" })
        end
    end,
})


vim.o.updatetime = 300 -- ms até disparar CursorHold

vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
        local clients = vim.lsp.get_clients({ bufnr = 0, method = "textDocument/hover" })
        if #clients > 0 then
            -- Para mostrar sempre a documentacao
            -- vim.lsp.buf.hover()
        end
    end,
})

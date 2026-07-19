-- LSP (Language Server Protocol): dá ao Neovim autocomplete, "ir para definição",
-- renomear símbolo, mostrar erros em tempo real etc. — o mesmo motor que roda por
-- trás da inteligência de código do Zed.

-- Regista a extensão .templ antes de tudo, senão o Neovim abre esses
-- ficheiros como "text" e o LSP nunca ativa.
vim.filetype.add({
    extension = {
        templ = "templ",
    },
})

return {
    {
        "williamboman/mason.nvim",
        config = true, -- equivalente a require("mason").setup()
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "mason.nvim", "neovim/nvim-lspconfig" },
        opts = {
            -- Servidores instalados automaticamente pelo Mason na primeira vez.
            -- ts_ls = TypeScript/JavaScript, rust_analyzer = Rust, gopls = Go, lua_ls = config do próprio nvim.
            -- biome = lint/diagnostics do Biome (formatação fica por conta do conform.nvim)
            -- tailwindcss = autocomplete de classes + hover com o CSS gerado (só ativa em projetos com config do Tailwind)
            -- templ = LSP do a-h/templ (autocomplete, definição, formatação em ficheiros .templ)
            ensure_installed = { "ts_ls", "rust_analyzer", "gopls", "lua_ls", "biome", "tailwindcss", "templ" },
        },
    },
    {
        -- A partir do Neovim 0.11, a API nativa vim.lsp.config/vim.lsp.enable substitui
        -- o antigo require("lspconfig").<server>.setup{}. Ainda dependemos deste plugin
        -- só pelas configurações prontas de cada servidor que ele traz (lsp/*.lua).
        "neovim/nvim-lspconfig",
        dependencies = { "mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp" },
        config = function()
            -- cmp-nvim-lsp anuncia ao servidor que temos autocomplete "rico" disponível
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            vim.lsp.config("*", { capabilities = capabilities })
            -- Projetos pnpm (ex: monorepos) não fazem hoist de "typescript" pra
            -- raiz do node_modules, então o ts_ls falha com "Could not find a
            -- valid TypeScript installation" em arquivos fora de um pacote com
            -- typescript local (ex: scripts/ na raiz). Isso aponta pro tsserver.js
            -- instalado globalmente via npm como fallback quando não achar local.
            local global_tsserver = vim.fn.expand(
            "$HOME/.local/share/fnm/aliases/default/bin/../lib/node_modules/typescript/lib/tsserver.js")
            vim.lsp.config("ts_ls", {
                init_options = vim.fn.filereadable(global_tsserver) == 1 and {
                    tsserver = { path = global_tsserver },
                } or nil,
            })
            vim.lsp.enable({ "ts_ls", "rust_analyzer", "gopls", "lua_ls", "biome", "tailwindcss", "templ" })
            -- Atalhos que só existem quando um LSP está ativo no buffer atual
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(event)
                    local map = function(keys, fn, desc)
                        vim.keymap.set("n", keys, fn, { buffer = event.buf, desc = desc })
                    end
                    map("gd", vim.lsp.buf.definition, "Ir para definição")
                    map("gr", vim.lsp.buf.references, "Ver referências")
                    map("K", vim.lsp.buf.hover, "Ver documentação")
                    map("<leader>rn", vim.lsp.buf.rename, "Renomear símbolo")
                    map("<leader>ca", vim.lsp.buf.code_action, "Ações de código")
                end,
            })
        end,
    },
}

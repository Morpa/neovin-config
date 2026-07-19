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
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    {
        -- A partir do Neovim 0.11, a API nativa vim.lsp.config/vim.lsp.enable substitui
        -- o antigo require("lspconfig").<server>.setup{}. Ainda dependemos deste plugin
        -- só pelas configurações prontas de cada servidor que ele traz (lsp/*.lua).
        "neovim/nvim-lspconfig",
        dependencies = { "mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp", "folke/lazydev.nvim" },
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
            
            -- Habilita inlay hints (como VSCode mostra tipos e nomes de parâmetros)
            vim.lsp.inlay_hint.enable(true)
            
            -- Atalhos que só existem quando um LSP está ativo no buffer atual
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(event)
                    local map = function(keys, fn, desc)
                        vim.keymap.set("n", keys, fn, { buffer = event.buf, desc = desc })
                    end
                    local imap = function(keys, fn, desc)
                        vim.keymap.set("i", keys, fn, { buffer = event.buf, desc = desc })
                    end
                    
                    -- Navegação e informações
                    map("gd", vim.lsp.buf.definition, "Ir para definição")
                    map("gD", vim.lsp.buf.declaration, "Ir para declaração")
                    map("gi", vim.lsp.buf.implementation, "Ir para implementação")
                    map("gt", vim.lsp.buf.type_definition, "Ir para type definition")
                    map("gr", vim.lsp.buf.references, "Ver referências")
                    
                    -- Hover com múltiplas alternativas e melhor tratamento de erros
                    local function smart_hover()
                        local clients = vim.lsp.get_active_clients({ bufnr = event.buf })
                        if #clients == 0 then
                            return  -- Silencia se não tiver LSP (menos intrusivo)
                        end
                        vim.lsp.buf.hover()
                    end
                    
                    map("K", smart_hover, "Ver documentação (Hover LSP)")
                    map("<leader>hh", smart_hover, "Ver documentação")
                    map("<leader>H", function()
                        -- Alternativa: hover + seletor de provider (se usar hover.nvim)
                        if pcall(require, "hover") then
                            require("hover").hover_select()
                        else
                            smart_hover()
                        end
                    end, "Hover (seletar provider)")
                    imap("<C-k>", vim.lsp.buf.signature_help, "Ver assinatura")
                    
                    -- Refatoração e ações
                    map("<leader>rn", vim.lsp.buf.rename, "Renomear símbolo")
                    map("<leader>ca", vim.lsp.buf.code_action, "Ações de código")
                    map("<leader>cA", function()
                        vim.lsp.buf.code_action({
                            context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics() },
                            apply = true,
                        })
                    end, "Aplicar ação automática")
                    
                    -- Workspace symbols e formatting
                    map("<leader>ws", vim.lsp.buf.workspace_symbol, "Símbolos do workspace")
                    map("<leader>ds", vim.lsp.buf.document_symbol, "Símbolos do documento")
                    map("<leader>cf", vim.lsp.buf.format, "Formatar documento")
                    
                    -- Inlay hints toggle
                    map("<leader>ui", function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                    end, "Alternar inlay hints")
                    
                    -- Diagnósticos
                    map("<leader>xd", function()
                        vim.diagnostic.setloclist()
                    end, "Listar diagnósticos locais")
                end,
            })
        end,
    },
}

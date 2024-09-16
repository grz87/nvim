local lsp_servers = {
    "lua_ls",
    "jdtls",
    "pyright",
}

local lsp_configurations = {
    ["lua_ls"] = {
        settings = {
            Lua = {
                diagnostics = {
                    globals = {
                        'vim',
                    },
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                },
            },
        },
    },
}
require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = lsp_servers,
}

local cmp = require("cmp")
local lspconfig = require("lspconfig")

cmp.setup {
    snippet = {
        expand = function(args)
            require("luasnip").expand_snippet(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert {
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm { select = true },
    },
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { nanme = "nvim_lua" },
        { name = "luasnip" },

    }, {
        { name = "buffer" },
    })
}

cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = "buffer" }
    }
})

cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "path" }
    }, {
        { nname = "cmdline" }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

for _, server in pairs(lsp_servers) do
    if lsp_configurations[server] then
        lsp_configurations[server].capabilities = capabilities
        lspconfig[server].setup(lsp_configurations[server])
    else
        lspconfig[server].setup {
            capabilities = capabilities,
        }
    end
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp", { clear = true }),
    callback = function(args)
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = args.buf,
            callback = function()
                vim.lsp.buf.format { async = false, id = args.data.client_id }
            end,
        })
    end,
})

require("nvim-treesitter.configs").setup {
    ensure_installed = { "c", "lua", "python", "java" },
    sync_install = false,
    auto_install = true,
    highlight = { enable = true, },
    modules = {},
    ignore_install = {},
}

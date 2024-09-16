vim.g.have_nerd_font = true

vim.opt.number = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.cursorline = true

vim.opt.hlsearch = true

vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

vim.opt.termguicolors = true

vim.cmd [[ let mapleader = "\\" ]]

require("plugins")

require("neo-tree").setup()
vim.keymap.set("n", "<Leader>ft", "<cmd>Neotree toggle<cr>")

require("bufferline").setup {
    options = {
        diagnostics = "nvim_lsp",
    },
}

require("lualine").setup {
    options = {
        theme = "auto",
    },
}

require("config.themes")
require("config.lsp")

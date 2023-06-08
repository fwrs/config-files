-- settings
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.background = "light"
vim.opt.signcolumn = "yes"
vim.opt.backspace = "indent,eol,start"
vim.opt.clipboard:append("unnamedplus")
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.iskeyword:append("-")
vim.opt.showmode = false
vim.opt.shortmess:append("I")
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.list = false
vim.opt.listchars = "eol:↵,space:·,precedes:<,extends:>,tab:~ ,nbsp:␣"
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.linebreak = true
vim.opt.showbreak = string.rep(" ", 3)
vim.g.mapleader = " "
vim.g.rooter_silent_chdir = 1
vim.g.loaded_netrwPlugin = 0

-- keymaps
vim.keymap.set("n", "<leader>nh", "<cmd>nohl<cr>")
vim.keymap.set("n", "x", "\"_x")
vim.keymap.set("n", "<leader>l", "<cmd>set list!<cr>")
vim.keymap.set("n", "<leader>+", "<c-a>")
vim.keymap.set("n", "<leader>-", "<c-x>")
vim.keymap.set("n", "<leader>sv", "<c-w>v")
vim.keymap.set("n", "<leader>sh", "<c-w>s")
vim.keymap.set("n", "<leader>se", "<c-w>=")
vim.keymap.set("n", "<leader>sx", "<cmd>close<cr>")
vim.keymap.set("n", "<leader>to", "<cmd>tabnew<cr>")
vim.keymap.set("n", "<leader>tx", "<cmd>tabclose<cr>")
vim.keymap.set("n", "<leader>tn", "<cmd>tabn<cr>")
vim.keymap.set("n", "<leader>tp", "<cmd>tabp<cr>")
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope file_browser<cr>")
vim.keymap.set("n", "<leader><leader>", "<cmd>Telescope live_grep<cr>")
vim.keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>")
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")
vim.keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>")
vim.keymap.set("n", "<leader>gfc", "<cmd>Telescope git_bcommits<cr>")
vim.keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>")
vim.keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>")
vim.keymap.set("n", "<leader>rs", "<cmd>LspRestart<cr>")
vim.keymap.set("n", "<leader>ha", "<cmd>HopAnywhere<cr>")
vim.keymap.set("n", "<leader>hw", "<cmd>HopWord<cr>")

-- autocmds
vim.cmd.autocmd "InsertEnter * set norelativenumber"
vim.cmd.autocmd "InsertLeave * set relativenumber"
vim.cmd.autocmd "BufWritePre * %s/\\S\\@<=\\s\\+$//e"
vim.cmd.autocmd "BufReadPost,FileReadPost * lua vim.defer_fn(function() vim.cmd(\"redrawstatus!\") end, 100)"

-- lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", lazypath
    }
end
vim.opt.rtp:prepend(lazypath)

-- plugins
require("lazy").setup {
    { "nvim-lua/plenary.nvim" },
    { "nmac427/guess-indent.nvim", config = function()
        require("guess-indent").setup()
    end },
    { "airblade/vim-rooter" },
    { "navarasu/onedark.nvim", config = function()
        local o = require("onedark")
        o.setup { style = "light", transparent = true }
        o.load()
        vim.cmd "highlight! link CursorLineNr CursorLine"
        vim.cmd "highlight! link CursorLineSign CursorLine"
        vim.cmd "highlight! MiniStatuslineFilename guifg=#383A42"
    end },
    { "lewis6991/gitsigns.nvim", config = function()
        require("gitsigns").setup()
    end },
    { "powerman/vim-plugin-AnsiEsc" },
    { "vim-scripts/ReplaceWithRegister" },
    { "tpope/vim-surround" },
    { "tpope/vim-fugitive" },
    { "numToStr/Comment.nvim", config = function()
        require("Comment").setup()
    end },
    { "windwp/nvim-autopairs", config = function()
        require("nvim-autopairs").setup { check_ts = true }
    end },
    { "windwp/nvim-ts-autotag" },
    { "nvim-treesitter/nvim-treesitter", config = function()
        require("nvim-treesitter.configs").setup {
            highlight = { enable = true },
            indent = { enable = true },
            autotag = { enable = true },
            ensure_installed = { "c", "vim", "vimdoc", "query",
                                 "swift", "typescript", "javascript",
                                 "json", "gitignore", "tsx", "yaml",
                                 "html", "css", "ruby" },
            auto_install = true
        }
    end },
    { "nvim-telescope/telescope-file-browser.nvim" },
    { "nvim-telescope/telescope.nvim", config = function()
        require("telescope").setup {
            pickers = { find_files = { disable_devicons = true } },
            extensions = { file_browser = { disable_devicons = true, hijack_netrw = true } }
        }
        require("telescope").load_extension "file_browser"
    end },
    { "echasnovski/mini.statusline", config = function()
        require("mini.statusline").setup { use_icons = false }
    end },
    { "L3MON4D3/LuaSnip" },
    { "saadparwaiz1/cmp_luasnip" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/nvim-cmp", config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        cmp.setup {
            snippet = { expand = function(args)
                luasnip.lsp_expand(args.body)
            end },
            mapping = cmp.mapping.preset.insert {
                ["<c-k>"] = cmp.mapping.select_prev_item(),
                ["<c-j>"] = cmp.mapping.select_next_item(),
                ["<c-b>"] = cmp.mapping.scroll_docs(-4),
                ["<c-f>"] = cmp.mapping.scroll_docs(4),
                ["<c-space>"] = cmp.mapping.complete(),
                ["<c-e>"] = cmp.mapping.abort(),
                ["<cr>"] = cmp.mapping.confirm { select = false }
            },
            sources = cmp.config.sources {
                { name = "nvim_lsp" },
                { name = "buffer" },
                { name = "path" }
            }
        }
    end },
    { "williamboman/mason.nvim", config = function()
        require("mason").setup()
    end },
    { "williamboman/mason-lspconfig.nvim", config = function()
        require("mason-lspconfig").setup {
            ensure_installed = { "tsserver" },
            automatic_installation = true
        }
    end },
    { "neovim/nvim-lspconfig", config = function()
        local lspconfig = require("lspconfig")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")
        local on_attach = function(client, bufnr)
            local opts = { noremap = true, silent = true, buffer = bufnr }
            vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<cr>", opts)
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
            vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>", opts)
            vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<cr>", opts)
            vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<cr>", opts)
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
            vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
            vim.keymap.set("n", "<leader>rn", "<cmd>IncRename ", opts)
            vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<cr>", opts)
            vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
            vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
            vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        end
        local capabilities = cmp_nvim_lsp.default_capabilities()
        local signs = { Error = "❌", Warn = "⚠️", Hint = "💬", Info = "ℹ️" }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        end
        local default_config = {
            capabilities = capabilities,
            on_attach = on_attach,
            single_file_support = true
        }
        lspconfig["tsserver"].setup(default_config)
        lspconfig["sourcekit"].setup(default_config)
    end },
    { "lukas-reineke/indent-blankline.nvim", config = function()
        require("indent_blankline").setup {
            show_current_context = true,
            show_current_context_start = true
        }
    end },
    { "norcalli/nvim-colorizer.lua", config = function()
        require("colorizer").setup()
    end },
    { "folke/which-key.nvim", config = function()
        require("which-key").setup { icons = { separator = ":" } }
    end },
    { "phaazon/hop.nvim", config = function()
        require("hop").setup()
    end }
}

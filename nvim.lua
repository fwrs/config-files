-- settings

vim.g.mapleader = " "
vim.g.editorconfig = false
vim.g.loaded_netrwPlugin = 0
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.iskeyword:append("-")
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.clipboard:append("unnamedplus")
vim.opt.shell = vim.fn.exepath("fish")
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.colorcolumn = "121"
vim.opt.breakindent = true
vim.opt.linebreak = true
vim.opt.showbreak = "   "
vim.opt.smoothscroll = true
vim.opt.listchars = { eol = "↵", space = "·", precedes = "<", extends = ">", tab = "~ ", nbsp = "␣" }
vim.opt.showmode = false
vim.opt.shortmess:append("I")
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.foldlevelstart = 0x7fffffff
vim.filetype.add { extension = { metal = "cpp" } }
vim.diagnostic.config { virtual_text = true }

-- keymaps

vim.keymap.set("n", "x", "\"_x")
vim.keymap.set({ "n", "x" }, "<leader>+", "<c-a>")
vim.keymap.set({ "n", "x" }, "<leader>-", "<c-x>")
vim.keymap.set({ "x", "o" }, "i/", ":<c-u>normal! T/vt/<cr>", { silent = true })
vim.keymap.set({ "x", "o" }, "a/", ":<c-u>normal! F/vf/<cr>", { silent = true })
vim.keymap.set("n", "<leader>n", "<cmd>nohl<cr>")
vim.keymap.set("n", "<leader>l", "<cmd>set list!<cr>")
vim.keymap.set("n", "<leader>sv", "<c-w>v")
vim.keymap.set("n", "<leader>sh", "<c-w>s")
vim.keymap.set("n", "<leader>se", "<c-w>=")
vim.keymap.set("n", "<leader>sx", "<c-w>c")
vim.keymap.set("n", "<leader>to", "<cmd>tabnew<cr>")
vim.keymap.set("n", "<leader>tx", "<cmd>tabclose<cr>")
vim.keymap.set("n", "<leader>tn", "<cmd>tabn<cr>")
vim.keymap.set("n", "<leader>tp", "<cmd>tabp<cr>")
vim.keymap.set("n", "<leader>cp", "<cmd>let @+=expand(\"%:p\")<cr>")

-- autocmds

vim.cmd.autocmd("InsertEnter * let w:relativenumber = &l:relativenumber | setlocal norelativenumber")
vim.cmd.autocmd("InsertLeave * let &l:relativenumber = get(w:, \"relativenumber\", &l:relativenumber)")
vim.cmd.autocmd("TextYankPost * lua vim.hl.on_yank()")
vim.cmd.autocmd("BufWritePre * let w:view = winsaveview() | keeppatterns %s/\\S\\@<=\\s\\+$//e | call winrestview(w:view)")
vim.cmd.autocmd("TermOpen * startinsert")

-- lazy

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath }
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- plugins

require("lazy").setup {
    {
        "navarasu/onedark.nvim",
        opts = {
            transparent = true,
            highlights = {
                CursorLine = { bg = "$diff_change" },
                CursorLineNr = { bg = "$diff_change" },
                CursorLineSign = { bg = "$diff_change" },
                Visual = { bg = "$diff_text" },
                ColorColumn = { bg = "$bg0" },
                MiniStatuslineFilename = { fg = "$fg" },
                TreesitterContextLineNumber = { fg = "$fg", bg = "$bg1" },
            },
        },
        config = function(_, opts)
            require("onedark").setup(opts)
            require("onedark").load()
        end,
    },
    { "nvim-mini/mini.statusline", config = true },
    {
        "lukas-reineke/indent-blankline.nvim",
        event = "VeryLazy",
        main = "ibl",
        opts = { scope = { show_start = false, show_end = false } },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        build = ":TSUpdate",
        config = function()
            vim.opt.foldmethod = "expr"
            vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            local treesitter = require("nvim-treesitter")
            local pending = {}
            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    local lang = vim.treesitter.language.get_lang(args.match)
                    if vim.list_contains(treesitter.get_available(), lang) then
                        local start = function()
                            if pcall(vim.treesitter.start, args.buf, lang) then
                                vim.bo[args.buf].indentexpr = "luaeval(\"require(\\\"nvim-treesitter\\\").indentexpr()\")"
                            end
                        end
                        if vim.list_contains(treesitter.get_installed("parsers"), lang)
                            and vim.list_contains(treesitter.get_installed("queries"), lang) then
                            start()
                        else
                            pending[lang] = pending[lang] or ts.install(lang, { force = true })
                            pending[lang]:await(vim.schedule_wrap(function()
                                pending[lang] = nil
                                start()
                            end))
                        end
                    end
                end,
            })
            vim.api.nvim_create_autocmd("VimLeavePre", {
                callback = function()
                    if next(pending) == nil then return end
                    for _, task in pairs(pending) do task:pwait() end
                end,
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        event = "VeryLazy",
        opts = { select = { lookahead = true } },
        config = function(_, opts)
            require("nvim-treesitter-textobjects").setup(opts)
            local select = require("nvim-treesitter-textobjects.select").select_textobject
            local move = require("nvim-treesitter-textobjects.move")
            for key, name in pairs { c = "class", f = "function", b = "block", a = "parameter", ["="] = "assignment" } do
                vim.keymap.set({ "x", "o" }, "a" .. key, function() select("@" .. name .. ".outer", "textobjects") end)
                vim.keymap.set({ "x", "o" }, "i" .. key, function() select("@" .. name .. ".inner", "textobjects") end)
            end
            for key, query in pairs { C = "@class.outer", f = "@function.outer", b = "@block.outer", a = "@parameter.inner" } do
                vim.keymap.set({ "n", "x", "o" }, "]" .. key, function() move.goto_next_start(query, "textobjects") end)
                vim.keymap.set({ "n", "x", "o" }, "[" .. key, function() move.goto_previous_start(query, "textobjects") end)
                if key ~= key:upper() then
                    vim.keymap.set({ "n", "x", "o" }, "]" .. key:upper(), function() move.goto_next_end(query, "textobjects") end)
                    vim.keymap.set({ "n", "x", "o" }, "[" .. key:upper(), function() move.goto_previous_end(query, "textobjects") end)
                end
            end
        end,
    },
    { "nvim-treesitter/nvim-treesitter-context", event = { "BufReadPre", "BufNewFile" }, opts = { mode = "topline" } },
    { "windwp/nvim-ts-autotag", event = { "BufReadPre", "BufNewFile" }, config = true },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            vim.lsp.config("*", { capabilities = require("mini.completion").get_lsp_capabilities() })
            vim.lsp.enable { "tsc", "sourcekit", "rust_analyzer", "bashls" }
            if vim.fn.executable("vscode-eslint-language-server") == 1 then vim.lsp.enable("eslint") end
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
            vim.keymap.set({ "n", "x" }, "<leader>fmt", vim.lsp.buf.format)
            vim.keymap.set("n", "<leader>hnt", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end)
            vim.keymap.set("n", "<leader>rs", "<cmd>lsp restart<cr>")
        end,
    },
    {
        "nvim-mini/mini.completion",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            fallback_action = function()
                if vim.bo.filetype ~= "markdown" then return end
                local path = vim.api.nvim_get_current_line():sub(1, vim.fn.col(".") - 1):match("/%S*$")
                vim.api.nvim_feedkeys(vim.keycode(path and "<c-g><c-g><c-x><c-f>" or "<c-n>"), "n", false)
            end,
        },
    },
    { "nmac427/guess-indent.nvim", event = { "BufReadPre", "BufNewFile" }, config = true },
    { "nvim-mini/mini.pairs", event = "InsertEnter", config = true },
    { "nvim-mini/mini.surround", event = "VeryLazy", config = true },
    { "bkad/CamelCaseMotion", event = "VeryLazy", init = function() vim.g.camelcasemotion_key = "," end },
    {
        "nvim-mini/mini.jump2d",
        event = "VeryLazy",
        opts = { mappings = { start_jumping = "<leader>ha" } },
        config = function(_, opts)
            local jump2d = require("mini.jump2d")
            jump2d.setup(opts)
            vim.keymap.set({ "n", "x", "o" }, "<leader>hw", function() jump2d.start(jump2d.builtin_opts.word_start) end)
            vim.keymap.set({ "n", "x", "o" }, "<leader>hs", function() jump2d.start(jump2d.builtin_opts.single_character) end)
        end,
    },
    { "nvim-mini/mini.misc", config = function() require("mini.misc").setup_auto_root() end },
    {
        "nvim-mini/mini.pick",
        dependencies = { "nvim-mini/mini.extra" },
        event = "VeryLazy",
        config = function()
            require("mini.pick").setup()
            require("mini.extra").setup()
            vim.keymap.set("n", "<leader>ff", "<cmd>Pick files<cr>")
            vim.keymap.set("n", "<leader><leader>", "<cmd>Pick grep_live<cr>")
            vim.keymap.set("n", "<leader>fc", "<cmd>Pick grep pattern=\"<cword>\"<cr>")
            vim.keymap.set("n", "<leader>fb", "<cmd>Pick buffers<cr>")
            vim.keymap.set("n", "<leader>ba", "<cmd>Pick explorer<cr>")
            vim.keymap.set("n", "<leader>bc", "<cmd>Pick explorer cwd=\"%:p:h\"<cr>")
            vim.keymap.set("n", "<leader>fh", "<cmd>Pick help<cr>")
            vim.keymap.set("n", "<leader>gs", "<cmd>Pick git_files scope=\"modified\"<cr>")
            vim.keymap.set("n", "<leader>gb", "<cmd>Pick git_branches<cr>")
            vim.keymap.set("n", "<leader>gc", "<cmd>Pick git_commits<cr>")
            vim.keymap.set("n", "<leader>gfc", "<cmd>Pick git_commits path=\"%\"<cr>")
            vim.keymap.set("n", "gd", "<cmd>Pick lsp scope=\"definition\"<cr>")
            vim.keymap.set("n", "grr", "<cmd>Pick lsp scope=\"references\"<cr>")
            vim.keymap.set("n", "gri", "<cmd>Pick lsp scope=\"implementation\"<cr>")
            vim.keymap.set("n", "grt", "<cmd>Pick lsp scope=\"type_definition\"<cr>")
            vim.keymap.set("n", "<leader>D", "<cmd>Pick diagnostic scope=\"current\"<cr>")
        end,
    },
    { "nvim-mini/mini.diff", event = "VeryLazy", opts = { view = { style = "sign" } } },
    {
        "tpope/vim-fugitive",
        config = function()
            vim.cmd.autocmd("User FugitiveIndex,FugitiveObject nmap <buffer> <silent> g; :<c-u>Git pull origin <c-r>=substitute(expand(\"<cWORD>\"), \"^origin/\", \"\", \"\")<cr><cr>")
            vim.cmd.command("-bar -bang W w | Gwrite<bang>")
            vim.cmd.command("-bar Gl G ++curwin log --graph --oneline --decorate --pretty=format:\"%h -%d %s (%cr) <%an>\"")
        end,
    },
    {
        "rbong/vim-flog",
        cmd = { "Flog", "Flogsplit", "Floggit" },
        init = function()
            vim.g.flog_enable_extended_chars = 1
            vim.g.flog_enable_dynamic_branch_hl = 1
            vim.g.flog_enable_dynamic_commit_hl = 1
            vim.g.flog_permanent_default_opts = { date = "relative-local" }
        end,
    },
    { "folke/which-key.nvim", event = "VeryLazy", opts = { preset = "helix", icons = { mappings = false } } },
    { "folke/snacks.nvim", opts = { image = { enabled = true } } },
    { "powerman/vim-plugin-AnsiEsc", cmd = "AnsiEsc" },
}

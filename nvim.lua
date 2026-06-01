-- settings
require('vim._core.ui2').enable {}
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
vim.opt.clipboard:append("unnamedplus")
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.iskeyword:append("-")
vim.opt.showmode = false
vim.opt.shortmess:append("I")
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.list = false
vim.opt.listchars = "eol:↵,space:·,precedes:<,extends:>,tab:~ ,nbsp:␣"
vim.opt.fillchars = "eob: "
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.linebreak = true
vim.opt.showbreak = string.rep(" ", 3)
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = math.maxinteger
vim.opt.foldlevelstart = math.maxinteger
vim.opt.foldenable = false
vim.opt.shell = "/opt/homebrew/bin/fish"
vim.g.editorconfig = false
vim.g.mapleader = " "
vim.g.rooter_silent_chdir = 1
vim.g.loaded_netrwPlugin = 0
vim.g.flog_enable_extended_chars = 1
vim.g.flog_enable_dynamic_branch_hl = 1
vim.g.flog_enable_dynamic_commit_hl = 1
vim.g.flog_permanent_default_opts = { date = "relative-local" }
vim.g.camelcasemotion_key = ","
vim.filetype.add { extension = { metal = "cpp" } }

-- keymaps
vim.keymap.set("n", "<leader>n", "<cmd>nohl<cr>")
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
vim.keymap.set("n", "<leader><leader>", "<cmd>Telescope live_grep<cr>")
vim.keymap.set("n", "<leader>ba", "<cmd>Telescope file_browser hidden=true<cr>")
vim.keymap.set("n", "<leader>bc", "<cmd>Telescope file_browser path=%:p:h select_buffer=true hidden=true<cr>")
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files hidden=true<cr>")
vim.keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>")
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")
vim.keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>")
vim.keymap.set("n", "<leader>gfc", "<cmd>Telescope git_bcommits<cr>")
vim.keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>")
vim.keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>")
vim.keymap.set("n", "<leader>rs", "<cmd>LspRestart<cr>")
vim.keymap.set("n", "<leader>cp", "<cmd>let @+=expand(\"%:p\")<cr>")
vim.keymap.set("", "<leader>ha", "<cmd>HopAnywhere<cr>")
vim.keymap.set("", "<leader>hw", "<cmd>HopWord<cr>")
vim.keymap.set("", "<leader>hs", "<cmd>HopChar1<cr>")
vim.keymap.set({ "x", "o" }, "i/", ":<c-u>normal! T/vt/<cr>", { silent = true })
vim.keymap.set({ "x", "o" }, "a/", ":<c-u>normal! F/vf/<cr>", { silent = true })

-- nvim 0.10 broke replacewithregister, very cool
for _, mode in ipairs { "n", "v" } do
    for _, lhs in ipairs { "gra", "gri", "grn", "grr", "grt" } do
        pcall(vim.keymap.del, mode, lhs)
    end
end

-- autocmds
vim.cmd.autocmd("InsertEnter * set norelativenumber")
vim.cmd.autocmd("InsertLeave * set relativenumber")
vim.cmd.autocmd("TermOpen * setlocal nonumber norelativenumber | startinsert")
vim.cmd.autocmd("BufWritePre * %s/\\S\\@<=\\s\\+$//e")
vim.cmd.autocmd("BufReadPost,FileReadPost * lua vim.defer_fn(function() vim.cmd(\"redrawstatus! | normal zR\") end, 200)")
vim.cmd.autocmd("User FugitiveIndex,FugitiveObject nmap <buffer> <silent> g; :<c-u>Git pull origin <c-r>=substitute(expand(\"<cWORD>\"), \"^origin/\", \"\", \"\")<cr><cr>")

-- cmds
vim.cmd.command("-bar Gl G ++curwin log --graph --oneline --decorate --pretty=format:\"%h -%d %s (%cr) <%an>\"")

-- my giga cursed colorcolumn replacement
local custom_colorcolumn_ns = vim.api.nvim_create_namespace("custom_colorcolumn")
local colorcolumn_start = 120
local attached_bufs = {}
vim.api.nvim_set_decoration_provider(custom_colorcolumn_ns, {
    on_win = function(_, win, buf, top, bottom)
        local line_count = vim.api.nvim_buf_line_count(buf)
        if vim.bo[buf].bt ~= "" or line_count == 0 then return end
        if not attached_bufs[buf] then
            attached_bufs[buf] = true
            vim.api.nvim_buf_attach(buf, false, {
                on_lines = function(_, buf)
                    local line_count = vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].bt == "" and
                        vim.api.nvim_buf_line_count(buf) or 0
                    if line_count > 0 then
                        vim.api.nvim_buf_set_extmark(buf, custom_colorcolumn_ns, line_count - 1, 0, {
                            id = 1,
                            virt_lines = { { { " ", "Normal" } } },
                            priority = 1,
                        })
                    end
                end,
                on_detach = function(_, buf) attached_bufs[buf] = nil end,
            })
        end
        vim.api.nvim_buf_clear_namespace(buf, custom_colorcolumn_ns, top, bottom + 1)
        local cur = vim.api.nvim_win_get_cursor(win)[1] - 1
        local vis = vim.fn.mode():find("[vV\22sS\19]")
        local win_width = vim.api.nvim_win_get_width(win)
        local fill_str = (" "):rep(win_width)
        local wrap = vim.wo[win].wrap
        local textoff = wrap and (vim.fn.getwininfo(win)[1] or {}).textoff or 0
        local text_width = win_width - textoff
        vim.iter(vim.api.nvim_buf_get_lines(buf, top, bottom + 1, false)):enumerate():each(
            function(index, line_content)
                local line, line_width = top + index - 1, vim.fn.strdisplaywidth(line_content)
                if line == cur and not vis then return end
                if line_width > colorcolumn_start then
                    local raw_start_byte = vim.fn.virtcol2col(win, line + 1, colorcolumn_start + 1) - 1
                    local start_byte = math.max(0, math.min(raw_start_byte, #line_content))
                    vim.api.nvim_buf_set_extmark(buf, custom_colorcolumn_ns, line, start_byte, {
                        end_col = #line_content,
                        hl_group = "ColorColumn",
                    })
                end
                vim.api.nvim_buf_set_extmark(buf, custom_colorcolumn_ns, line, 0, {
                    virt_text = { { fill_str, "ColorColumn" } },
                    virt_text_win_col = math.max(line_width, colorcolumn_start),
                    priority = 50,
                })
                if wrap and line_width > text_width then
                    local num_rows = math.ceil(line_width / text_width)
                    for row_index = 0, num_rows - 1 do
                        local start_vcol = row_index * text_width
                        local end_vcol = math.min(line_width, (row_index + 1) * text_width)
                        local content_sw, cc_sc = end_vcol - start_vcol, colorcolumn_start - start_vcol
                        local raw_anchor = vim.fn.virtcol2col(win, line + 1, start_vcol + 1) - 1
                        local anchor = row_index == 0 and 0 or math.max(0, math.min(raw_anchor, #line_content - 1))
                        local fill_sc = math.max(content_sw, math.max(0, cc_sc))
                        if fill_sc < text_width then
                            vim.api.nvim_buf_set_extmark(buf, custom_colorcolumn_ns, line, anchor, {
                                virt_text = { { fill_str, "ColorColumn" } },
                                virt_text_win_col = fill_sc,
                                priority = 50,
                            })
                        end
                    end
                end
            end
        )
        local filler = {}
        local void_line = { { (" "):rep(colorcolumn_start) }, { fill_str, "ColorColumn" } }
        for _ = 1, vim.api.nvim_win_get_height(win) do filler[#filler + 1] = void_line end
        vim.api.nvim_buf_set_extmark(buf, custom_colorcolumn_ns, line_count - 1, 0, {
            id = 1,
            virt_lines = filler,
            priority = 1,
        })
    end,
})

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
    {
        "nmac427/guess-indent.nvim",
        config = function() require("guess-indent").setup() end,
    },
    { "airblade/vim-rooter" },
    {
        "navarasu/onedark.nvim",
        config = function()
            local onedark = require("onedark")
            onedark.setup { style = "light", transparent = true }
            onedark.load()
            vim.cmd("highlight CursorLine guibg=#ecf4fe")
            vim.cmd("highlight Visual guibg=#b2d7ff")
            vim.cmd("highlight MatchParen guibg=#d5dbde")
            vim.cmd("highlight! ColorColumn guibg=#fafafa")
            vim.cmd("highlight! link CursorLineNr CursorLine")
            vim.cmd("highlight! link CursorLineSign CursorLine")
            vim.cmd("highlight! link TreesitterContextLineNumber TreesitterContext")
            local fg = require("onedark.palette")[vim.g.onedark_config.style].fg
            vim.cmd("highlight! MiniStatuslineFilename guifg=" .. fg)
        end,
    },
    { "powerman/vim-plugin-AnsiEsc" },
    { "vim-scripts/ReplaceWithRegister" },
    { "inkarkat/vim-ReplaceWithSameIndentRegister" },
    { "tpope/vim-surround" },
    { "tpope/vim-fugitive" },
    { "bkad/CamelCaseMotion" },
    { "rbong/vim-flog" },
    {
        "numToStr/Comment.nvim",
        config = function() require("Comment").setup() end,
    },
    { "windwp/nvim-ts-autotag" },
    { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("nvim-treesitter.config").setup {
                highlight = { enable = true, disable = { "swift" } },
                indent = { enable = true },
                autotag = { enable = true },
                incremental_selection = {
                    enable = true,
                    keymaps = { init_selection = "\\", node_incremental = "\\", node_decremental = "<bs>" },
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["ab"] = "@block.outer",
                            ["ib"] = "@block.inner",
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                            ["aa"] = "@parameter.outer",
                            ["ia"] = "@parameter.inner",
                            ["a="] = "@assignment.outer",
                            ["i="] = "@assignment.inner",
                            ["a\\"] = "@comment.outer",
                            ["i\\"] = "@comment.inner",
                        },
                    },
                    move = {
                        enable = true,
                        goto_next_start = { ["]b"] = "@block.outer", ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
                        goto_next_end = { ["]B"] = "@block.outer", ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
                        goto_previous_start = { ["[b"] = "@block.outer", ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
                        goto_previous_end = { ["[B"] = "@block.outer", ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
                    },
                },
                auto_install = true,
            }
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = { "BufReadPre", "BufNewFile" },
        config = function() require("treesitter-context").setup { mode = "topline" } end,
    },
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-file-browser.nvim" },
        config = function()
            require("telescope").setup {
                defaults = { mappings = { i = { ["<M-a>"] = "select_all", ["<M-t>"] = "toggle_all" } } },
                extensions = { file_browser = { hijack_netrw = true } },
            }
            require("telescope").load_extension("file_browser")
        end,
    },
    {
        "echasnovski/mini.statusline",
        config = function() require("mini.statusline").setup() end,
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function() require("nvim-autopairs").setup { check_ts = true } end,
    },
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = { "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip", "hrsh7th/cmp-nvim-lsp", "windwp/nvim-autopairs" },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
            cmp.setup {
                snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
                mapping = cmp.mapping.preset.insert {
                    ["<c-k>"] = cmp.mapping.select_prev_item(),
                    ["<c-j>"] = cmp.mapping.select_next_item(),
                    ["<c-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<c-f>"] = cmp.mapping.scroll_docs(4),
                    ["<c-space>"] = cmp.mapping.complete(),
                    ["<c-e>"] = cmp.mapping.abort(),
                    ["<cr>"] = cmp.mapping.confirm { select = false },
                },
                sources = cmp.config.sources {
                    { name = "nvim_lsp" },
                    { name = "buffer" },
                    { name = "path" },
                },
            }
        end,
    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "hrsh7th/cmp-nvim-lsp" },
        config = function()
            local cmp_nvim_lsp = require("cmp_nvim_lsp")
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(args)
                    local buffer = args.buf
                    local opts = { noremap = true, silent = true, buffer = buffer }
                    vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<cr>", opts)
                    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                    vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>", opts)
                    vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<cr>", opts)
                    vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<cr>", opts)
                    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
                    vim.keymap.set({ "n", "v" }, "<leader>fmt", vim.lsp.buf.format, opts)
                    vim.keymap.set({ "n", "v" }, "<leader>rn", vim.lsp.buf.rename, opts)
                    vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=" .. buffer .. "<cr>", opts)
                    vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
                    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
                    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
                    vim.keymap.set({ "n", "v" }, "K", vim.lsp.buf.hover, opts)
                    vim.keymap.set({ "n", "v" }, "<leader>hnt", function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = buffer })
                    end, opts)
                end,
            })
            local default_config = {
                capabilities = cmp_nvim_lsp.default_capabilities(),
                single_file_support = true,
            }
            vim.lsp.config("*", default_config)
            vim.lsp.enable({ "ts_ls", "eslint", "sourcekit", "rust_analyzer", "bashls" })
        end,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function() require("ibl").setup { scope = { show_start = false, show_end = false } } end,
    },
    {
        "fwrs/gitsigns-nvim",
        config = function() require("gitsigns").setup() end,
    },
    {
        "smoka7/hop.nvim",
        event = "VeryLazy",
        config = function() require("hop").setup() end,
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function() require("which-key").setup { preset = "helix", icons = { mappings = false } } end,
    },
}

-- ------------------------------------------------------------ Leader

-- Set leader key to backslash
vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"

-- ------------------------------------------------------------ Install Plugins (lazy.nvim)

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
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

require("lazy").setup({
	spec = {
		-- Utility functions needed by other plugins
		{ "nvim-lua/plenary.nvim", branch = "master", lazy = true },

		-- Nord colour scheme for NeoVim
		{
			"shaunsingh/nord.nvim",
			lazy = false,
			priority = 1000,
			config = function()
				vim.cmd.colorscheme("nord")
			end,
		},

		-- Sidebar file explorer with icons and git diff signs
		{
			"nvim-tree/nvim-tree.lua",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
			keys = {
				{ "<C-b>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file explorer" },
			},
			init = function()
				vim.g.loaded_netrw = 1
				vim.g.loaded_netrwPlugin = 1
			end,
			config = function()
				local function on_attach(bufnr)
					local api = require("nvim-tree.api")

					local function opts(desc)
						return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
					end

					api.config.mappings.default_on_attach(bufnr)

					-- s or i to open file in horizontal or vertical split
					vim.keymap.set("n", "s", api.node.open.vertical, opts("Open: Vertical Split"))
					vim.keymap.set("n", "i", api.node.open.horizontal, opts("Open: Horizontal Split"))

					-- t to open file in new tab
					vim.keymap.set("n", "t", api.node.open.tab, opts("Open: New Tab"))

					-- l to open file or directory
					vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))

					-- h to close directory
					vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))

					-- C-e back to default (move view down by 1 line)
					vim.keymap.del("n", "<C-e>", { buffer = bufnr })
				end

				require("nvim-tree").setup({
					on_attach = on_attach,
					view = {
						number = true,
						relativenumber = true,
					},
					ui = {
						confirm = {
							remove = false,
							trash = false,
						},
					},
					actions = {
						open_file = {
							resize_window = true,
						},
					},
				})

				-- Open file explorer to current file
				vim.api.nvim_create_user_command("Nf", "NvimTreeFindFile", {})
			end,
		},

		-- \cc to comment out a highlighted section of code
		{
			"preservim/nerdcommenter",
			keys = {
				{ "<leader>cc", ":NerdCommenterToggle<CR>", mode = "v", silent = true },
			},
			init = function()
				-- Add spaces after comment delimiters
				vim.g.NERDSpaceDelims = 1
				-- Add comment delimiters to empty lines, too
				vim.g.NERDCommentEmptyLines = 1
			end,
		},

		-- Easy window/buffer resizing
		{
			"simeji/winresizer",
			event = "VeryLazy",
			init = function()
				-- Enter resize mode with C-w-r
				vim.g.winresizer_start_key = "<C-w>r"
				-- Increase vertical resize increment
				vim.g.winresizer_vert_resize = "5"
			end,
		},

		-- :MarkdownPreview to preview markdown files in your browser
		{
			"iamcco/markdown-preview.nvim",
			ft = { "markdown" },
			build = function()
				vim.fn["mkdp#util#install"]()
			end,
			init = function()
				-- Default to light mode
				vim.g.mkdp_theme = "light"
				-- Don't close preview when closing buffer
				vim.g.mkdp_auto_close = 0
			end,
		},

		-- \ww to swap windows/buffers
		{ "wesQ3/vim-windowswap", event = "VeryLazy" },

		-- Show git diff in sign column and blame inline (replaces vim-gitgutter)
		{
			"lewis6991/gitsigns.nvim",
			event = { "BufReadPre", "BufNewFile" },
			config = function()
				require("gitsigns").setup({
					-- Inline blame disabled, too noisy; re-enable by uncommenting
					-- current_line_blame = true,
					-- current_line_blame_opts = {
					-- 	delay = 300,
					-- 	virt_text_pos = "eol",
					-- },
					on_attach = function(bufnr)
						local gitsigns = require("gitsigns")
						local function map(mode, lhs, rhs, desc)
							vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
						end

						-- Jump to next and previous hunks
						map("n", "]g", function()
							gitsigns.nav_hunk("next")
						end, "Next hunk")
						map("n", "[g", function()
							gitsigns.nav_hunk("prev")
						end, "Prev hunk")
					end,
				})
			end,
		},

		-- Jump between corresponding ', ", `, | pairs
		{ "airblade/vim-matchquote", event = "VeryLazy" },

		-- Find and replace
		{
			"MagicDuck/grug-far.nvim",
			cmd = "GrugFar",
			keys = {
				{ "<leader>H", function() require("grug-far").open() end, desc = "Search and replace" },
				{
					"<leader>hw",
					function()
						require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
					end,
					desc = "Search and replace word",
				},
				{
					"<leader>hw",
					function()
						require("grug-far").with_visual_selection()
					end,
					mode = "v",
					desc = "Search and replace selection",
				},
				{
					"<leader>h",
					function()
						require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
					end,
					desc = "Search and replace in buffer",
				},
			},
		},

		-- Extremely fast fuzzy finder for files, text and everything else
		{
			"nvim-telescope/telescope.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim",
				{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			},
			cmd = "Telescope",
			keys = {
				{ "<C-p>", "<cmd>Telescope find_files<CR>", desc = "Find files" },
				{ "<C-f>", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
				{ "<C-_>", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Search buffer" },
			},
			config = function()
				local actions = require("telescope.actions")
				require("telescope").setup({
					defaults = {
						sorting_strategy = "ascending",
						layout_strategy = "horizontal",
						layout_config = { prompt_position = "top" },
						file_ignore_patterns = {
							"%.pyc",
							"%.o",
							"%.obj",
							"%.svn",
							"%.class",
							"%.hg",
							"%.DS_Store",
							"%.min%.",
							"%.git/",
							"%.cache/",
							"node_modules/",
							"dist/",
							"build/",
							"out/",
						},
						-- C-i and C-v to open selected result in horizontal and vertical splits
						mappings = {
							i = {
								["<C-i>"] = actions.select_horizontal,
								["<C-v>"] = actions.select_vertical,
							},
						},
					},
				})
				require("telescope").load_extension("fzf")

				-- :B to :Buffers
				vim.api.nvim_create_user_command("B", "Telescope buffers", {})
				-- :G to git modified files
				vim.api.nvim_create_user_command("G", "Telescope git_status", {})
			end,
		},

		-- ---------------- LSP + completion (replaces coc.nvim) ----------------

		{ "b0o/schemastore.nvim", lazy = true },

		{
			"neovim/nvim-lspconfig",
			dependencies = {
				{ "mason-org/mason.nvim", opts = {} },
				{
					"mason-org/mason-lspconfig.nvim",
					opts = {
						ensure_installed = {
							"ts_ls",
							"jsonls",
							"html",
							"cssls",
							"eslint",
							"yamlls",
							"taplo",
							"gopls",
							"clangd",
							"lua_ls",
							"pyright",
							"bashls",
							"rust_analyzer",
							"emmet_ls",
							"angularls",
							"biome",
							"denols",
							"lemminx",
							"ansiblels",
							"tailwindcss",
							"terraformls",
						},
						-- csharp_ls is excluded: its mason package is broken upstream
						-- (bad NuGet packaging for csharp-ls); we install it via
						-- `dotnet tool install --global csharp-ls` instead (see
						-- dotfiles/install) and enable it manually below.
						automatic_enable = { exclude = { "denols" } },
					},
				},
				"hrsh7th/cmp-nvim-lsp",
				"b0o/schemastore.nvim",
			},
			config = function()
				vim.lsp.config("lua_ls", {
					settings = {
						Lua = {
							diagnostics = { globals = { "vim" } },
						},
					},
				})

				vim.lsp.config("jsonls", {
					settings = {
						json = {
							schemas = require("schemastore").json.schemas(),
							validate = { enable = true },
						},
					},
				})

				vim.lsp.config("yamlls", {
					settings = {
						yaml = {
							schemaStore = { enable = false, url = "" },
							schemas = require("schemastore").yaml.schemas(),
						},
					},
				})

				-- Custom `languageserver` entries ported from coc-settings.json
				vim.lsp.config("terraformls", {
					cmd = { "terraform-ls", "serve" },
				})

				vim.lsp.config("csharp_ls", {
					cmd = { vim.fn.expand("~/.dotnet/tools/csharp-ls") },
					root_markers = { "*.sln", "*.csproj", ".git" },
				})
				-- Not mason-managed (see ensure_installed comment above), so it
				-- needs an explicit enable instead of relying on automatic_enable.
				vim.lsp.enable("csharp_ls")

				vim.lsp.config("*", {
					capabilities = require("cmp_nvim_lsp").default_capabilities(),
				})

				-- yaml.ansible filetype -> ansiblels (mirrors coc_filetype_map)
				vim.lsp.config("ansiblels", {
					filetypes = { "yaml.ansible" },
				})

				local function show_documentation()
					local filetype = vim.bo.filetype
					if filetype == "vim" or filetype == "help" then
						vim.cmd("h " .. vim.fn.expand("<cword>"))
					else
						vim.lsp.buf.hover()
					end
				end

				vim.api.nvim_create_autocmd("LspAttach", {
					callback = function(args)
						local bufnr = args.buf
						local function map(mode, lhs, rhs, desc)
							vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
						end

						-- Jump to definition
						map("n", "gd", vim.lsp.buf.definition, "Goto definition")
						-- Jump to type declaration
						map("n", "gt", vim.lsp.buf.type_definition, "Goto type definition")
						-- Jump to implementation
						map("n", "gi", vim.lsp.buf.implementation, "Goto implementation")
						-- View references to symbol (Telescope picker instead of quickfix)
						map("n", "gr", function()
							require("telescope.builtin").lsp_references()
						end, "References")
						-- Press K over a symbol to view documentation
						map("n", "K", show_documentation, "Hover / help")
						-- Use \rn to rename the hovered symbol
						map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
						-- F to fix (code action) on current line
						map("n", "F", vim.lsp.buf.code_action, "Code action")
						-- Jump to next and previous problems
						map("n", "]c", function()
							vim.diagnostic.jump({ count = 1, float = true })
						end, "Next diagnostic")
						map("n", "[c", function()
							vim.diagnostic.jump({ count = -1, float = true })
						end, "Prev diagnostic")
					end,
				})

				-- Edit NeoVim LSP configuration (was: edit coc-settings.json)
				vim.api.nvim_create_user_command("Ccs", function()
					vim.cmd("edit " .. vim.fn.stdpath("config") .. "/init.lua")
				end, {})

				-- Restart LSP clients (was: CocRestart)
				vim.api.nvim_create_user_command("Ccr", function()
					vim.cmd("LspRestart")
				end, {})

				-- Toggle inline type hints
				vim.api.nvim_create_user_command("Cth", function()
					local bufnr = vim.api.nvim_get_current_buf()
					vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
				end, {})
			end,
		},

		-- Fast semantic auto-completion
		{
			"hrsh7th/nvim-cmp",
			event = "InsertEnter",
			dependencies = {
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				"L3MON4D3/LuaSnip",
				"saadparwaiz1/cmp_luasnip",
				"rafamadriz/friendly-snippets",
				"onsails/lspkind.nvim",
			},
			config = function()
				local cmp = require("cmp")
				local luasnip = require("luasnip")
				require("luasnip.loaders.from_vscode").lazy_load()

				cmp.setup({
					snippet = {
						expand = function(args)
							luasnip.lsp_expand(args.body)
						end,
					},
					-- Use C-d and C-u to scroll completion docs
					mapping = cmp.mapping.preset.insert({
						["<C-d>"] = cmp.mapping.scroll_docs(-4),
						["<C-u>"] = cmp.mapping.scroll_docs(4),
						["<c-space>"] = cmp.mapping.complete(),
						["<C-e>"] = cmp.mapping.abort(),
						["<CR>"] = cmp.mapping.confirm({ select = false }),
						-- remap for complete to use tab and <cr>
						["<TAB>"] = cmp.mapping(function(fallback)
							if cmp.visible() then
								cmp.select_next_item()
							elseif luasnip.expand_or_jumpable() then
								luasnip.expand_or_jump()
							else
								fallback()
							end
						end, { "i", "s" }),
						["<S-TAB>"] = cmp.mapping(function(fallback)
							if cmp.visible() then
								cmp.select_prev_item()
							elseif luasnip.jumpable(-1) then
								luasnip.jump(-1)
							else
								fallback()
							end
						end, { "i", "s" }),
						-- Jump to next marker in snippet
						["<C-j>"] = cmp.mapping(function(fallback)
							if luasnip.jumpable(1) then
								luasnip.jump(1)
							else
								fallback()
							end
						end, { "i", "s" }),
						-- Triggers snippet expand
						["<C-l>"] = cmp.mapping(function(fallback)
							if luasnip.expandable() then
								luasnip.expand()
							else
								fallback()
							end
						end, { "i" }),
					}),
					sources = cmp.config.sources({
						{ name = "nvim_lsp" },
						{ name = "luasnip" },
					}, {
						{ name = "buffer" },
						{ name = "path" },
					}),
					formatting = {
						format = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 }),
					},
				})
			end,
		},

		-- Auto-close brackets/quotes (replaces coc-pairs), integrated with nvim-cmp
		{
			"windwp/nvim-autopairs",
			event = "InsertEnter",
			config = function()
				require("nvim-autopairs").setup({})
				local cmp_autopairs = require("nvim-autopairs.completion.cmp")
				require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
			end,
		},

		-- ---------------- /LSP + completion ----------------

		-- Status line customisation
		{
			"itchyny/lightline.vim",
			event = "VeryLazy",
			dependencies = { "itchyny/vim-gitbranch" },
			init = function()
				-- Get truncated filename and change symbol
				_G.LightlineFilename = function()
					local filename = vim.fn.expand("%:t") ~= "" and vim.fn.expand("%:t") or "[No Name]"
					local modified = vim.bo.modified and " +" or ""
					return filename .. modified
				end

				-- Show LSP diagnostic counts (replaces vim-lightline-coc)
				_G.LightlineDiagnostics = function()
					local count = vim.diagnostic.count(0)
					local errors = count[vim.diagnostic.severity.ERROR] or 0
					local warnings = count[vim.diagnostic.severity.WARN] or 0
					if errors == 0 and warnings == 0 then
						return ""
					end
					return string.format("E:%d W:%d", errors, warnings)
				end

				vim.g.lightline = {
					colorscheme = "nord",
					tabline = {
						left = { { "tabs" } },
						right = { {} },
					},
					active = {
						left = {
							{ "mode", "paste" },
							{ "readonly", "filename" },
							{ "diagnostics" },
						},
						right = {
							{ "lineinfo" },
							{ "percent" },
							{ "gitbranch", "filetype" },
						},
					},
					component_function = {
						gitbranch = "gitbranch#name",
						filename = "LightlineFilename",
						diagnostics = "LightlineDiagnostics",
					},
				}
			end,
		},

		-- git-vim integration
		{ "tpope/vim-fugitive", event = "VeryLazy" },

		-- Show colours next to hex strings
		{
			"rrethy/vim-hexokinase",
			build = "make hexokinase",
			event = "VeryLazy",
			init = function()
				-- Put colour in square next to code
				vim.g.Hexokinase_highlighters = { "virtual" }
				-- Match patterns for colours
				vim.g.Hexokinase_optInPatterns = "full_hex,rgb,rgba,hsl,hsla,colour_names,triple_hex"
			end,
		},

		-- Quickly temporarily toggle-maximize split windows
		{
			"szw/vim-maximizer",
			keys = {
				-- Ctrl+W + Z toggle-maximizes active split window
				{ "<C-w>z", "<cmd>MaximizerToggle<CR>", desc = "Toggle maximize split" },
			},
		},

		-- Smarter syntax highlighting
		{
			"nvim-treesitter/nvim-treesitter",
			branch = "master",
			build = ":TSUpdate",
			event = { "BufReadPost", "BufNewFile" },
			config = function()
				require("nvim-treesitter.configs").setup({
					ensure_installed = {
						"json",
						"json5",
						"jsonc",
						"jsonnet",
						"javascript",
						"typescript",
						"tsx",
						"jsdoc",
						"lua",
						"vim",
						"terraform",
						"regex",
						"nginx",
						"markdown",
						"markdown_inline",
						"git_rebase",
						"gitcommit",
						"dockerfile",
						"csv",
						"c_sharp",
						"bash",
						"astro",
					},
					sync_install = true,
					auto_install = false,
					highlight = {
						enable = true,
						additional_vim_regex_highlighting = false,
					},
					indent = {
						enable = true,
					},
					incremental_selection = {
						enable = true,
					},
				})
			end,
		},

		-- Formatting
		{
			"stevearc/conform.nvim",
			event = { "BufWritePre" },
			cmd = { "Prettier" },
			config = function()
				local prettier_filetypes = {
					"javascript",
					"javascriptreact",
					"javascript.tsx",
					"typescript",
					"typescriptreact",
					"typescript.tsx",
					"json",
					"jsonc",
					"css",
					"html",
				}

				local formatters_by_ft = {}
				for _, ft in ipairs(prettier_filetypes) do
					formatters_by_ft[ft] = { "prettier" }
				end

				require("conform").setup({
					formatters_by_ft = formatters_by_ft,
					format_on_save = function(bufnr)
						if vim.tbl_contains(prettier_filetypes, vim.bo[bufnr].filetype) then
							return { timeout_ms = 500, lsp_format = "fallback" }
						end
					end,
				})

				-- :Prettier to force formatting only with Prettier
				vim.api.nvim_create_user_command("Prettier", function()
					require("conform").format({ formatters = { "prettier" } })
				end, {})

				-- :P to format the currently open file
				vim.api.nvim_create_user_command("P", function()
					require("conform").format({ lsp_format = "fallback" })
				end, {})
			end,
		},

		-- Official Copilot plugin
		{
			"github/copilot.vim",
			event = "InsertEnter",
			init = function()
				vim.g.copilot_no_tab_map = true
			end,
			config = function()
				-- Remap accept Copilot suggestion to <C-\>
				vim.keymap.set("i", "<C-\\>", 'copilot#Accept("\\<CR>")', { silent = true, expr = true, script = true })
			end,
		},

		-- AI productivity tools
		{
			"olimorris/codecompanion.nvim",
			dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
			cmd = { "CodeCompanion", "CodeCompanionChat", "CC", "Cc", "CCc", "Ccc", "Ch" },
			config = function()
				require("codecompanion").setup({
					interactions = {
						chat = {
							opts = {
								completion_provider = "nvim-cmp",
							},
						},
					},
					strategies = {
						chat = {
							adapter = "copilot",
						},
						inline = {
							adapter = "copilot",
						},
					},
					display = {
						chat = {
							window = {
								position = "right",
							},
						},
					},
				})

				-- Shortcuts to CodeCompanion commands
				vim.api.nvim_create_user_command("CC", "CodeCompanion", {})
				vim.api.nvim_create_user_command("Cc", "CodeCompanion", {})
				vim.api.nvim_create_user_command("CCc", "CodeCompanionChat", {})
				vim.api.nvim_create_user_command("Ccc", "CodeCompanionChat", {})
				vim.api.nvim_create_user_command("Ch", "CodeCompanionChat", {})
			end,
		},
	},
})

-- ------------------------------------------------------------ General Settings

-- Ignore files and folders in autocomplete and file explorer
vim.opt.wildignore:append({
	"*.pyc", "*.o", "*.obj", "*.svn", "*.swp", "*.swo", "*.swn", "*.class", "*.hg",
	"*.DS_Store", "*.min.*", ".git", ".cache", "node_modules", "dist", "build", "out",
})
vim.opt.wildignorecase = true

-- Always set newline encoding to Unix
vim.opt.fileformat = "unix"

-- 24-bit RGB terminal colours
vim.opt.termguicolors = true

-- Don't show mode as text to let lightline.vim handle it
vim.opt.showmode = false

-- Keep closed buffers in memory
vim.opt.hidden = true

-- Prevent commands requiring pressing Enter to continue after execution
vim.opt.cmdheight = 2

-- Disable cursor-styling for different modes
vim.opt.guicursor = ""

-- Disable cursor blinking
vim.opt.guicursor:append("a:blinkon0")

-- Enable line numbers, relative numbers and lint sign gutter
vim.opt.number = true
vim.opt.signcolumn = "yes"
vim.opt.relativenumber = true

-- Allow jumping between < and >
vim.opt.matchpairs:append("<:>")

-- Background highlight on current line
vim.opt.cursorline = true

-- Always show tabs
vim.opt.showtabline = 2

-- Disable all mouse interaction
vim.opt.mouse = ""

-- Fold based on indentation and set minimum and maximum fold-level
vim.opt.foldmethod = "indent"
vim.opt.foldlevelstart = 99
vim.opt.foldminlines = 0

-- Allow cursor to move past the last character of a line
vim.opt.virtualedit:append("onemore")

-- Remove timeout to wait for a key combination to fix Esc-o and Esc-O combos
vim.opt.timeout = false
vim.opt.ttimeout = false

-- Shift indentation two characters
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

-- Enable plugin autocommands based on file type
vim.cmd("filetype plugin on")

-- Case insensitive searching
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Disable backups of original file content
vim.opt.backup = false
vim.opt.writebackup = false

-- Speed up swap file updates and buffer to disk syncing
vim.opt.updatetime = 300

-- Grey out folds
vim.cmd("highlight Folded guifg=#666666")

-- Format binary files
vim.api.nvim_create_augroup("Binary", { clear = true })
vim.api.nvim_create_autocmd("BufReadPre", {
	group = "Binary", pattern = "*.bin", command = "let &bin=1",
})
vim.api.nvim_create_autocmd("BufReadPost", {
	group = "Binary", pattern = "*.bin", command = "if &bin | %!xxd | endif",
})
vim.api.nvim_create_autocmd("BufReadPost", {
	group = "Binary", pattern = "*.bin", command = "if &bin | set ft=xxd | endif",
})
vim.api.nvim_create_autocmd("BufWritePre", {
	group = "Binary", pattern = "*.bin", command = "if &bin | %!xxd -r | endif",
})
vim.api.nvim_create_autocmd("BufWritePost", {
	group = "Binary", pattern = "*.bin", command = "if &bin | %!xxd | endif",
})
vim.api.nvim_create_autocmd("BufWritePost", {
	group = "Binary", pattern = "*.bin", command = "if &bin | set nomod | endif",
})

-- Scroll to center of screen if search result is off screen
local function maybe_middle()
	if vim.fn.winline() == 1 or vim.fn.winline() == vim.fn.winheight(0) then
		vim.cmd("normal! zz")
	end
end
vim.keymap.set("n", "n", function()
	vim.cmd("normal! n")
	maybe_middle()
end, { silent = true })
vim.keymap.set("n", "N", function()
	vim.cmd("normal! N")
	maybe_middle()
end, { silent = true })

-- Disable netrw (in-built file explorer) because we use a plugin instead
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Auto-reload buffer as soon as file updates on disk
vim.opt.autoread = true
vim.api.nvim_create_autocmd("CursorHold", { pattern = "*", command = "checktime" })

-- Disable modelines (code comments that set vim variables per file)
vim.opt.modeline = false

-- ------------------------------------------------------------ Keybindings

-- w goes to the end of the word instead of the beginning of the next word
vim.keymap.set({ "n", "v" }, "w", "e", { silent = true })
vim.keymap.set("n", "dw", "de", { silent = true })
vim.keymap.set("n", "yw", "ye", { silent = true })

-- Double-escape to hide search highlights
vim.keymap.set("n", "<esc><esc>", function()
	vim.fn.setreg("/", "")
end, { silent = true })

-- Do not unselect after indenting or de-indenting
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")

-- Do not re-yank when pasting over a selected portion of text
vim.keymap.set("v", "p", "pgvy")

-- c and C to shallow and deep fold
vim.keymap.set("n", "c", "za")
vim.keymap.set("n", "C", "zA")

-- r to redo
vim.keymap.set("n", "r", "<C-R>")

-- Enable spell-checking in markdown and text files
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "text" },
	callback = function()
		vim.opt_local.spell = true
		vim.opt.wrap = true
		vim.opt.linebreak = true
	end,
})

-- Switch to fold markers for vim configuration files
vim.api.nvim_create_autocmd("FileType", {
	pattern = "vim",
	command = "setlocal foldmethod=marker",
})

-- ; to enter commands
vim.keymap.set({ "n", "v" }, ";", ":")

-- Search for currently highlighted text
vim.keymap.set("v", "*", [[y/\V<C-R>=escape(@",'/\')<CR><CR>]])
vim.keymap.set("v", "#", [[y?\V<C-R>=escape(@",'/\')<CR><CR>]])

-- Offset screen center with zz up by a few lines
vim.keymap.set("n", "zz", "zz10<c-e>")

-- ------------------------------ Windowing

-- Split windows with C-w and - or |
vim.keymap.set("n", "<C-w>-", "<cmd>sp<CR>", { silent = true })
vim.keymap.set("n", "<C-w>|", "<cmd>vs<CR>", { silent = true })

-- Write current buffer with C-w-s
vim.keymap.set("n", "<C-w>s", "<cmd>w<CR>")

-- ------------------------------ Tabbing

-- t-n creates a new tab
vim.keymap.set("n", "tn", "<cmd>tabedit %<CR>", { silent = true })

-- t-c closes the current tab
vim.keymap.set("n", "tc", "<cmd>tabclose<CR><cmd>tabprevious<CR>", { silent = true })

-- t-l and t-h to move between next and previous tabs
vim.keymap.set("n", "tl", "<cmd>tabnext<CR>", { silent = true })
vim.keymap.set("n", "th", "<cmd>tabprevious<CR>", { silent = true })

-- t-o closes all but the current tab
vim.keymap.set("n", "to", "<cmd>tabonly<CR>", { silent = true })

-- t-m-l and t-m-h move the current tab right and left
vim.keymap.set("n", "tml", "<cmd>+tabmove<CR>", { silent = true })
vim.keymap.set("n", "tmh", "<cmd>-tabmove<CR>", { silent = true })

-- 1-t-g goes to the first tab
vim.keymap.set("n", "1tg", "1gt", { silent = true })

-- ------------------------------------------------------------ Commands

-- Edit NeoVim configuration
vim.api.nvim_create_user_command("Vrc", "e ~/.config/nvim/init.lua", {})

-- Reload NeoVim configuration
vim.api.nvim_create_user_command("Svrc", "source ~/.config/nvim/init.lua", {})

-- Edit Zsh aliases
vim.api.nvim_create_user_command("Za", "e ~/.oh-my-zsh/custom/aliases.zsh", {})

-- Edit Zsh configuration
vim.api.nvim_create_user_command("Zrc", "e ~/.zshrc", {})

-- Echo the full path of the current file
vim.api.nvim_create_user_command("Path", "echo @%", {})
vim.api.nvim_create_user_command("Pa", "echo @%", {})
vim.api.nvim_create_user_command("PA", "echo @%", {})

-- Toggle line breaking
vim.api.nvim_create_user_command("Nr", "set wrap!", {})

-- Check for file changes
vim.api.nvim_create_user_command("Ct", "checktime", {})

-- Quickly set fold level
vim.api.nvim_create_user_command("Fl", "set foldlevel=<args>", { nargs = 1 })

-- :Pins installs plugins, :Pclean cleans unused plugins (was vim-plug)
vim.api.nvim_create_user_command("Pins", "Lazy install", {})
vim.api.nvim_create_user_command("Pclean", "Lazy clean", {})

-- ------------------------------------------------------------ Re-map file types

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, { pattern = "*.json", command = "set filetype=jsonc" })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, { pattern = { "*.jsx", "*.js.hbs" }, command = "set filetype=javascript.tsx" })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, { pattern = "*.tsx", command = "set filetype=typescript.tsx" })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, { pattern = { ".eslintrc", ".prettierrc", ".parcelrc" }, command = "set filetype=json" })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, { pattern = { ".eslintignore", ".prettierignore", ".gitignore" }, command = "set filetype=conf" })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = { ".env", ".env.defaults", ".env.sample", ".env.example", ".env.template" },
	command = "set filetype=bash",
})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, { pattern = { "*.cnf", "*.conf" }, command = "set filetype=dosini" })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, { pattern = "*.dockerfile", command = "set filetype=dockerfile" })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, { pattern = ".localrc", command = "set filetype=zsh" })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, { pattern = "*.mdx", command = "set filetype=markdown" })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, { pattern = { "*.tf", "*.tfvars" }, command = "set filetype=terraform" })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = { "inventory.yaml", "inventory.yml", "playbook.yaml", "playbook.yml" },
	command = "set filetype=yaml.ansible",
})

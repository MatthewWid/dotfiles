-- LSP client configuration + server installation (replaces coc.nvim)
return {
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
		-- `vim` global etc. are typed via lazydev.nvim (plugins/lazydev)
		-- instead of the old diagnostics.globals workaround
		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					workspace = { checkThirdParty = false },
					completion = { callSnippet = "Replace" },
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

		require("plugins.lspconfig.autocmds").setup()
		require("plugins.lspconfig.keymaps").setup_commands()
	end,
}

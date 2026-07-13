local M = {}

local function show_documentation()
	local filetype = vim.bo.filetype
	if filetype == "vim" or filetype == "help" then
		vim.cmd("h " .. vim.fn.expand("<cword>"))
	else
		vim.lsp.buf.hover()
	end
end

function M.on_attach(bufnr)
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
end

function M.setup_commands()
	-- Edit NeoVim LSP configuration (was: edit coc-settings.json)
	vim.api.nvim_create_user_command("Ccs", function()
		vim.cmd("edit " .. vim.fn.stdpath("config") .. "/plugins/lspconfig/init.lua")
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
end

return M

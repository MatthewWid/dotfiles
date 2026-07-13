local M = {}

function M.setup()
	-- Remap accept Copilot suggestion to <C-\>
	-- replace_keycodes = false: vim.keymap.set defaults this to true for
	-- expr mappings, which re-expands the special-key notation (e.g. the
	-- trailing \<End>) that copilot#Accept() already returns pre-expanded —
	-- that double-processing is what corrupts it into literal `<80>@7` text
	vim.keymap.set(
		"i",
		"<C-\\>",
		'copilot#Accept("\\<CR>")',
		{ silent = true, expr = true, script = true, replace_keycodes = false }
	)
end

return M

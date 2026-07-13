local M = {}

function M.setup()
	-- lightline's components (mode(), line('.'), &modified, etc.) reflect
	-- whatever window is currently focused. Telescope's prompt is a floating
	-- window with no statusline of its own, but while it's focused those
	-- ambient values still get drawn onto the real window's statusline
	-- underneath — showing "[No Name] +" and the prompt's cursor position
	-- instead of the file you were editing. Hide the statusline entirely
	-- for the duration the prompt is focused, since `laststatus` can only
	-- be toggled globally, not per-window.
	local saved_laststatus

	vim.api.nvim_create_autocmd("FileType", {
		pattern = "TelescopePrompt",
		callback = function()
			saved_laststatus = vim.o.laststatus
			vim.o.laststatus = 0
		end,
	})

	vim.api.nvim_create_autocmd("BufWinLeave", {
		callback = function(args)
			if vim.bo[args.buf].filetype == "TelescopePrompt" and saved_laststatus then
				vim.o.laststatus = saved_laststatus
				saved_laststatus = nil
			end
		end,
	})
end

return M

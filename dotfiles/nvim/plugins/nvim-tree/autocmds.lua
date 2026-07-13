local M = {}

function M.setup()
	-- Open the file explorer instead of a raw directory buffer when nvim is
	-- started with a directory argument (e.g. `nvim .`)
	vim.api.nvim_create_autocmd("VimEnter", {
		callback = function(data)
			if vim.fn.isdirectory(data.file) ~= 1 then
				return
			end

			vim.cmd.cd(data.file)
			vim.cmd("NvimTreeOpen")
		end,
	})
end

return M

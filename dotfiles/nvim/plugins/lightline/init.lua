-- Status line customisation
return {
	"itchyny/lightline.vim",
	event = "VeryLazy",
	dependencies = { "itchyny/vim-gitbranch" },
	init = function()
		-- init (unlike config) always runs at startup regardless of when
		-- lightline itself lazy-loads, so this is registered before
		-- Telescope could ever be opened
		require("plugins.lightline.autocmds").setup()

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

		-- lightline.vim invokes component_function entries as Vimscript
		-- functions via call(), which can't see Lua globals directly —
		-- bridge to them through v:lua.
		vim.cmd([[
			function! LightlineFilename()
				return v:lua.LightlineFilename()
			endfunction

			function! LightlineDiagnostics()
				return v:lua.LightlineDiagnostics()
			endfunction
		]])

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
}

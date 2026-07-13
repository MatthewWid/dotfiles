-- Vim/lazy.nvim API types for lua_ls, so editing this config doesn't warn
-- about `vim` being an undefined global
return {
	"folke/lazydev.nvim",
	ft = "lua",
	opts = {
		library = {
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			"lazy.nvim",
		},
	},
}

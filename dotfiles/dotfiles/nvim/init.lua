-- ------------------------------------------------------------ Leader

-- Set leader key to backslash
vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"

-- ------------------------------------------------------------ Module resolution

-- Allow `require("plugins.foo")`, `require("options")`, etc. to resolve
-- against this directory without needing a `lua/` subdirectory.
local config_path = vim.fn.stdpath("config")
package.path = config_path .. "/?.lua;" .. config_path .. "/?/init.lua;" .. package.path

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

-- Every subdirectory of plugins/ contributes one lazy.nvim plugin spec via
-- its init.lua. This is what lets `nvim/plugins/<name>/` be the single
-- place to fuzzy-find for any given plugin's config, keybinds and autocmds.
local function discover_plugin_specs()
	local specs = {}
	local plugins_dir = config_path .. "/plugins"
	local handle = vim.uv.fs_scandir(plugins_dir)
	if not handle then
		return specs
	end
	while true do
		local name, kind = vim.uv.fs_scandir_next(handle)
		if not name then
			break
		end
		if kind == "directory" then
			table.insert(specs, require("plugins." .. name))
		end
	end
	return specs
end

require("lazy").setup({
	spec = discover_plugin_specs(),
})

-- ------------------------------------------------------------ General settings, keymaps, commands, autocmds

require("options")
require("keymaps")
require("commands")
require("autocmds")

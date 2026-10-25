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

local function copy_buffer_path(absolute)
	local path = vim.fn.expand("%:p")
	if path == "" then
		error("Current buffer has no file path")
	end

	if not absolute then
		local git_root = vim.fn.FugitiveWorkTree()
		if git_root == "" then
			error("Current buffer is not inside a Git repository")
		end
		path = vim.fs.relpath(vim.trim(git_root), path)
	end

	vim.fn.setreg("+", path)
	vim.api.nvim_echo({ { "Copied: " .. path, "MoreMsg" } }, false, {})
end

vim.api.nvim_create_user_command("Cp", function()
	copy_buffer_path(false)
end, {})
vim.api.nvim_create_user_command("Cap", function()
	copy_buffer_path(true)
end, {})

-- Toggle line breaking
vim.api.nvim_create_user_command("Nr", "set wrap!", {})

-- Check for file changes
vim.api.nvim_create_user_command("Ct", "checktime", {})

-- Quickly set fold level
vim.api.nvim_create_user_command("Fl", "set foldlevel=<args>", { nargs = 1 })

-- :Pins installs plugins, :Pclean cleans unused plugins (was vim-plug)
vim.api.nvim_create_user_command("Pins", "Lazy install", {})
vim.api.nvim_create_user_command("Pclean", "Lazy clean", {})

vim.api.nvim_create_user_command("B", function()
	require("telescope.builtin").buffers()
end, {})
vim.api.nvim_create_user_command("G", function()
	require("telescope.builtin").git_status()
end, {})

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

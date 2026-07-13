-- ------------------------------------------------------------ General Autocommands

-- Format binary files
vim.api.nvim_create_augroup("Binary", { clear = true })
vim.api.nvim_create_autocmd("BufReadPre", {
	group = "Binary", pattern = "*.bin", command = "let &bin=1",
})
vim.api.nvim_create_autocmd("BufReadPost", {
	group = "Binary", pattern = "*.bin", command = "if &bin | %!xxd | endif",
})
vim.api.nvim_create_autocmd("BufReadPost", {
	group = "Binary", pattern = "*.bin", command = "if &bin | set ft=xxd | endif",
})
vim.api.nvim_create_autocmd("BufWritePre", {
	group = "Binary", pattern = "*.bin", command = "if &bin | %!xxd -r | endif",
})
vim.api.nvim_create_autocmd("BufWritePost", {
	group = "Binary", pattern = "*.bin", command = "if &bin | %!xxd | endif",
})
vim.api.nvim_create_autocmd("BufWritePost", {
	group = "Binary", pattern = "*.bin", command = "if &bin | set nomod | endif",
})

-- Auto-reload buffer as soon as file updates on disk
vim.api.nvim_create_autocmd("CursorHold", { pattern = "*", command = "checktime" })

-- Enable spell-checking in markdown and text files
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "text" },
	callback = function()
		vim.opt_local.spell = true
		vim.opt.wrap = true
		vim.opt.linebreak = true
	end,
})

-- Switch to fold markers for vim configuration files
vim.api.nvim_create_autocmd("FileType", {
	pattern = "vim",
	command = "setlocal foldmethod=marker",
})

-- ------------------------------------------------------------ Re-map file types

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, { pattern = "*.json", command = "set filetype=jsonc" })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, { pattern = { "*.jsx", "*.js.hbs" }, command = "set filetype=javascript.tsx" })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, { pattern = "*.tsx", command = "set filetype=typescript.tsx" })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, { pattern = { ".eslintrc", ".prettierrc", ".parcelrc" }, command = "set filetype=json" })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, { pattern = { ".eslintignore", ".prettierignore", ".gitignore" }, command = "set filetype=conf" })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = { ".env", ".env.defaults", ".env.sample", ".env.example", ".env.template" },
	command = "set filetype=bash",
})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, { pattern = { "*.cnf", "*.conf" }, command = "set filetype=dosini" })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, { pattern = "*.dockerfile", command = "set filetype=dockerfile" })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, { pattern = ".localrc", command = "set filetype=zsh" })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, { pattern = "*.mdx", command = "set filetype=markdown" })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, { pattern = { "*.tf", "*.tfvars" }, command = "set filetype=terraform" })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = { "inventory.yaml", "inventory.yml", "playbook.yaml", "playbook.yml" },
	command = "set filetype=yaml.ansible",
})

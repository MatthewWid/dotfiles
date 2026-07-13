-- ------------------------------------------------------------ General Settings

-- Ignore files and folders in autocomplete and file explorer
vim.opt.wildignore:append({
	"*.pyc", "*.o", "*.obj", "*.svn", "*.swp", "*.swo", "*.swn", "*.class", "*.hg",
	"*.DS_Store", "*.min.*", ".git", ".cache", "node_modules", "dist", "build", "out",
})
vim.opt.wildignorecase = true

-- Always set newline encoding to Unix
vim.opt.fileformat = "unix"

-- 24-bit RGB terminal colours
vim.opt.termguicolors = true

-- Don't show mode as text to let lightline.vim handle it
vim.opt.showmode = false

-- Keep closed buffers in memory
vim.opt.hidden = true

-- Prevent commands requiring pressing Enter to continue after execution
vim.opt.cmdheight = 2

-- Disable cursor-styling for different modes
vim.opt.guicursor = ""

-- Disable cursor blinking
vim.opt.guicursor:append("a:blinkon0")

-- Enable line numbers, relative numbers and lint sign gutter
vim.opt.number = true
vim.opt.signcolumn = "yes"
vim.opt.relativenumber = true

-- Allow jumping between < and >
vim.opt.matchpairs:append("<:>")

-- Background highlight on current line
vim.opt.cursorline = true

-- Always show tabs
vim.opt.showtabline = 2

-- Disable all mouse interaction
vim.opt.mouse = ""

-- Fold based on indentation and set minimum and maximum fold-level
vim.opt.foldmethod = "indent"
vim.opt.foldlevelstart = 99
vim.opt.foldminlines = 0

-- Allow cursor to move past the last character of a line
vim.opt.virtualedit:append("onemore")

-- Remove timeout to wait for a key combination to fix Esc-o and Esc-O combos
vim.opt.timeout = false
vim.opt.ttimeout = false

-- Shift indentation two characters
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

-- Enable plugin autocommands based on file type
vim.cmd("filetype plugin on")

-- Case insensitive searching
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Disable backups of original file content
vim.opt.backup = false
vim.opt.writebackup = false

-- Speed up swap file updates and buffer to disk syncing
vim.opt.updatetime = 300

-- Grey out folds
vim.cmd("highlight Folded guifg=#666666")

-- Disable netrw (in-built file explorer) because we use a plugin instead
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Auto-reload buffer as soon as file updates on disk
vim.opt.autoread = true

-- Disable modelines (code comments that set vim variables per file)
vim.opt.modeline = false

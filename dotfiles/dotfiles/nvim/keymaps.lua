-- ------------------------------------------------------------ Keybindings

-- w goes to the end of the word instead of the beginning of the next word
vim.keymap.set({ "n", "v" }, "w", "e", { silent = true })
vim.keymap.set("n", "dw", "de", { silent = true })
vim.keymap.set("n", "yw", "ye", { silent = true })

-- Double-escape to hide search highlights
vim.keymap.set("n", "<esc><esc>", function()
	vim.fn.setreg("/", "")
end, { silent = true })

-- Do not unselect after indenting or de-indenting
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")

-- Do not re-yank when pasting over a selected portion of text
vim.keymap.set("v", "p", "pgvy")

-- c and C to shallow and deep fold
vim.keymap.set("n", "c", "za")
vim.keymap.set("n", "C", "zA")

-- r to redo
vim.keymap.set("n", "r", "<C-R>")

-- ; to enter commands
vim.keymap.set({ "n", "v" }, ";", ":")

-- Search for currently highlighted text
vim.keymap.set("v", "*", [[y/\V<C-R>=escape(@",'/\')<CR><CR>]])
vim.keymap.set("v", "#", [[y?\V<C-R>=escape(@",'/\')<CR><CR>]])

-- Offset screen center with zz up by a few lines
vim.keymap.set("n", "zz", "zz10<c-e>")

-- Scroll to center of screen if search result is off screen
local function maybe_middle()
	if vim.fn.winline() == 1 or vim.fn.winline() == vim.fn.winheight(0) then
		vim.cmd("normal! zz")
	end
end
vim.keymap.set("n", "n", function()
	vim.cmd("normal! n")
	maybe_middle()
end, { silent = true })
vim.keymap.set("n", "N", function()
	vim.cmd("normal! N")
	maybe_middle()
end, { silent = true })

-- ------------------------------ Windowing

-- Split windows with C-w and - or |
vim.keymap.set("n", "<C-w>-", "<cmd>sp<CR>", { silent = true })
vim.keymap.set("n", "<C-w>|", "<cmd>vs<CR>", { silent = true })

-- Write current buffer with C-w-s
vim.keymap.set("n", "<C-w>s", "<cmd>w<CR>")

-- ------------------------------ Tabbing

-- t-n creates a new tab
vim.keymap.set("n", "tn", "<cmd>tabedit %<CR>", { silent = true })

-- t-c closes the current tab
vim.keymap.set("n", "tc", "<cmd>tabclose<CR><cmd>tabprevious<CR>", { silent = true })

-- t-l and t-h to move between next and previous tabs
vim.keymap.set("n", "tl", "<cmd>tabnext<CR>", { silent = true })
vim.keymap.set("n", "th", "<cmd>tabprevious<CR>", { silent = true })

-- t-o closes all but the current tab
vim.keymap.set("n", "to", "<cmd>tabonly<CR>", { silent = true })

-- t-m-l and t-m-h move the current tab right and left
vim.keymap.set("n", "tml", "<cmd>+tabmove<CR>", { silent = true })
vim.keymap.set("n", "tmh", "<cmd>-tabmove<CR>", { silent = true })

-- 1-t-g goes to the first tab
vim.keymap.set("n", "1tg", "1gt", { silent = true })

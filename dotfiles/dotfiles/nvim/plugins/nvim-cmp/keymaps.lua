local cmp = require("cmp")
local luasnip = require("luasnip")

local M = {}

-- Use C-d and C-u to scroll completion docs
M.mapping = cmp.mapping.preset.insert({
	["<C-d>"] = cmp.mapping.scroll_docs(-4),
	["<C-u>"] = cmp.mapping.scroll_docs(4),
	["<c-space>"] = cmp.mapping.complete(),
	["<C-e>"] = cmp.mapping.abort(),
	["<CR>"] = cmp.mapping.confirm({ select = false }),
	-- remap for complete to use tab and <cr>
	["<TAB>"] = cmp.mapping(function(fallback)
		if cmp.visible() then
			cmp.select_next_item()
		elseif luasnip.expand_or_jumpable() then
			luasnip.expand_or_jump()
		else
			fallback()
		end
	end, { "i", "s" }),
	["<S-TAB>"] = cmp.mapping(function(fallback)
		if cmp.visible() then
			cmp.select_prev_item()
		elseif luasnip.jumpable(-1) then
			luasnip.jump(-1)
		else
			fallback()
		end
	end, { "i", "s" }),
	-- Jump to next marker in snippet
	["<C-j>"] = cmp.mapping(function(fallback)
		if luasnip.jumpable(1) then
			luasnip.jump(1)
		else
			fallback()
		end
	end, { "i", "s" }),
	-- Triggers snippet expand
	["<C-l>"] = cmp.mapping(function(fallback)
		if luasnip.expandable() then
			luasnip.expand()
		else
			fallback()
		end
	end, { "i" }),
})

return M

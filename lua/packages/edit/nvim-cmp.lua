local cmp = require("cmp")
local types = require("cmp.types")
local lspkind = require("lspkind")
local config = require("core.config")

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local source_menus = {
  nvim_lsp = "[LSP]",
  luasnip = "[Snippet]",
  cmp_tabnine = "[TabNine]",
  buffer = "[Buffer]",
  path = "[Path]",
  emoji = "[Emoji]",
  treesitter = "[TS]",
}

cmp.setup({
  completion = {
    autocomplete = {
      types.cmp.TriggerEvent.InsertEnter,
      types.cmp.TriggerEvent.TextChanged,
    },
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "treesitter" },
    { name = "emoji" },
    { name = "buffer" },
    { name = "path" },
    { name = "cmp_tabnine" },
  }),
  window = {
    documentation = {
      border = config.window.border,
    },
    completion = {
      border = config.window.border,
    },
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-n>"] = function()
      if cmp.visible() then
        cmp.mapping.select_next_item()()
      else
        cmp.mapping.complete()()
      end
    end,
    ["<Tab>"] = function()
      if cmp.visible() then
        cmp.mapping.select_next_item()()
      elseif has_words_before() then
        cmp.complete()
      else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", true)
      end
    end,
    ["<C-p>"] = function()
      if cmp.visible() then
        cmp.mapping.select_prev_item()()
      else
        cmp.mapping.complete()()
      end
    end,
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
  }),
  formatting = {
    format = function(entry, vim_item)
      vim_item.kind = lspkind.symbolic(vim_item.kind)
      vim_item.menu = source_menus[entry.source.name]
      return vim_item
    end,
  },
})

cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})

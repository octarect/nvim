-- Use <Leader> for mappings of global plugin
vim.g.mapleader = " "
-- Use <LocalLeader> for mappings of filetype-local plugin
vim.g.maplocalleader = ","
-- Release default mappings of the keys used for <Leader> and <LocalLeader>
vim.api.nvim_set_keymap("n", vim.g.mapleader, "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", vim.g.maplocalleader, "<Nop>", { noremap = true, silent = true })

-- Disable default plugins
vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1

vim.api.nvim_command("filetype plugin indent on")
if vim.fn.has("vim_starting") == 1 then
  vim.api.nvim_command("syntax enable")
end

require("config.options")
require("config.filetypes")
require("config.keymaps")
require("core.hack")
require("packages")

require("lib.colorscheme").setup({
  on_change = function(_)
    local hl = require("lib.colorscheme").hl
    local link = require("lib.colorscheme").link
    local defined = require("lib.colorscheme").defined

    -- Global settings
    hl("LineNr", { fg = "#efefef", ctermfg = 252 })
    hl("Whitespace", { fg = "#b0bec5", ctermfg = 96 })
    hl("VertSplit", { fg = "Black", ctermfg = "Black" })
    hl("SignColumn", { fg = "#ebdbb2", ctermfg = 187 })

    -- Remove background color of blank area (EndOfBuffer) under EOF
    if vim.fn.has("nvim") == 1 or vim.fn.has("patch-7.4.237") then
      hl("EndOfBuffer", {})
    end

    -- Highlight groups for gitsigns
    hl("GitSignsAdd", { fg = "#00e676", ctermfg = 2 })
    hl("GitSignsChange", { fg = "#ffc400", ctermfg = 3 })
    hl("GitSignsDelete", { fg = "#ff3d00", ctermfg = 1 })

    -- Built-in LSP
    hl("LspDiagnosticsSignError", { fg = "#fd8489", ctermfg = 210, bold = true })
    hl("LspDiagnosticsSignWarning", { fg = "#fedf81", ctermfg = 222, bold = true })
    hl("LspDiagnosticsSignInformation", { fg = "#a8d2eb", ctermfg = 153, bold = true })
    hl("LspDiagnosticsSignhlnt", { fg = "#a9dd9d", ctermfg = 150, bold = true })
    link("LspReferenceRead", "Search")
    link("LspReferenceText", "Search")
    link("LspReferenceWrite", "Search")

    -- Treesitter support
    if not defined("@text.diff.add") then
      link("@text.diff.add", "DiffAdd")
      link("@text.diff.delete", "DiffDelete")
      link("@attribute", "DiffChange")
    end

    -- Make border of floating window blend into the background
    link("FloatBorder", "Normal")
  end
})

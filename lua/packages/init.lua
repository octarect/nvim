local uv = vim.uv or vim.loop

-- Download lazy if it doesn't exist.
local lazy_repo_url = "https://github.com/folke/lazy.nvim.git"
local lazy_rocks_path = vim.fn.stdpath("data") .. "/rocks"
local lazy_lockfile_path = vim.fn.stdpath("state") .. "/lazy/lock.json"
local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

local lazy_installed = uv.fs_stat(lazy_path)
if not lazy_installed then
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazy_repo_url, lazy_path })
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
vim.opt.runtimepath:prepend(lazy_path)

-- Register event mappings (aliases)
local event = require("lazy.core.handler.event")
event.mappings["LazyFile"] = { id = "LazyFile", event = { "BufNewFile", "BufReadPre", "BufWritePre" } }
event["User LazyFile"] = event.mappings["LazyFile"]

-- Load packages
local packages = {}
local package_definitions = {
  "ai",
  "colorscheme",
  "completion",
  "edit",
  "lsp",
  "telescope",
  "ui",
  "util",
}
for _, name in ipairs(package_definitions) do
  table.insert(packages, require("packages." .. name))
end
require("lazy").setup(packages, {
  lockfile = lazy_lockfile_path,
  rocks = {
    root = lazy_rocks_path,
  },
  spec = {},
  install = {
    colorscheme = { "desert" },
  },
})

local uv = vim.uv or vim.loop

local lazy_repo_url = "https://github.com/folke/lazy.nvim.git"
local lazy_rocks_path = vim.fn.stdpath("data") .. "/rocks"
local lazy_lockfile_path = vim.fn.stdpath("state") .. "/lazy/lock.json"

local M = {}
M.packages = {}

function M:add(defaults, packages)
  for _, p in ipairs(packages) do
    if defaults ~= nil and next(defaults) ~= nil then
      p = vim.tbl_deep_extend("force", defaults, p)
    end
    table.insert(self.packages, p)
  end
end

function M:load()
  local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not uv.fs_stat(lazy_path) then
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

  require("lazy").setup(self.packages, {
    lockfile = lazy_lockfile_path,
    rocks = {
      root = lazy_rocks_path,
    },
    spec = {},
    install = {
      colorscheme = { "desert" },
    },
    -- Automatically check for plugin updates
    checker = {
      enabled = true,
    },
  })
end

return M

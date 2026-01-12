local default_colorscheme = "desert"

local M = {}

---@class lib.colorscheme.OnChangeEvent
---@field colorscheme string

---@class lib.colorscheme.Config
---@field on_change? fun(event: lib.colorscheme.OnChangeEvent): nil Callback function executed when colorscheme is changed.
local defaults = {
  on_change = nil,
}

--- Setup colorscheme
---@param opts? lib.colorscheme.Config
function M.setup(opts)
  opts = vim.tbl_deep_extend("force", defaults, opts or {})

  -- Initialize cache of colorscheme
  local cache = require("lib.cache").new("colorscheme")

  -- Enable 24-bit RGB color if using nvim
  if vim.fn.has("nvim") == 1 then
    vim.opt.termguicolors = true
  end

  -- Define event for colorscheme change to reset and cache it
  -- @return bool It is always false. See :h nvim_create_autocmd()
  local aug = vim.api.nvim_create_augroup("MyAutoCmdColorScheme", {})
  vim.api.nvim_create_autocmd({ "ColorSchemePre" }, {
    group = aug,
    pattern = "*",
    command = "hi clear",
  })
  vim.api.nvim_create_autocmd({ "ColorScheme" }, {
    group = aug,
    pattern = "*",
    callback = function(args)
      -- Cache colorscheme to restore it on launching neovim next time
      local colorscheme = args.match
      if vim.fn.has("vim_starting") ~= 1 then
        cache:write(colorscheme)
      end

      -- patch_colorscheme()
      if opts.on_change ~= nil then
        opts.on_change({ colorscheme = colorscheme })
      end

      return false
    end,
  })

  -- Initialize colorscheme.
  -- If cache exists, use it. Otherwise, use default colorscheme.
  vim.opt.background = "dark"
  vim.api.nvim_command("colorscheme " .. (cache:read() or default_colorscheme))
end

-- Helpers

--- Get highlight group definition
---@param name string highlight group name
function M.get_hl(name)
  local status, result = pcall(function()
    return vim.api.nvim_get_hl_by_name(name, true)
  end)
  if not status or result == nil then
    return {}
  end
  return result
end

--- Set highlight group
---@param name string highlight group name
function M.hl(name, opts)
  vim.api.nvim_set_hl(0, name, opts)
end

--- Set highlight group link
---@param name string source
---@param link_to string destination
function M.link(name, link_to)
  vim.api.nvim_set_hl(0, name, { link = link_to })
end

--- Check if highlight group is defined
---@param name string highlight group name
function M.defined(name)
  return M.get_hl(name)[true] == nil
end

return M

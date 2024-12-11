-- This plugin provides `Demo mode` to make your great editor readable by co-workers.
local M = {}

local enabled = false

-- Toggle demo mode
M.toggle = function()
  if enabled then
    enabled = false
    vim.opt.listchars = { tab = ">·", nbsp = "+", trail = "·", extends = "→", precedes = "←" }
    vim.opt.relativenumber = true
  else
    enabled = true
    vim.opt.listchars = { tab = "  ", nbsp = "+", trail = "·", extends = "→", precedes = "←" }
    vim.opt.relativenumber = false
  end
end

return M

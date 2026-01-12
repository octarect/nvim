local M = {}

-- Current status
local enabled = false

-- Enable demo mode
local function enable()
  enabled = true
  vim.opt.listchars = { tab = "  ", nbsp = "+", trail = "·", extends = "→", precedes = "←" }
  vim.opt.relativenumber = false
end

-- Disable demo mode
local function disable()
  enabled = false
  vim.opt.listchars = { tab = ">·", nbsp = "+", trail = "·", extends = "→", precedes = "←" }
  vim.opt.relativenumber = true
end

-- Toggle `Demo mode` to make your great editor readable by co-workers.
function M.toggle()
  if enabled then
    disable()
  else
    enable()
  end
end

return M

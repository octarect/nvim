local M = {}

local function set_keymap(buffer, mode, lhs, rhs, options)
  options = options or {}

  -- vim api option
  local o = {}

  -- If rhs is function, set it as callback
  local rhs0 = ""
  if type(rhs) == "function" then
    o.callback = rhs
  else
    rhs0 = rhs
  end
  -- Parse options
  for k, v in pairs(options) do
    o[k] = v
  end

  -- Set keymap
  if buffer then
    vim.api.nvim_buf_set_keymap(0, mode, lhs, rhs0, o)
  else
    vim.api.nvim_set_keymap(mode, lhs, rhs0, o)
  end
end

-- Mapper is an interface to register keymap
-- It can be called by method-chain style.
-- Example:
-- keymap.nmap():silent():noremap():set({
--   { "<Leader>f", "<Cmd>echo 'hello'<CR>", desc = "test" }
-- })
local Mapper = {}
Mapper.prototype = {
  buffer = false,
  mode = "",
  options = {},
}
function Mapper.prototype:set(keymaps)
  for _, m in ipairs(keymaps) do
    local lhs = m[1]
    local rhs = m[2]
    m[1] = nil
    m[2] = nil

    local options = vim.tbl_deep_extend("force", self.options, m)

    set_keymap(self.buffer, self.mode, lhs, rhs, options)
  end
end
function Mapper.prototype:noremap()
  self.options.noremap = true
  return self
end
function Mapper.prototype:nowait()
  self.options.nowait = true
  return self
end
function Mapper.prototype:silent()
  self.options.silent = true
  return self
end
function Mapper.prototype:script()
  self.options.script = true
  return self
end
function Mapper.prototype:expr()
  self.options.expr = true
  return self
end
function Mapper.new(buffer, mode)
  local obj = Mapper.prototype
  obj.buffer = buffer
  obj.mode = mode
  return obj
end

M.map = function()
  return Mapper.new(false, "")
end
M.nmap = function()
  return Mapper.new(false, "n")
end
M.imap = function()
  return Mapper.new(false, "i")
end
M.vmap = function()
  return Mapper.new(false, "v")
end
M.xmap = function()
  return Mapper.new(false, "x")
end
M.bmap = function()
  return Mapper.new(true, "")
end
M.bnmap = function()
  return Mapper.new(true, "n")
end
M.bimap = function()
  return Mapper.new(true, "i")
end
M.bvmap = function()
  return Mapper.new(true, "v")
end
M.bxmap = function()
  return Mapper.new(true, "x")
end

return M

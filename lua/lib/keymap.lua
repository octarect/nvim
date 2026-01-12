--- A helper module for setting keymaps in Neovim.
--- @class lib.keymap
local keymap = {}
keymap.__index = keymap

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

--- Set keymaps
--- @param keymaps table A list of keymaps, each keymap is a table with the following structure:
---   { lhs, rhs, [options] }
---   where:
---   - lhs: The left-hand side of the keymap (the key combination to trigger)
---   - rhs: The right-hand side of the keymap (the command or function to execute)
---   - options: Optional table of options for the keymap, such as noremap, silent, etc.
--- @return nil
function keymap:set(keymaps)
  for _, m in ipairs(keymaps) do
    local lhs = m[1]
    local rhs = m[2]
    m[1] = nil
    m[2] = nil

    local options = vim.tbl_deep_extend("force", self.options, m)

    set_keymap(self.buffer, self.mode, lhs, rhs, options)
  end
end

--- Enable noremap option.
--- @return self
function keymap:noremap()
  self.options.noremap = true
  return self
end
--- Enable nowait option.
--- @return self
function keymap:nowait()
  self.options.nowait = true
  return self
end
--- Enable silent option.
--- @return self
function keymap:silent()
  self.options.silent = true
  return self
end
--- Enable script option.
--- @return self
function keymap:script()
  self.options.script = true
  return self
end
--- Enable expr option.
--- @return self
function keymap:expr()
  self.options.expr = true
  return self
end

--- Create an instance of keymap
--- @param buffer boolean If true, set keymap for buffer-local
--- @param mode string The mode of keymap, e.g. "n", "i", "v", "x", etc.
--- @return lib.keymap
function keymap.new(buffer, mode)
  local self = setmetatable({
    buffer = buffer,
    mode = mode,
    options = {},
  }, keymap)
  return self
end

function keymap.map()
  return keymap.new(false, "")
end
function keymap.nmap()
  return keymap.new(false, "n")
end
function keymap.imap()
  return keymap.new(false, "i")
end
function keymap.vmap()
  return keymap.new(false, "v")
end
function keymap.xmap()
  return keymap.new(false, "x")
end
function keymap.tmap()
  return keymap.new(false, "t")
end
function keymap.bmap()
  return keymap.new(true, "")
end
function keymap.bnmap()
  return keymap.new(true, "n")
end
function keymap.bimap()
  return keymap.new(true, "i")
end
function keymap.bvmap()
  return keymap.new(true, "v")
end
function keymap.bxmap()
  return keymap.new(true, "x")
end
function keymap.btmap()
  return keymap.new(true, "t")
end

return keymap

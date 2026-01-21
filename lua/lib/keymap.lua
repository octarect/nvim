--- A helper module for setting keymaps in Neovim.

---@alias lib.keymap.mode ""|"n"|"i"|"v"|"x"|"t" The mode of keymap

---@class lib.keymap
---@field buffer boolean If true, set keymap for buffer-local
---@field mode table<lib.keymap.mode, boolean>
---@field options vim.api.keyset.keymap
local keymap = {}
keymap.__index = keymap

--- Constructor of lib.keymap
---@return lib.keymap
function keymap.new()
  return setmetatable({
    buffer = false,
    modes = {},
    options = {},
  }, keymap)
end

--- Set buffer-local keymap
---@return lib.keymap
function keymap:buf()
  self.buffer = true
  return self
end

--- Set mode
---@param mode string
---@return lib.keymap
function keymap:set_mode(mode)
  self.modes[mode] = true
  return self
end

---@alias lib.keymap.lhs string

---@alias lib.keymap.rhs lib.keymap.rhs_simple|lib.keymap.rhs_table

---@alias lib.keymap.rhs_simple string

---@class lib.keymap.rhs_table
---@field [1] string|function RHS
---@field [2] vim.api.keyset.keymap?

---@param keymaps table<lib.keymap.lhs, lib.keymap.rhs>
---@return lib.keymap
function keymap:set(keymaps)
  for lhs, def in pairs(keymaps) do
    local rhs0 = ""
    local o = {}

    if type(def) == "string" then
      rhs0 = def
    else
      local rhs = def[1]
      local o0 = def[2] or {}

      o = vim.tbl_deep_extend("force", self.options, o0)

      -- If rhs is function, set it as callback
      if type(rhs) == "function" then
        o.callback = rhs
      else
        rhs0 = rhs
      end
    end

    for m, _ in pairs(self.modes) do
      if buffer then
        vim.api.nvim_buf_set_keymap(0, m, lhs, rhs0, o)
      else
        vim.api.nvim_set_keymap(m, lhs, rhs0, o)
      end
    end
  end
end

---@return lib.keymap
function keymap:noremap()
  self.options.noremap = true
  return self
end

---@return lib.keymap
function keymap:nowait()
  self.options.nowait = true
  return self
end

---@return lib.keymap
function keymap:silent()
  self.options.silent = true
  return self
end
---@return lib.keymap
function keymap:script()
  self.options.script = true
  return self
end
---@return lib.keymap
function keymap:expr()
  self.options.expr = true
  return self
end

---@return lib.keymap
function keymap.map()
  return keymap.new():set_mode("")
end

---@return lib.keymap
function keymap.nmap()
  return keymap.new():set_mode("n")
end

---@return lib.keymap
function keymap.imap()
  return keymap.new():set_mode("i")
end

---@return lib.keymap
function keymap.vmap()
  return keymap.new():set_mode("v")
end

---@return lib.keymap
function keymap.xmap()
  return keymap.new():set_mode("x")
end

---@return lib.keymap
function keymap.tmap()
  return keymap.new():set_mode("t")
end

return keymap

--- Terminal
--- @class lib.terminal
--- @field private config lib.terminal.Config
--- @field private bunfr number Cache the previously opened terminal buffer number
local terminal = {}
terminal.__index = terminal

--- @alias lib.terminal.CallbackFunc fun(bufnr: number)

--- @class lib.terminal.Config
--- @field height_ratio number
--- @field min_height number
--- @field on_create? lib.terminal.CallbackFunc Event handler when terminal is created

--- Initialize a terminal
--- @param cfg lib.terminal.Config
--- @return lib.terminal
function terminal.new(cfg)
  cfg.on_create = cfg.on_create or function() end
  local self = setmetatable({
    bufnr = -1,
    config = cfg,
  }, terminal)
  return self
end

--- Open terminal
--- @param direction "vertical"|"horizontal"|nil
function terminal:open(direction)
  if direction == "vertical" then
    vim.cmd("vs | vertical resize -5")
  elseif direction == "horizontal" then
    -- Open the buffer with N % of current buffer
    local height =
      math.max(self.config.min_height, math.floor(vim.api.nvim_win_get_height(0) * self.config.height_ratio))
    vim.cmd("botright new | set winfixheight | resize " .. height)
  end

  -- Check if the buffer still exists
  if self.bufnr ~= -1 and vim.api.nvim_buf_is_valid(self.bufnr) then
    vim.cmd("b " .. self.bufnr)
    return
  end

  vim.fn.jobstart(vim.o.shell, {
    term = true,
    on_exit = function()
      self.bufnr = -1
    end,
  })
  self.bufnr = vim.fn.bufnr()
  self.config.on_create(self.bufnr)
end

return terminal

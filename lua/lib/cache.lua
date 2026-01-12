---@class lib.cache
---@field cache_path string
local cache = {}
cache.__index = cache

--- Initalize a new persistence data.
---@param key string cache key
---@return lib.cache
function cache.new(key)
  if not key then
    error("required argument 'key' is missing")
  end
  local self = setmetatable({
    cache_path = vim.fn.stdpath("cache") .. "/values/" .. key,
  }, cache)
  return self
end

--- Read the value from the cache
---@return string|nil
function cache:read()
  local f = io.open(self.cache_path, "r")
  if not f then
    return nil
  end
  local value = f:read("a")
  f:close()
  return value
end

--- Write the value to the cache
--- true if write was successful, false otherwise
---@param value string The value to write
---@return boolean
function cache:write(value)
  if not value then
    error("required argument 'value' is missing")
  end

  -- Ensure the cache directory exists
  local dirname = vim.fn.expand(self.cache_path .. ":h")
  if vim.fn.isdirectory(dirname) ~= 1 then
    os.execute("mkdir -p " .. dirname)
  end

  -- Write the value to the cache file
  local f, err = io.open(self.cache_path, "w")
  if not f then
    error(string.format("failed to open cache_path: %s", err))
    return false
  end
  f:write(value)
  f:close()

  return true
end

return cache

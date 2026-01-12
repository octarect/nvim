local config = require("config.vars")

local cache_dir_path = config.cache_path .. "/cached-values"

--- Return the path to the cache file
--- @param key string The cache key
--- @return string
local function cache_file_path(key)
  return cache_dir_path .. "/" .. key
end

--- @class lib.cache
--- @field key string
local cache = {}
cache.__index = cache

--- Initalize a new persistence data.
--- @param key string The key of data
--- @return lib.cache
function cache.new(key)
  if not key then
    error("required argument 'key' is missing")
  end
  local self = setmetatable({ key = key }, cache)
  return self
end

--- Read the value from the cache
--- @return string|nil
function cache:read()
  local f = io.open(cache_file_path(self.key), "r")
  if not f then
    return nil
  end
  local value = f:read("a")
  f:close()
  return value
end

--- Write the value to the cache
--- true if write was successful, false otherwise
--- @param value string The value to write
--- @return boolean
function cache:write(value)
  if not value then
    error("required argument 'value' is missing")
  end

  -- Ensure the cache directory exists
  if vim.fn.isdirectory(cache_dir_path) ~= 1 then
    os.execute("mkdir -p " .. cache_dir_path)
  end

  -- Write the value to the cache file
  local f, err = io.open(cache_file_path(self.key), "w")
  if not f then
    error(string.format("failed to open cache_file_path: %s", err))
    return false
  end
  f:write(value)
  f:close()

  return true
end

return cache

local pkg = require("lib.pkg")

local def_path = vim.fn.stdpath("config") .. "/lua/packages"

local init_paths = vim.split(vim.fn.globpath(def_path, "**/init.lua"), "\n")
for _, ipath in ipairs(init_paths) do
  local modname = string.match(ipath, "lua/(.+)/init%.lua$")

  -- Reload if the module has already loaded.
  if package.loaded[modname] ~= nil then
    package.loaded[modname] = nil
  end
  require(modname)
end

pkg:load()

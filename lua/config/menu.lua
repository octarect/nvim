---@class config.menu.Item
---@field [1] string Label/Title
---@field [2] string|fun(): nil Command to execute or function to call
---@field [3]? string[] Tags

---@class config.menu
---@field items config.menu.Item[]
---@field prompt string
---@field format_item fun(item: config.menu.Item): string
---@field on_choice fun(choice: string, idx: integer)
return {
  -- stylua: ignore
  items = {
    { "🏪Manage Plugins", "Lazy" },
    { "📚Manage LSP Servers", "Mason" },
    { "💡Show LSP info", "LspInfo" },
    { "🈺Toggle Demo Mode", function() require("lib.demomode").toggle() end },
    { "🤖💬CopilotChat", "CopilotChatToggle", {"ai"} },
  },
  prompt = "Menu",
  format_item = function(item)
    if item[3] ~= nil then
      return item[1] .. " [" .. table.concat(item[3], ",") .. "]"
    else
      return item[1]
    end
  end,
  on_choice = function(choice, _)
    if not choice then
      return
    end
    local action = choice[2]
    if type(action) == "string" then
      vim.cmd(action)
    elseif type(action) == "function" then
      action()
    end
  end,
}

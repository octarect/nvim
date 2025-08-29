local keymap = require("core.utils.keymap")

local menu_items = {
  -- Plugin Management
  { "🛠️Manage plugins", "Lazy" },
  { "📚Show LSP info", "LspInfo" },
  { "💻Manage LSP servers", "Mason" },
  -- Colorscheme
  { "🌈Change colorscheme", "Telescope colorscheme theme=dropdown" },
  -- Vim
  { " List open buffers", "Telescope buffers" },
  { " List available commands", "Telescope commands" },
  { " List tags in current directory", "Telescope tags" },
  { " List marks", "Telescope marks" },
  { " List jumplist", "Telescope jumplist" },
  { " List command history", "Telescope command_history theme=ivy" },
  { " List search history", "Telescope search_history theme=ivy" },
  { " List registers (Paste yanked string)", "Telescope registers" },
  { " List vim autocommands", "Telescope autocommands" },
  { " Open filetype menu", "Telescope filetype" },
  { " Show vim options", "Telescope vim_options" },
  { "🎮List keymaps (keymappings)", "Telescope keymaps" },
  -- Code Actions
  { "🪄[AI] Ask copilot", [[ CopilotChat ]] },
  { "🪄[AI] Explain code", [[ CopilotChatExplain ]] },
  { "🪄[AI] Review", [[ CopilotChatReview ]] },
  { "🪄[AI] Fix", [[ CopilotChatFix ]] },
  { "🪄[AI] Optimize", [[ CopilotChatOptimize ]] },
  { "🪄[AI] Docs", [[ CopilotChatDocs ]] },
  { "🪄[AI] Tests", [[ CopilotChatTests ]] },
  { "🪄[AI] Commit", [[ CopilotChatCommit ]] },
  -- Misc
  {
    "🔭Notification History",
    function()
      require("telescope").extensions.notify.notify()
    end,
  },
  {
    "🔁Toggle demo mode",
    function()
      require("core.actions.demomode").toggle()
    end,
  },
}

local function format_item(item)
  return item[1]
end

local function handler(item, _)
  -- If q or <ESC> is pressed, item is nil.
  if item == nil then
    return
  end

  local action = item[2]
  if type(action) == "function" then
    action()
  else
    vim.api.nvim_exec2(action, {
      output = true,
    })
  end
end

-- ExCommand
vim.api.nvim_create_user_command(
  "OpenMenu",
  function()
    vim.api.nvim_exec_autocmds("User", {
      pattern = "MenuOpen",
      data = {},
    })
    vim.ui.select(menu_items, { format_item = format_item }, handler)
  end,
  {
    desc = "Open menu"
  }
)

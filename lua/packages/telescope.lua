-- Cache the last opened path for file_browser.
-- Initialize with the current working directory.
local last_opened_path = vim.loop.cwd()

local function picker_caller(picker_name, opts)
  opts = opts or {}

  -- Pull out the value `theme` from `opts`
  local theme = opts.theme
  opts.theme = nil

  return function()
    local ss = vim.split(picker_name, "/")
    local kind = ss[1]
    local basename = ss[2]
    local picker
    if kind == "builtin" then
      picker = require("telescope.builtin")[basename]
    else
      picker = require("telescope").extensions[kind][basename]
    end
    if theme == nil then
      picker(opts)
    else
      picker(require("telescope.themes")["get_" .. theme](opts))
    end
  end
end

return {
  {
    "nvim-telescope/telescope.nvim",
    module = "telescope",
    cmd = "Telescope",
    init = function()
      local keymap = require("core.utils.keymap")
      keymap.nmap():silent():noremap():set({
        { "<Leader>df", picker_caller("builtin/git_files"), desc = "List files (Git)" },
        { "<Leader>dF", picker_caller("builtin/find_files"), desc = "List files (All)" },
        { "<Leader>dg", picker_caller("builtin/live_grep"), desc = "Grep" },
        { "<Leader>db", picker_caller("builtin/buffers"), desc = "List buffers" },
        { "<Leader>dc", picker_caller("builtin/colorscheme", { theme = "dropdown" }), desc = "Change colorscheme" },
        { "<Leader>dm", picker_caller("menu/default", { theme = "dropdown" }), desc = "List menus" },
        {
          "<Leader>f",
          function()
            require("telescope").extensions.file_browser.file_browser({ path = last_opened_path })
          end,
          desc = "Browse files",
        },
      })
    end,
    config = function()
      local actions = require("telescope.actions")
      local config = require("core.config")

      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<C-u>"] = false,
              -- Open file in horizontal by <C-s> instead of <C-x>
              ["<C-x>"] = false,
              ["<C-s>"] = actions.file_split,
              -- Open file in new tab. (Disable tmux prefix <C-t>)
              ["<C-t>"] = false,
            },
            n = {
              ["<esc>"] = actions.close,
              ["<space>"] = actions.toggle_selection,
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_better,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            },
          },
          winblend = 20,
          borderchars = (function()
            local b = config.window.border
            return { b[2], b[4], b[6], b[8], b[1], b[3], b[5], b[7] }
          end)(),
          color_devicons = true,
        },
        pickers = {
          buffers = {
            mappings = {
              i = {
                ["<C-d>"] = actions.delete_buffer,
              },
              n = {
                ["<C-d>"] = actions.delete_buffer,
              },
            },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          file_browser = (function()
            local fb_actions = require("telescope").extensions.file_browser.actions
            local stateful = function(fb_action)
              return function(bufnr, bypass)
                fb_action(bufnr, bypass)

                local action_state = require("telescope.actions.state")
                local current_picker = action_state.get_current_picker(bufnr)
                local finder = current_picker.finder
                -- When you open file_browser picker, you can start from the last opened path.
                last_opened_path = finder.path
              end
            end
            return {
              initial_mode = "normal",
              mappings = {
                n = {
                  l = stateful(actions.select_default),
                  c = fb_actions.copy,
                  m = fb_actions.move,
                  r = fb_actions.rename,
                  N = fb_actions.create,
                  h = stateful(fb_actions.goto_parent_dir),
                  H = stateful(fb_actions.goto_cwd),
                  ["."] = fb_actions.toggle_hidden,
                },
              },
            }
          end)(),
          menu = {
            default = {
              items = {
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
              },
            },
          },
        },
      })
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("menu")
      require("telescope").load_extension("file_browser")
      require("telescope").load_extension("notify")
    end,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-tree/nvim-web-devicons" },
      { "nvim-telescope/telescope-symbols.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      { "nvim-telescope/telescope-file-browser.nvim" },
      { "octarect/telescope-menu.nvim" },
    },
  },
}

local mapfuncs = {}
local mapfuncs_cnt = 0
local last_opened_path = vim.loop.cwd()

-- Create a dedicated function for mapping, and return a command to call it.
-- @param picker_name Picker name. ex) "builtin/find_files"
-- @param opts Picker options. The following keys are added for this function;
-- theme: Pass theme function if you want to use a theme. Default is nil (no theme)
local function get_picker_cmd(picker_name, opts)
  opts = opts or {}

  local theme = opts.theme
  opts.theme = nil

  mapfuncs_cnt = mapfuncs_cnt + 1
  local i = mapfuncs_cnt

  mapfuncs[i] = function()
    -- NOTE: require the root module before loading its children (and trigger on_lua)
    if not package.loaded["telescope"] then
      require("telescope")
    end

    local picker
    local picker_paths = vim.split(picker_name, "/")

    if picker_paths[1] == "builtin" then
      picker = require("telescope.builtin")[picker_paths[2]]
    else
      picker = require("telescope").extensions[picker_paths[1]][picker_paths[2]]
    end

    if theme == nil then
      picker(opts)
    else
      picker(require("telescope.themes")["get_" .. theme](opts))
    end
  end

  return string.format('<cmd>lua require("packages.ui.telescope").mapfuncs[%d]()<CR>', i)
end

local function set_keymaps()
  local keymap = require("lib.keymap")
  keymap.nmap():silent():noremap():set({
    {
      "<Leader>df",
      get_picker_cmd("builtin/git_files"),
      desc = "List files (Git)",
    },
    {
      "<Leader>dF",
      get_picker_cmd("builtin/find_files"),
      desc = "List files (All)",
    },
    {
      "<Leader>dg",
      get_picker_cmd("builtin/live_grep"),
      desc = "Grep",
    },
    {
      "<Leader>db",
      get_picker_cmd("builtin/buffers"),
      desc = "List buffers",
    },
    {
      "<Leader>dc",
      get_picker_cmd("builtin/colorscheme", { theme = "dropdown" }),
      desc = "Change colorscheme",
    },
    {
      "<Leader>ds",
      get_picker_cmd("builtin/treesitter"),
      desc = "List treesitter symbols",
    },
    {
      "<Leader>dk",
      get_picker_cmd("builtin/keymaps"),
      desc = "List keymaps",
    },
    -- telescope-symbols.nvim
    {
      "<Leader>de",
      get_picker_cmd("builtin/symbols", { theme = "cursor" }),
      desc = "Insert emoji",
    },
    -- telescope-menu.nvim
    {
      "<Leader>dm",
      get_picker_cmd("menu/menu", { theme = "dropdown" }),
      desc = "Open global menu",
    },
    {
      "<Leader>d.",
      get_picker_cmd("menu/filetype", { theme = "dropdown" }),
      desc = "Open filetype-specific menu",
    },
    {
      "<Leader>dd",
      get_picker_cmd("menu/cursor", { theme = "cursor" }),
      desc = "Open cursor menu",
    },
    -- telescope-file-browser.nvim
    {
      "<Leader>f",
      function()
        require("telescope").extensions.file_browser.file_browser({ path = last_opened_path })
      end,
      desc = "Browse files",
    },
  })
end

local function init()
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
      menu = {
        default = {
          items = {
            -- Plugin Management
            { "⚙️ Manage plugins", "Lazy" },
            { "⚙️ Show LSP info", "LspInfo" },
            { "⚙️ Manage LSP servers", "Mason" },
            -- Colorscheme
            { "🌈Change colorscheme", "Telescope colorscheme theme=dropdown" },
            -- File browsing
            { "📁Browse files", "Telescope find_files" },
            { "📁Browse files in Git Repository", "Telescope git_files" },
            { "🔍Search in current directory (live_grep)", "Telescope live_grep" },
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
            -- Emoji
            { "😀Insert emoji", [[ lua require"telescope.builtin".symbols{ sources = {"emoji", "gitmoji"} } ]] },
            { "😀Insert emoji (Nerd Fonts)", [[ lua require"telescope.builtin".symbols{ sources = {"nerd"} } ]] },
            { "😀Insert emoji (kaomoji)", [[ lua require"telescope.builtin".symbols{ sources = {"kaomoji"} } ]] },
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
                require("internal.demomode").toggle()
              end,
            },
          },
        },
        cursor = {
          items = {
            { "🔍Search for the current word", "Telescope grep_string" },
            { "📚Spell suggestions", "Telescope spell_suggest" },
            { " Paste", "Telescope registers" },
            { "😀Insert emoji", [[ lua require"telescope.builtin".symbols{ sources = {"emoji", "gitmoji"} } ]] },
            { "😀Insert emoji (Nerd Fonts)", [[ lua require"telescope.builtin".symbols{ sources = {"nerd"} } ]] },
            { "😀Insert emoji (kaomoji)", [[ lua require"telescope.builtin".symbols{ sources = {"kaomoji"} } ]] },
            {
              " Git: Blame line",
              function()
                require("gitsigns").blame_line({ full = true })
              end,
            },
            {
              " Git: Preview hunk",
              function()
                require("gitsigns").preview_hunk()
              end,
            },
          },
        },
        filetype = {
          lua = {
            items = {
              { display = "Format", value = "!stylua %" },
            },
          },
          markdown = {
            items = {
              { "✨Format table", "TableFormat" },
              { "🚩Increase headers", "HeaderIncrease" },
              { "🚩Decrease headers", "HeaderDecrease" },
              { "🚩Convert Setex headers to Atx", "SetexToAtx" },
              { "📖Table of contents", "Toch" },
            },
          },
        },
      },
      file_browser = (function()
        local fb_actions = require("telescope").extensions.file_browser.actions
        local stateful = function(fb_action)
          return function(bufnr, bypass)
            fb_action(bufnr, bypass)

            local action_state = require("telescope.actions.state")
            local current_picker = action_state.get_current_picker(bufnr)
            local finder = current_picker.finder
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
    },
  })
  require("telescope").load_extension("fzf")
  require("telescope").load_extension("menu")
  require("telescope").load_extension("file_browser")
  require("telescope").load_extension("notify")
end

return {
  set_keymaps = set_keymaps,
  init = init,
  mapfuncs = mapfuncs,
}

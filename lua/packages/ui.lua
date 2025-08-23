local config = require("core.config")

local get_sections = function(active)
  local sections = {
    lualine_a = { "mode" },
    lualine_b = { "filename" },
    lualine_c = {},
    lualine_x = { "diagnostics", "diff", "branch", "fileformat", "encoding", "filetype" },
    lualine_y = { "searchcount", "progress" },
    lualine_z = { "location" },
  }
  if not active then
    sections.lualine_a = {}
  end
  return sections
end

return {
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        icons_enabled = true,
        theme = "material",
        component_separators = { left = "", right = "|" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 100,
          tabline = 100,
          winbar = 100,
        },
      },
      sections = get_sections(true),
      inactive_sections = get_sections(false),
      tabline = {
        lualine_a = {
          { "filetype", colored = false, icon_only = true },
          "filename",
        },
        lualine_b = {
          -- The following component will be enabled after loading nvim-navic
          {
            function()
              return require("nvim-navic").get_location()
            end,
            cond = function()
              return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
            end,
          },
        },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {
          { "tabs", mode = 2 },
        },
      },
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    },
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      { "SmiteshP/nvim-navic" },
    },
  },
  {
    "SmiteshP/nvim-navic",
    opts = {
      icons = {
        File = " ",
        Module = " ",
        Namespace = " ",
        Package = " ",
        Class = " ",
        Method = " ",
        Property = " ",
        Field = " ",
        Constructor = " ",
        Enum = "練",
        Interface = "練",
        Function = " ",
        Variable = " ",
        Constant = " ",
        String = " ",
        Number = " ",
        Boolean = "◩ ",
        Array = " ",
        Object = " ",
        Key = " ",
        Null = "ﳠ ",
        EnumMember = " ",
        Struct = " ",
        Event = " ",
        Operator = " ",
        TypeParameter = " ",
      },
      highlight = false,
      separator = " > ",
      depth_limit = 0,
      depth_limit_indicator = "..",
      safe_output = true,
    },
  },
  -- Git integration
  {
    "lewis6991/gitsigns.nvim",
    event = "BufEnter */*",
    config = function(_, opts)
      local gitsigns = require("gitsigns")
      gitsigns.setup(opts)

      local keymap = require("core.utils.keymap")
      keymap.nmap():silent():set({
        { "[c", gitsigns.prev_hunk, desc = "Jump to previous git hunk" },
        { "]c", gitsigns.next_hunk, desc = "Jump to next git hunk" },
      })
    end,
    opts = {
      signs = {
        add = { text = "█" },
        change = { text = "█" },
        delete = { text = "█" },
        topdelete = { text = "█" },
        changedelete = { text = "█" },
        untracked = { text = "█" },
      },
      signcolumn = true,
      numhl = true,
      linehl = false,
      word_diff = false,
      watch_gitdir = {
        interval = 1000,
        follow_files = true,
      },
      attach_to_untracked = true,
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 1000,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = "<author>, <author_time:%F> - <summary>",
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil,
      max_file_length = 5000, -- Disable if file is longer than this (in lines)
      preview_config = {
        -- Options passed to nvim_open_win
        border = config.window.border,
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
    },
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
    },
  },
  -- Notification
  {
    "rcarriga/nvim-notify",
    opts = {
      fps = 30,
      icons = {
        DEBUG = "",
        ERROR = "😷",
        INFO = "📢",
        TRACE = "🚓",
        WARN = "🔥",
      },
      timeout = 3000,
    },
    config = function(_, opts)
      require("notify").setup(opts)
      vim.notify = require("notify")
    end,
  },
}

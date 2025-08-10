local pkg = require("external.lazy")

pkg:add({}, {
  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("packages.ui.lualine")
    end,
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
    },
  },

  -- Git integration
  {
    "lewis6991/gitsigns.nvim",
    event = "BufEnter */*",
    config = function()
      require("packages.ui.gitsigns")
    end,
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
    },
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    module = "telescope",
    cmd = "Telescope",
    init = function()
      require("packages.ui.telescope").set_keymaps()
    end,
    config = function()
      require("packages.ui.telescope").init()
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

  -- Terminal
  {
    "akinsho/toggleterm.nvim",
    keys = { "<Leader>t", desc = "Open terminal" },
    config = function()
      require("packages.ui.toggleterm")
    end,
  },

  -- Notification
  {
    "rcarriga/nvim-notify",
    config = function()
      vim.notify = require("notify")
      vim.notify.setup({
        fps = 30,
        icons = {
          DEBUG = "",
          ERROR = "😷",
          INFO = "📢",
          TRACE = "🚓",
          WARN = "🔥",
        },
        timeout = 3000,
      })
    end,
  },
})

pkg:add({
  lazy = false,
  priority = 999,
}, {
  -- Colorschemes
  { "tomasr/molokai" },
  {
    "rhysd/vim-color-spring-night",
    config = function()
      vim.g.spring_night_high_contrast = 1
      vim.g.spring_night_highlight_terminal = 1
      vim.g.spring_night_cterm_italic = 1
    end,
  },
  {
    "nvimdev/oceanic-material",
    config = function()
      vim.g.oceanic_material_allow_bold = 1
      vim.g.oceanic_material_allow_italic = 1
    end,
  },
})

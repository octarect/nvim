local pkg = require("lib.pkg")

pkg:add({}, {
  {
    "hrsh7th/nvim-cmp",
    version = false,
    event = { "InsertEnter" },
    config = function()
      require("packages.edit.nvim-cmp")
    end,
    dependencies = {
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-cmdline" },
      { "hrsh7th/cmp-emoji" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-path" },
      { "ray-x/cmp-treesitter" },
      {
        "onsails/lspkind-nvim",
        config = function()
          require("packages.edit.lspkind")
        end,
      },
      {
        "zbirenbaum/copilot-cmp",
        dependencies = {
          { "zbirenbaum/copilot.lua" },
        },
        config = function()
          require("copilot_cmp").setup()
        end,
      },
    },
  },
  {
    "scrooloose/nerdcommenter",
    event = { "LazyFile" },
    init = function()
      vim.g.NERDSpaceDelims = 1
      vim.g.NERDDefaultAlign = "left"
      vim.g.NERDCompactSexyComs = 1
      local keymap = require("lib.keymap")
      keymap.nmap():silent():set({
        { "co", "<Plug>NERDCommenterToggle", desc = "Toggle comment"},
      })
      keymap.vmap():silent():set({
        { "co", "<Plug>NERDCommenterToggle", desc = "Toggle comment" },
      })
    end,
  },

  -- matchparen
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup()
    end,
  },
  {
    "utilyre/sentiment.nvim",
    event = "VeryLazy",
    version = "*",
    opts = {},
    init = function()
      vim.g.loaded_matchparen = 1
    end,
  },

  -- cursorword
  {
    "RRethy/vim-illuminate",
    event = { "LazyFile" },
  },

  {
    "junegunn/vim-easy-align",
    cmd = "EasyAlign",
    init = function()
      local keymap = require("lib.keymap")
      keymap.vmap():noremap():set({
        { "<CR>", ":EasyAlign<CR>", desc = "Align selection" },
      })
    end,
  },
  {
    "rainbowhxch/accelerated-jk.nvim",
    module = "accelerated-jk",
    init = function()
      local keymap = require("lib.keymap")
      local accelerated_move = function(movement)
        return function()
          require("accelerated-jk").move_to(movement)
        end
      end
      keymap.nmap():silent():set({
        { "j", accelerated_move("j"), desc = "Move down (accelerated)" },
        { "k", accelerated_move("k"), desc = "Move up (accelerated)" },
      })
    end,
  },
})

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
      { "onsails/lspkind-nvim" },
    },
  },
  {
    "scrooloose/nerdcommenter",
    keys = { "<Plug>NERDCom" },
    init = function()
      vim.g.NERDSpaceDelims = 1
      vim.g.NERDDefaultAlign = "left"
      vim.g.NERDCompactSexyComs = 1
      local keymap = require("lib.keymap")
      keymap.nmap({
        { "co", "<Plug>NERDCommenterToggle", { keymap.flags.silent } },
      })
      keymap.vmap({
        { "co", "<Plug>NERDCommenterToggle", { keymap.flags.silent } },
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
    event = { "BufNewFile", "BufReadPre", "BufWritePre" },
  },

  {
    "junegunn/vim-easy-align",
    cmd = "EasyAlign",
    init = function()
      local keymap = require("lib.keymap")
      keymap.vmap({
        { "<CR>", ":EasyAlign<CR>", { keymap.flags.silent, keymap.flags.noremap } },
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
      keymap.nmap({
        { "j", accelerated_move("j"), { keymap.flags.silent } },
        { "k", accelerated_move("k"), { keymap.flags.silent } },
      })
    end,
  },
})

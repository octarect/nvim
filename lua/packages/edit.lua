return {
  -- Syntax
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context",
    },
    event = { "LazyFile" },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
    opts = {
      -- Install parsers automatically
      ensure_installed = {
        "bash",
        "c",
        "c_sharp",
        "clojure",
        "cmake",
        "commonlisp",
        "cpp",
        "css",
        "csv",
        "diff",
        "dockerfile",
        "elixir",
        "erlang",
        "gitcommit",
        "gitignore",
        "go",
        "gomod",
        "graphql",
        "haskell",
        "html",
        "java",
        "jq",
        "json",
        "lua",
        "luadoc",
        "make",
        "nginx",
        "perl",
        "php",
        "python",
        "r",
        "ruby",
        "rust",
        "scala",
        "scss",
        "sql",
        "toml",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },
      highlight = {
        enable = true,
        disable = {},
      },
    },
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = { "LazyFile" },
    dependencies = {
      { "nvim-treesitter/nvim-treesitter" },
    },
  },

  -- Comment
  {
    "scrooloose/nerdcommenter",
    event = { "LazyFile" },
    init = function()
      vim.g.NERDSpaceDelims = 1
      vim.g.NERDDefaultAlign = "left"
      vim.g.NERDCompactSexyComs = 1

      local keymap = require("core.utils.keymap")
      keymap.nmap():silent():set({
        { "co", "<Plug>NERDCommenterToggle", desc = "Toggle comment" },
      })
      keymap.vmap():silent():set({
        { "co", "<Plug>NERDCommenterToggle", desc = "Toggle comment" },
      })
    end,
  },

  -- Matchparen
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },
  {
    "utilyre/sentiment.nvim",
    version = "*",
    event = "VeryLazy",
    init = function()
      vim.g.loaded_matchparen = 1
    end,
    opts = {},
  },

  -- Formatting
  {
    "junegunn/vim-easy-align",
    cmd = "EasyAlign",
    init = function()
      local keymap = require("core.utils.keymap")
      keymap.vmap():noremap():set({
        { "<CR>", ":EasyAlign<CR>", desc = "Align selection" },
      })
    end,
  },
}

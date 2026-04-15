return {
  -- Syntax
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context",
    },
    lazy = false,
    init = function()
      -- Check if tree-sitter-cli is installed
      if vim.fn.executable("tree-sitter") ~= 1 then
        vim.api.nvim_create_autocmd("VimEnter", {
          once = true,
          callback = function(_)
            vim.notify("[[nvim-treesitter]] tree-sitter-cli is not found. Please install it.", vim.log.levels.WARN)
          end,
        })
        return
      end

      -- Install parsers automatically
      local ensure_installed = {
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
      }
      local already_installed = require("nvim-treesitter.config").get_installed()
      local not_installed = vim.iter(ensure_installed):filter(function(parser)
        return not vim.tbl_contains(already_installed, parser)
      end):totable()
      require("nvim-treesitter").install(not_installed)
    end,
    opts = {
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

      local keymap = require("lib.keymap")
      keymap.nmap():silent():set({
        ["co"] = { "<Plug>NERDCommenterToggle", desc = "Toggle Comment" },
      })
      keymap.vmap():silent():set({
        ["co"] = { "<Plug>NERDCommenterToggle", desc = "Toggle Comment" },
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
      local keymap = require("lib.keymap")
      keymap.vmap():noremap():set({
        ["<CR>"] = { "<Cmd>EasyAlign<CR>", desc = "Align Selection" },
      })
    end,
  },
}

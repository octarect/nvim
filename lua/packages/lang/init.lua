local pkg = require("lib.pkg")

pkg:add({}, {
  -- LSP
  {
    "neovim/nvim-lspconfig",
    event = { "BufNewFile", "BufReadPre", "BufWritePre" },
    config = function()
      require("packages.lang.lspconfig")
    end,
    dependencies = {
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
      -- Used by lualine
      {
        "SmiteshP/nvim-navic",
        config = function()
          require("packages.lang.nvim-navic")
        end,
      },
      -- Integrate LSP into completion
      { "hrsh7th/cmp-nvim-lsp" },
    },
  },

  -- Syntax
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufNewFile", "BufReadPre", "BufWritePre" },
    config = function()
      require("packages.lang.treesitter")
    end,
    build = ":TSUpdate",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-context" },
    },
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = { "LazyFile" },
  },
})

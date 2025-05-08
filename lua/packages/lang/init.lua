local pkg = require("lib.pkg")

pkg:add({}, {
  -- LSP
  {
    "neovim/nvim-lspconfig",
    event = { "LazyFile" },
    config = function()
      require("packages.lang.lspconfig")
    end,
    dependencies = {
      { "mason-org/mason.nvim" },
      { "mason-org/mason-lspconfig.nvim" },
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
  {
    "nvimdev/lspsaga.nvim",
    event = { "LspAttach" },
    init = function()
      local keymap = require("lib.keymap")
      keymap.nmap():silent():noremap():set({
        {
          "[d",
          "<cmd>Lspsaga diagnostic_jump_prev<CR>",
          desc = "Jump to the previous diagnostic",
        },
        {
          "]d",
          "<cmd>Lspsaga diagnostic_jump_next<CR>",
          desc = "Jump to the next diagnostic",
        },
        {
          "<LocalLeader>h",
          "<cmd>Lspsaga hover_doc<CR>",
          desc = "LSP hover",
        },
        {
          "<LocalLeader>d",
          "<cmd>Lspsaga peek_definition<CR>",
          desc = "LSP definition",
        },
        {
          "<LocalLeader>D",
          "<cmd>Lspsaga peek_type_definition<CR>",
          desc = "LSP type_definition",
        },
        {
          "<LocalLeader>r",
          "<cmd>Lspsaga rename<CR>",
          desc = "LSP rename",
        },
        {
          "<LocalLeader>a",
          "<cmd>Lspsaga code_action<CR>",
          desc = "LSP code_action",
        },
        {
          "<LocalLeader>j",
          "<cmd>Lspsaga outline<CR>",
          desc = "Show outline of the current file",
        },
      })
    end,
    config = function()
      require("lspsaga").setup({
        ui = {
          border = {
            { "+", "FloatBorder" },
            { "-", "FloatBorder" },
            { "+", "FloatBorder" },
            { "|", "FloatBorder" },
            { "+", "FloatBorder" },
            { "-", "FloatBorder" },
            { "+", "FloatBorder" },
            { "|", "FloatBorder" },
          },
        },
        lightbulb = {
          enable = false,
        },
        outline = {
          layout = "float",
          keys = {
            toggle_or_jump = "<CR>",
          }
        },
        symbol_in_winbar = {
          enable = false,
        },
      })
    end,
    dependencies = {
      { "nvim-treesitter/nvim-treesitter" },
      { "nvim-tree/nvim-web-devicons" },
    },
  },

  -- Syntax
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "LazyFile" },
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

  -- Markdown
  {
    "plasticboy/vim-markdown",
    ft = { "markdown" },
    config = function()
      vim.g.vim_markdown_folding_disabled = 1
    end,
    dependencies = {
      { "godlygeek/tabular" },
      { "joker1007/vim-markdown-quote-syntax" },
    },
  }
})

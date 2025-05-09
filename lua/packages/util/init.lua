local pkg = require("lib.pkg")

pkg:add({}, {
  {
    "editorconfig/editorconfig-vim",
    event = { "LazyFile" },
  },
  {
    "norcalli/nvim-colorizer.lua",
    ft = { "css", "sass", "html", "javascript", "lua" },
    config = function()
      require("colorizer").setup({
        "css",
        "sass",
        "html",
        "javascript",
        "lua",
      })
    end,
  },

  -- AI integration
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    build = ":Copilot auth",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = false,
        },
        panel = {
          enabled = false,
        },
        filetypes = {
          markdown = true,
          yaml = true,
        },
      })
    end,
    enabled = function()
      return os.getenv("NVIM_DISABLE_COPILOT") ~= "true"
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    build = "make tiktoken",
    opts = {
      model = "o3-mini",
      prompts = {},
    },
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
  },
})

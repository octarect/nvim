return {
  -- AI
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    build = ":Copilot auth",
    enabled = function()
      return os.getenv("NVIM_DISABLE_COPILOT") ~= "true"
    end,
    opts = {
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
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    build = "make tiktoken",
    dependencies = {
      "zbirenbaum/copilot.lua",
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "folke/sidekick.nvim",
    lazy = true,
    init = function()
      local keymap = require("core.utils.keymap")
      keymap.nmap():silent():set({
        {
          "<Leader>as",
          function()
            require("sidekick.cli").toggle({ name = "copilot", focus = true })
          end,
          desc = "AI Assistant (Copilot)",
        },
      })
      keymap.vmap():silent():set({
        {
          "<Leader>as",
          function()
            require("sidekick.cli").send({ name = "copilot", msg = "{selection}" })
          end,
          desc = "AI Assistant (Copilot)",
        },
      })
    end,
    opts = {
      cli = {
        win = {
          keys = {
            hide_n = { "q", "hide", mode = "n", desc = "hide the terminal window" },
            stopinsert = { "<c-j><c-j>", "stopinsert", mode = "t", desc = "enter normal mode" },
          },
        },
      },
      nes = {
        enabled = false,
      },
    },
  },
}

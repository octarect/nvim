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
    init = function()
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-*",
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
          vim.opt_local.conceallevel = 0
        end,
      })
    end,
    ---@module "CopilotChat"
    ---@type CopilotChat.config.Config
    opts = {
      model = "claude-sonnet-4.5",
      temperature = 0.1,
      headers = {
        user = "👤",
        assistant = "😎",
        tool = "🔭",
      },
      auto_insert_mode = true,
    },
  },
  {
    "folke/sidekick.nvim",
    lazy = true,
    init = function()
      _G.sidekick_tool_name = (function()
        local default_tool_name = "copilot"

        return function()
          local state = require("sidekick.cli.state").get({ started = true })[1]

          if state and state.tool.name then
            return state.tool.name
          else
            return default_tool_name
          end
        end
      end)()

      local keymap = require("lib.keymap")
      keymap.nmap():set({
        ["<Leader>ai"] = {
          function()
            require("sidekick.cli").toggle({ name = _G.sidekick_tool_name(), focus = true })
          end,
          { desc = "AI Assistant" },
        },
      })
      keymap.vmap():set({
        ["<Leader>ai"] = {
          function()
            require("sidekick.cli").send({ name = _G.sidekick_tool_name(), msg = "{selection}" })
          end,
          { desc = "AI Assistant" },
        },
        ["<Leader>am"] = {
          function()
            require("sidekick.cli").prompt({ name = _G.sidekick_tool_name() })
          end,
          { desc = "Select prompt for AI" },
        },
      })
    end,
    ---@module "sidekick"
    ---@class sidekick.Config
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

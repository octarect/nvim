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
      copilot_model = "o4-mini",
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
      local keymap = require("core.utils.keymap")
      keymap.nmap():silent():set({
        { "<Leader>ai", "<Cmd>CopilotChat<CR>", desc = "AI Chat" },
      })
    end,
    opts = {
      -- model = "claude-sonnet-4",
      model = "gpt-4.1",
      temperature = 0.1,
      sticky = {
        "#buffers",
      },
      headers = {
        user = "👤",
        assistant = "😎",
        tool = "🔭",
      },
      prompts = {},
    },
  },
  {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "zbirenbaum/copilot.lua",
      "MeanderingProgrammer/render-markdown.nvim",
    },
    -- init = function()
    --   local keymap = require("core.utils.keymap")
    --   keymap.nmap():silent():set({
    --     { "<Leader>ai", "<Cmd>CodeCompanionChat Toggle<CR>", desc = "AI" },
    --     { "<Leader>aa", "<Cmd>CodeCompanionActions<CR>", desc = "AI" },
    --   })
    -- end,
      ---@module "codecompanion"
      ---@type CodeCompanion.Config
    opts = {
      prompt_library = {
        ["Agent"] = {
          strategy = "chat",
          description = "AI Agent",
          opts = {
            index = 4,
            -- ignore_system_prompt = true,
            intro_message = "Hello! I am your AI assistant. How can I help you today?",
          },
          prompts = {
            {
              role = "system",
              content = [[
              # Instructions

              When you need to edit the code, follow the below steps;

              1. (Only the first time) Read source files in the current workspace using the @{file_search} and the @{read_file}. The extensions of source files is depending on the programming lnaguage of the project and please exclude non-source files about the project, for instance .git, node_modules. The results will be cached.
              2. Consider how you implement my request and create your TODO.
              3. Edit files using the @{insert_edit_into_file}.
              ]],
            },
          },
        },
      },
      strategies = {
        chat = {
          adapter = {
            name = "copilot",
            model = "claude-sonnet-4",
          },
        }
      }
    },
  },
}

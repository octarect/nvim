local config = require("config.vars")

local has_words_before = function()
  if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt" then
    return false
  end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = {
      "moyiz/blink-emoji.nvim",
      "onsails/lspkind-nvim",
      "nvim-tree/nvim-web-devicons",
      {
        "fang2hou/blink-copilot",
        dependencies = {
          "zbirenbaum/copilot.lua",
        },
      },
    },
    event = { "InsertEnter" },
    --- @module "blink.cmp"
    --- @type blink.cmp.Config
    opts = {
      appearance = {
        nerd_font_variant = "mono",
      },
      completion = {
        documentation = {
          auto_show = true,
          window = config.window,
        },
        menu = {
          border = config.window.border,
          draw = {
            columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "source_name" } },
            components = {
              kind_icon = {
                text = function(ctx)
                  local icon = ctx.kind_icon
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local devicon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                    if devicon then
                      icon = devicon
                    end
                  else
                    icon = require("lspkind").symbolic(ctx.kind, {
                      mode = "symbol",
                    })
                  end
                  return icon .. ctx.icon_gap
                end,
              },
              source_name = {
                text = function(ctx)
                  return "[" .. ctx.source_name .. "]"
                end,
              },
            },
            treesitter = { "lsp", "copilot" },
          },
        },
      },
      cmdline = {
        keymap = {
          preset = "inherit",
        },
        completion = {
          menu = {
            auto_show = false,
          },
        },
      },
      keymap = {
        preset = "default",
        ["<C-n>"] = {
          function(cmp)
            if cmp.is_visible() then
              cmp.select_next()
            else
              cmp.show()
            end
          end,
        },
        ["<C-p>"] = {
          function(cmp)
            if cmp.is_visible() then
              cmp.select_prev()
            else
              cmp.show()
            end
          end,
        },
        ["<Tab>"] = {
          function(cmp)
            if cmp.is_visible() then
              cmp.select_next()
            elseif has_words_before() then
              cmp.show()
            else
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", true)
            end
          end,
        },
        ["<CR>"] = { "accept", "fallback" },
      },
      signature = {
        window = config.window,
      },
      sources = {
        default = { "copilot", "lsp", "path", "emoji", "buffer", "snippets" },
        providers = {
          cmdline = {
            -- Ignores cmdline completions when executing shell commands
            enabled = function()
              return vim.fn.getcmdtype() ~= ":" or not vim.fn.getcmdline():match("^[%%0-9,'<>%-]*!")
            end,
          },
          copilot = {
            name = "Copilot",
            module = "blink-copilot",
            score_offset = 100,
            async = true,
            opts = {
              max_completions = 3, -- Maximum number of completions to show.
              max_attempts = 4, -- Maximum number of attempts to fetch completions.
            },
          },
          emoji = {
            name = "Emoji",
            module = "blink-emoji",
            score_offset = 10,
          },
        },
      },
    },
  },
}

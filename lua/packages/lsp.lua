local config = require("core.config")

return {
  -- LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
    event = { "LazyFile" },
    init = function()
      -- Disable logging
      vim.lsp.set_log_level(vim.lsp.log_levels.OFF)
    end,
    config = function()
      local keymap = require("core.utils.keymap")

      -- Event handler when LSP attaches to a buffer
      local on_attach = function(client, bufnr)
        -- Highlight a symbol and its references when holding the cursor
        if client:supports_method("textDocument/documentHighlight") then
          local aug = vim.api.nvim_create_augroup("MyAutoCmdLspDocumentHighlight", {})
          vim.api.nvim_clear_autocmds({
            group = aug,
            buffer = bufnr,
          })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            group = aug,
            buffer = bufnr,
            callback = function(_)
              vim.lsp.buf.document_highlight()
            end,
            desc = "LSP Document Highlight",
          })
          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            group = aug,
            buffer = bufnr,
            callback = function(_)
              vim.lsp.buf.clear_references()
            end,
            desc = "LSP Document Highlight Clear",
          })
        end

        if client:supports_method("textDocument/formatting") then
          keymap.bnmap():silent():noremap():set({
            {
              "<LocalLeader>f",
              function()
                vim.lsp.buf.format({ bufnr = bufnr, id = client.id })
              end,
              desc = "LSP Format",
            },
          })
        end

        if client:supports_method("textDocument/rangeFormatting") then
          keymap.bvmap():silent():noremap():set({
            {
              "<LocalLeader>f",
              function()
                vim.lsp.buf.format({ bufnr = bufnr, id = client.id })
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
              end,
              desc = "LSP Format (Range)",
            },
          })
        end

        -- Configure nvim-navic
        if client:supports_method("textDocument/documentSymbol") then
          require("nvim-navic").attach(client, bufnr)
        end
      end

      -- Define how to attach LSP to buffers
      local aug = vim.api.nvim_create_augroup("MyAutoCmdLspConfig", {})
      vim.api.nvim_create_autocmd({ "LspAttach" }, {
        group = aug,
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client == nil then
            return
          end
          -- Avoid attaching to copilot buffers
          if client.name == "copilot" then
            return
          end
          if client ~= nil then
            on_attach(client, args.buf)
          end
        end,
      })
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)
      vim.lsp.enable(require("mason-lspconfig").get_installed_servers())
    end,
    opts = {
      ensure_installed = {
        "bashls",
        "denols",
        "dockerls",
        "gopls",
        "html",
        "jsonls",
        "lua_ls",
        "terraformls",
        "tflint",
        "ts_ls",
        "vimls",
        "yamlls",
      },
    },
  },
  {
    "onsails/lspkind-nvim",
    init = function()
      vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
    end,
    opts = {
      symbol_map = {
        Copilot = "",
      },
    },
  },
  {
    "nvimdev/lspsaga.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    event = { "LspAttach" },
    init = function()
      local keymap = require("core.utils.keymap")
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
    opts = {
      ui = config.window,
      lightbulb = {
        enable = false,
      },
      outline = {
        layout = "float",
        keys = {
          toggle_or_jump = "<CR>",
        },
      },
      symbol_in_winbar = {
        enable = false,
      },
    },
  },
}

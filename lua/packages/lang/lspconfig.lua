local keymap = require("core.utils.keymap")

-- Disable logging
vim.lsp.set_log_level(vim.lsp.log_levels.OFF)

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

local aug = vim.api.nvim_create_augroup("MyAutoCmdLspConfig", {})
vim.api.nvim_create_autocmd({ "LspAttach" }, {
  group = aug,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client ~= nil and client.name ~= "copilot" then
      on_attach(client, args.buf)
    end
  end,
})

-- Install and manage LSP servers
require("mason").setup({})
require("mason-lspconfig").setup({
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
})
vim.lsp.enable(require("mason-lspconfig").get_installed_servers())

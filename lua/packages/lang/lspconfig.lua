local lspconfig = require("lspconfig")
local keymap = require("lib.keymap")

-- Disable logging
vim.lsp.set_log_level(vim.lsp.log_levels.OFF)

-- Custom border of hover window
_G.__MyLspFloatingOpts = {
  focusable = false,
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
}

local on_attach = function(client, bufnr)
  -- Don't show message as virtual text
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
  })

  -- Highlight a symbol and its references when holding the cursor
  if client:supports_method("textDocument/documentHighlight") then
    local aug = vim.api.nvim_create_augroup("MyAutoCmdLspDocumentHighlight", {})
    vim.api.nvim_clear_autocmds({
      group = aug,
      buffer = 0,
    });
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = aug,
      buffer = 0,
      callback = function(_)
        vim.lsp.buf.document_highlight()
      end,
      desc = "LSP Document Highlight",
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      group = aug,
      buffer = 0,
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
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
        desc = "LSP Format",
      }
    })
  end
  if client:supports_method("textDocument/rangeFormatting") then
    keymap.bvmap():silent():noremap():set({
      {
        "<LocalLeader>f",
        function()
          vim.lsp.buf.format({ bufnr = bufnr })
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
        end,
        desc = "LSP Format (Range)",
      }
    })
  end

  -- Configure nvim-navic
  if client:supports_method("textDocument/documentSymbol") then
    require("nvim-navic").attach(client, bufnr)
  end
end

local lsp_settings = {
  bashls = {},
  denols = {
    root_dir = lspconfig.util.root_pattern("deno.json"),
    init_options = { lint = true },
  },
  dockerls = {},
  gopls = {},
  html = {},
  jsonls = {},
  lua_ls = {
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
        },
        workspace = {
          checkThirdParty = false,
          library = {
            vim.env.VIMRUNTIME,
          },
        },
      },
    },
  },
  terraformls = {},
  tflint = {},
  ts_ls = {
    root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json"),
  },
  vimls = {},
  yamlls = {
    settings = {
      yaml = {
        schemas = {
          kubernetes = "/*.yaml",
          ["https://json.schemastore.org/ansible-playbook.json"] = { "/playbook.yml", "/ansible/*.yml" },
          ["https://json.schemastore.org/ansible-role-2.9.json"] = { "/roles/tasks/*.yml" },
        },
      },
    },
  },
}

local required_server_names = {}
for server_name, _ in pairs(lsp_settings) do
  required_server_names[#required_server_names + 1] = server_name
end

local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

require("mason").setup({})

require("mason-lspconfig").setup({
  ensure_installed = required_server_names,
})

require("mason-lspconfig").setup_handlers({
  function(server_name)
    local opts = {
      on_attach = on_attach,
      capabilities = capabilities,
    }
    -- Override settings
    if lsp_settings[server_name] ~= nil then
      for k, v in pairs(lsp_settings[server_name]) do
        opts[k] = v
      end
    end
    lspconfig[server_name].setup(opts)
    vim.cmd([[ do User LspAttachBuffers ]])
  end,
})

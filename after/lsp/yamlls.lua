---@type vim.lsp.Config
return {
  settings = {
    yaml = {
      schemas = {
        kubernetes = "/*.yaml",
        ["https://json.schemastore.org/ansible-playbook.json"] = { "/playbook.yml", "/ansible/*.yml" },
        ["https://json.schemastore.org/ansible-role-2.9.json"] = { "/roles/tasks/*.yml" },
      },
    },
  },
}

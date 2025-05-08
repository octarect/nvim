---@type vim.lsp.Config
return {
  init_options = { lint = true },
  root_markers = {
    "deno.json",
    "deno.jsonc",
  },
  workspace_required = true,
}

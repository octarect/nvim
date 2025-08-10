local keymap = require("core.utils.keymap")

keymap.nmap():silent():noremap():set({
  { "[b", "<Cmd>bprevious<CR>", desc = "Go to previous buffer" },
  { "]b", "<Cmd>bnext<CR>", desc = "Go to next buffer" },
  {
    "<F10>",
    function()
      local hlname = vim.api.nvim_exec("echo synIDattr(synID(line('.'), col('.'), 1), 'name')", true)
      print(hlname)
      print(vim.inspect(require("core.colorscheme").get_hl(hlname)))
    end,
    desc = "Inspect highlight",
  },
})

-- Tab
local max_tab = 9
local tab_keymaps = {
  { "tc", "<Cmd>tabnew<CR>", desc = "Open new tab" },
  { "tq", "<Cmd>tabclose<CR>", desc = "Close tab" },
  { "[t", "<Cmd>tabprev<CR>", desc = "Go to previous tab" },
  { "]t", "<Cmd>tabnext<CR>", desc = "Go to next tab" },
}
for i = 1, max_tab do
  table.insert(tab_keymaps, {
    "t" .. i,
    "<Cmd>tabnext" .. i .. "<CR>",
    desc = "Go to tab No." .. i,
  })
end
keymap.nmap():silent():noremap():set(tab_keymaps)

-- Folding
keymap.nmap():silent():noremap():set({
  -- Open/Close fold recursively
  { "za", "zA", desc = "Toggle folding on currenct context" },
})

local keymap = require("lib.keymap")
local opt = vim.opt

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
  -- Turn on `public mode` to make my great editor readable by co-workers.
  {
    "<Leader>os",
    (function()
      local public_mode = false
      return function()
        if public_mode then
          -- Turn off
          public_mode = false
          opt.listchars = { tab = ">·", nbsp = "+", trail = "·", extends = "→", precedes = "←" }
          opt.relativenumber = true
        else
          -- Turn on
          public_mode = true
          opt.listchars = { tab = "  ", nbsp = "+", trail = "·", extends = "→", precedes = "←" }
          opt.relativenumber = false
        end
      end
    end)(),
    desc = "Toggle public mode",
  },
})

keymap.vmap():noremap():set({
  { "<LocalLeader>r", "<Cmd>'<,'>w !bash<CR>", desc = "Run selection as a bash command" },
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

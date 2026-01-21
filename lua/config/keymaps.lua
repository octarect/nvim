local keymap = require("lib.keymap")

keymap.nmap():noremap():set({
  -- Buffer
  ["[b"] = "<Cmd>bprevious<CR>",
  ["]b"] = "<Cmd>bnext<CR>",
  ["<F10>"] = {
    function()
      local hlname = vim.api.nvim_exec2("echo synIDattr(synID(line('.'), col('.'), 1), 'name')", { output = true })
      print(hlname)
      print(vim.inspect(require("lib.colorscheme").get_hl(hlname.output)))
    end,
    desc = "Inspect highlight",
  },

  -- Tab
  ["tc"] = "<Cmd>tabnew<CR>",
  ["tq"] = "<Cmd>tabclose<CR>",
  ["[t"] = "<Cmd>tabprev<CR>",
  ["]t"] = "<Cmd>tabnext<CR>",
  ["t1"] = "<Cmd>tabnext1<CR>",
  ["t2"] = "<Cmd>tabnext2<CR>",
  ["t3"] = "<Cmd>tabnext3<CR>",
  ["t4"] = "<Cmd>tabnext4<CR>",
  ["t5"] = "<Cmd>tabnext5<CR>",
  ["t6"] = "<Cmd>tabnext6<CR>",
  ["t7"] = "<Cmd>tabnext7<CR>",
  ["t8"] = "<Cmd>tabnext8<CR>",
  ["t9"] = "<Cmd>tabnext9<CR>",

  -- Folding
  -- Open/Close fold recursively
  ["za"] = { "zA", { desc = "Toggle folding on currenct context" } },
})

-- Terminal
local terminal = require("lib.terminal").new({
  height_ratio = 0.25,
  min_height = 5,
  on_create = function()
    keymap.nmap():buf():noremap():set({
      ["q"] = { "<Cmd>q<CR>", { desc = "Close the terminal buffer" } },
    })
    keymap.tmap():buf():noremap():set({
      ["<C-j><C-j>"] = { "<C-\\><C-n>", { desc = "Exit terminal mode" } },
    })
  end,
})
-- stylua: ignore
keymap.nmap():set({
  ["<Leader>tv"] = { function() terminal:open("vertical") end, { desc = "Open vertical terminal" } },
  ["<Leader>ts"] = { function() terminal:open("horizontal") end, { desc = "Open horizontal terminal" } },
  ["<Leader>tt"] = { function() terminal:open() end, { desc = "Open terminal" } },
})

-- Menu
local menu = require("config.menu")
keymap.nmap():set({
  ["<Leader>dm"] = {
    function()
      vim.ui.select(menu.items, {
        prompt = menu.prompt,
        format_item = menu.format_item,
      }, menu.on_choice)
    end,
    desc = "Open Menu",
  },
})

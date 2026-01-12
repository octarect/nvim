return {
  {
    "rainbowhxch/accelerated-jk.nvim",
    module = "accelerated-jk",
    init = function()
      local keymap = require("lib.keymap")
      local accelerated_move = function(movement)
        return function()
          require("accelerated-jk").move_to(movement)
        end
      end
      keymap.nmap():silent():set({
        { "j", accelerated_move("j"), desc = "Move down (accelerated)" },
        { "k", accelerated_move("k"), desc = "Move up (accelerated)" },
      })
    end,
  },
  {
    "norcalli/nvim-colorizer.lua",
    ft = { "css", "sass", "html", "javascript", "lua" },
    config = function()
      require("colorizer").setup({
        "css",
        "sass",
        "html",
        "javascript",
        "lua",
      })
    end,
  },
  {
    "plasticboy/vim-markdown",
    dependencies = {
      "godlygeek/tabular",
      "joker1007/vim-markdown-quote-syntax",
    },
    ft = { "markdown" },
    config = function()
      vim.g.vim_markdown_folding_disabled = 1
    end,
  },
}

local pkg = require("lib.pkg")

pkg:add({}, {
  {
    "editorconfig/editorconfig-vim",
    event = { "BufNewFile", "BufReadPre", "BufWritePre" },
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
})

local packages = {
  {
    "rhysd/vim-color-spring-night",
    config = function()
      vim.g.spring_night_high_contrast = 1
      vim.g.spring_night_highlight_terminal = 1
      vim.g.spring_night_cterm_italic = 1
    end,
  },
  {
    "nvimdev/oceanic-material",
    config = function()
      vim.g.oceanic_material_allow_bold = 1
      vim.g.oceanic_material_allow_italic = 1
    end,
  },
  {
    "folke/tokyonight.nvim",
  },
}

for i, p in ipairs(packages) do
  packages[i] = vim.tbl_deep_extend("force", {
    lazy = false,
    priority = 999,
  }, p)
end

return packages

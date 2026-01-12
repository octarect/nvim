return {
  -- [DO NOT EDIT] Path to current file's directory
  runtime_path = vim.fn.expand("<sfile>:p:h"),

  -- Common window border style
  window = {
    border = { "+", "-", "+", "|", "+", "-", "+", "|" },
  },
}

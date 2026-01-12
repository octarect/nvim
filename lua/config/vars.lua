return {
  -- [DO NOT EDIT] Path to current file's directory
  runtime_path = vim.fn.expand("<sfile>:p:h"),

  -- Path to cache directory.
  -- Use XDG_CACHE_HOME if set, otherwise default to ~/.cache/nvim
  cache_path = (function()
    local path
    if vim.env.XDG_CACHE_HOME then
      path = vim.env.XDG_CACHE_HOME .. "/nvim"
    else
      path = "~/.cache/nvim"
    end
    return vim.fn.expand(path)
  end)(),

  -- Common window border style
  window = {
    border = { "+", "-", "+", "|", "+", "-", "+", "|" },
  },
}

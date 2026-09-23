return {
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    config = function()
      require("tiny-inline-diagnostic").setup({
        preset = "modern",
        options = {
          multilines = { enabled = true, always_show = false },
          show_source = { enabled = true },
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = { virtual_text = false },
    },
  },
}

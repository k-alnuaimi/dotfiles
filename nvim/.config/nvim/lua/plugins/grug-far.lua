return {
  "MagicDuck/grug-far.nvim",
  keys = {
    {
      "<leader>s1",
      function()
        require("grug-far").open({
          transient = true,
          prefills = { paths = vim.fn.expand("%") },
        })
      end,
      mode = { "n", "v" },
      desc = "Search and Replace (current file)",
    },
  },
}

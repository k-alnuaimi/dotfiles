return {
  "b0o/incline.nvim",
  event = "VeryLazy",
  config = function()
    require("incline").setup({
      window = {
        margin = { vertical = 0, horizontal = 1 },
        padding = 1,
        zindex = 30,
      },
      hide = {
        cursorline = true,
      },
      render = function(props)
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
        if filename == "" then
          filename = "[No Name]"
        end
        if vim.bo[props.buf].modified then
          filename = "[+] " .. filename
        end
        local icon, color = require("mini.icons").get("file", filename)
        return {
          { icon, guifg = color },
          { " " },
          { filename },
        }
      end,
    })
  end,
}

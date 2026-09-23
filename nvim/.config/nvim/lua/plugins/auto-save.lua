local group = vim.api.nvim_create_augroup("autosave", {})
local autosave_format_restore = {}

-- auto-save writes from BufLeave/FocusLost, where Neovim skips nested
-- BufWritePre autocmds. LazyVim's format-on-save would be missed, so format
-- explicitly here, then suppress autoformat for that write to avoid doubling up.
vim.api.nvim_create_autocmd("User", {
  pattern = "AutoSaveWritePre",
  group = group,
  callback = function(opts)
    local buf = opts.data and opts.data.saved_buffer
    if buf == nil or not vim.api.nvim_buf_is_valid(buf) then
      return
    end
    if LazyVim == nil or LazyVim.format == nil then
      return
    end
    local ok = pcall(function()
      LazyVim.format({ buf = buf })
    end)
    if not ok then
      return
    end
    autosave_format_restore[buf] = { autoformat = vim.b[buf].autoformat }
    vim.b[buf].autoformat = false
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "AutoSaveWritePost",
  group = group,
  callback = function(opts)
    local buf = opts.data and opts.data.saved_buffer
    if buf == nil then
      return
    end
    local restore = autosave_format_restore[buf]
    if restore then
      autosave_format_restore[buf] = nil
      if vim.api.nvim_buf_is_valid(buf) then
        vim.b[buf].autoformat = restore.autoformat
      end
    end
  end,
})

return {
  {
    "okuuva/auto-save.nvim",
    cmd = "ASToggle",
    event = "VeryLazy",
    opts = {
      trigger_events = {
        immediate_save = { "BufLeave", "WinLeave", "FocusLost", "QuitPre", "VimSuspend" },
        defer_save = { "InsertLeave", "TextChanged" },
        cancel_deferred_save = { "InsertEnter" },
      },
      condition = function(buf)
        if vim.fn.mode() == "i" then
          return false
        end
        if vim.bo[buf].buftype ~= "" then
          return false
        end
        if vim.api.nvim_buf_get_name(buf) == "" then
          return false
        end
        return true
      end,
      noautocmd = false,
      debounce_delay = 3000,
    },
  },
}

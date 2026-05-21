-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Enable line wrapping
vim.opt.wrap = true

-- Allow moving the cursor to the next/previous line when navigating with h / l / left / right
vim.opt.whichwrap:append("h,l,[,]")

-- disable system clipboard override
vim.opt.clipboard = ""

-- Use OSC 52 for clipboard if we're in an SSH session
if vim.env.SSH_TTY ~= nil then
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = function()
        return { vim.fn.split(vim.fn.getreg('"'), "\n"), vim.fn.getregtype('"') }
      end,
      ["*"] = function()
        return { vim.fn.split(vim.fn.getreg('"'), "\n"), vim.fn.getregtype('"') }
      end,
    },
  }
end

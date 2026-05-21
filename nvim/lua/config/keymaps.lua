-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local opts = { noremap = true, silent = true }

-- Opt+← / Opt+→ -> jump by word
vim.keymap.set("i", "<M-b>", "<C-Left>", opts)
vim.keymap.set("i", "<M-f>", "<C-Right>", opts)

-- Opt+Delete / Opt+Backspace -> delete word
vim.keymap.set("i", "<M-BS>", "<C-w>", opts) -- delete word before cursor
vim.keymap.set("i", "<M-Delete>", "<C-o>dw", opts) -- delete word after cursor

-- Also useful: Option + f/b (readline-style, works in insert mode)
vim.keymap.set("i", "<M-f>", "<C-o>w", { desc = "Move word forward" })
vim.keymap.set("i", "<M-b>", "<C-o>b", { desc = "Move word backward" })

-- jj -> escape insert mode
vim.keymap.set("i", "jj", "<Esc>", opts)

-- Shift + scroll to scroll horizontally
vim.keymap.set("n", "<S-ScrollWheelUp>", "zH")
vim.keymap.set("n", "<S-ScrollWheelDown>", "zL")

-- We disable the default clipboard override in options.lua. But we enable it for yanking
vim.keymap.set({ "n", "v" }, "y", '"+y')
vim.keymap.set("n", "Y", '"+Y')

-- vscode specific keybindings
if vim.g.vscode then
  local opts = { silent = true }

  -- handle j/k in vscode neovim extension to move by visual lines when no count is provided
  vim.keymap.set("n", "j", function()
    if vim.v.count == 0 then
      vim.fn.VSCodeCall("cursorDown")
    else
      vim.api.nvim_feedkeys(vim.v.count .. "j", "n", false)
    end
  end)

  vim.keymap.set("n", "k", function()
    if vim.v.count == 0 then
      vim.fn.VSCodeCall("cursorUp")
    else
      vim.api.nvim_feedkeys(vim.v.count .. "k", "n", false)
    end
  end)

  -- files
  vim.keymap.set("n", "<leader>e", function()
    vim.fn.VSCodeNotify("workbench.view.explorer")
  end, opts)

  vim.keymap.set("n", "<leader>ff", function()
    vim.fn.VSCodeNotify("workbench.action.quickOpen")
  end, opts)

  vim.keymap.set("n", "<leader>fr", function()
    vim.fn.VSCodeNotify("workbench.action.quickOpen")
  end, opts)

  vim.keymap.set("n", "<leader><leader>", function()
    vim.fn.VSCodeNotify("workbench.action.quickOpen")
  end, opts)

  -- buffers
  vim.keymap.set("n", "<leader>,", function()
    vim.fn.VSCodeNotify("workbench.action.showAllEditors")
  end, opts)

  vim.keymap.set("n", "<leader>bd", function()
    vim.fn.VSCodeNotify("workbench.action.closeActiveEditor")
  end, opts)

  -- windows
  vim.keymap.set("n", "<leader>wq", function()
    vim.fn.VSCodeNotify("workbench.action.closeGroup")
  end, opts)

  -- LSP
  vim.keymap.set("n", "<leader>o", function() -- focus on outline view
    vim.fn.VSCodeNotify("outline.focus")
  end, opts)

  vim.keymap.set("n", "gO", function() -- symbol outline (Cmd+P then @)
    vim.fn.VSCodeNotify("workbench.action.gotoSymbol")
  end, opts)

  vim.keymap.set("n", "gr", function() -- search references
    vim.fn.VSCodeNotify("editor.action.referenceSearch.trigger")
  end, opts)

  vim.keymap.set("n", "[d", function() -- diagnostics (problems)
    vim.fn.VSCodeNotify("editor.action.marker.prevInFiles")
  end, opts)

  vim.keymap.set("n", "]d", function() -- diagnostics (problems)
    vim.fn.VSCodeNotify("editor.action.marker.nextInFiles")
  end, opts)

  vim.keymap.set("n", "cr", function() -- rename symbol
    vim.fn.VSCodeNotify("editor.action.rename")
  end, opts)

  -- search panel
  vim.keymap.set("n", "<leader>sG", function()
    vim.fn.VSCodeNotify("workbench.view.search") -- focus on the commit message box
  end, opts)

  -- git
  vim.keymap.set("n", "<leader>gs", function()
    vim.fn.VSCodeNotify("workbench.view.scm") -- focus on the commit message box
  end, opts)

  vim.keymap.set("n", "<leader>gg", function()
    vim.fn.VSCodeNotify("workbench.view.scm") -- focus on the commit message box
  end, opts)

  vim.keymap.set("n", "<leader>gd", function()
    local vscode = require("vscode")
    vscode.call("workbench.scm.focus")
    vscode.call("list.focusFirst")
    -- skips two items and land on the fisrt file
    vscode.call("list.focusDown")
    vscode.call("list.focusDown")
  end, opts)

  vim.keymap.set("n", "<leader>hs", function() -- stage hunk
    vim.fn.VSCodeNotify("git.diff.stageHunk")
  end, opts)

  vim.keymap.set("n", "<leader>hu", function() -- unstage hunk
    vim.fn.VSCodeNotify("git.unstageSelectedRanges")
  end, opts)

  vim.keymap.set("n", "<leader>hr", function() -- revert hunk
    vim.fn.VSCodeNotify("git.revertSelectedRanges")
  end, opts)

  -- = command setup
  -- https://github.com/vscode-neovim/vscode-neovim/issues/1425
  local vscode = require("vscode")

  local function format_range(line1, line2)
    vscode.call("editor.action.formatSelection", {
      range = { line1 - 1, 0, line2, 0 },
    })
  end

  vim.keymap.set("n", "=", function() -- = as a motion operator (e.g. =ap, gg=G)
    vim.o.operatorfunc = "v:lua._vscode_format_op"
    _G._vscode_format_op = function()
      format_range(vim.fn.line("'["), vim.fn.line("']"))
    end
    return "g@"
  end, { expr = true, desc = "Format (VSCode)" })

  vim.keymap.set("n", "==", function() -- == formats the current line
    format_range(vim.fn.line("."), vim.fn.line("."))
  end, { desc = "Format line (VSCode)" })

  vim.keymap.set("x", "=", function() -- = in visual mode
    format_range(vim.fn.line("v"), vim.fn.line("."))
  end, { desc = "Format selection (VSCode)" })
end

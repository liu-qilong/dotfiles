return {
  {
    "mg979/vim-visual-multi",
    branch = "master",
    lazy = false, -- must NOT be lazy-loaded or keymaps won't work
    init = function()
      -- vim.g.* settings must go in `init`, not `config`
      vim.g.VM_maps = {
        ["Find Under"] = "<C-n>",
        ["Find Subword Under"] = "<C-n>",
        ["Select Cursor Down"] = "<M-Down>",
        ["Select Cursor Up"] = "<M-Up>",
      }
    end,
  },
}

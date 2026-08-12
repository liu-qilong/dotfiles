return {
  "hedyhli/outline.nvim",
  config = function()
    -- Example mapping to toggle outline
    vim.keymap.set("n", "<leader>o", "<cmd>Outline<CR>", { desc = "Toggle Outline" })

    require("outline").setup({
      -- Your setup opts here (leave empty to use defaults)
      providers = {
        -- Prefer outline.nvim's native Markdown parser over obsidian-ls.
        priority = { "markdown", "beancount", "lsp", "coc", "norg", "man" },
      },
      symbols = {
        filter = {
          -- Default: show everything except String
          default = { "String", exclude = true },
          -- Python: only show these kinds
          python = { "Class", "Function", "Method" },
        },
      },
    })
  end,
}

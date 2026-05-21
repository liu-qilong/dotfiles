return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  ft = "markdown",
  dependencies = {
    "saghen/blink.cmp", -- declare blink as dependency
  },
  opts = {
    legacy_commands = false,
    workspaces = {
      {
        name = "DeepSpace",
        path = "/Users/knpob/Library/Mobile Documents/iCloud~md~obsidian/Documents/DeepSpace",
        overrides = {
          frontmatter = { enabled = false },
        },
      },
    },
    completion = {
      nvim_cmp = false,
      blink = true,
      min_chars = 2,
    },
    -- rest of your config...
  },
}

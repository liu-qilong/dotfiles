return {
  "saghen/blink.cmp",
  dependencies = {
    "L3MON4D3/LuaSnip",
  },
  opts = {
    keymap = {
      preset = "enter",
      ["<CR>"] = { "accept", "fallback" },
      ["<C-M>"] = { "accept", "fallback" },
      ["<Tab>"] = { "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "snippet_backward", "fallback" },
    },
  },
}

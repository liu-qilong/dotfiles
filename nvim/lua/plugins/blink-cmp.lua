return {
  "saghen/blink.cmp",
  dependencies = {
    "fang2hou/blink-copilot",
    "L3MON4D3/LuaSnip",
  },
  opts = {
    sources = {
      default = { "copilot" },
      providers = {
        copilot = {
          name = "copilot",
          module = "blink-copilot",
          score_offset = 100,
          async = true,
        },
      },
    },
    keymap = {
      preset = "enter",
      ["<CR>"] = { "accept", "fallback" },
      ["<C-M>"] = { "accept", "fallback" },
      ["<Tab>"] = { "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "snippet_backward", "fallback" },
    },
  },
}

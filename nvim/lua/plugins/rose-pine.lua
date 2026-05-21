return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    opts = {
      variant = "auto", -- auto, main, moon, or dawn
      dark_variant = "main", -- used when background=dark
      styles = {
        bold = true,
        italic = true,
        transparency = true, -- set true for transparent bg
      },
    },
  },
  -- Tell LazyVim to use this colorscheme
  { "LazyVim/LazyVim", opts = { colorscheme = "rose-pine" } },
}

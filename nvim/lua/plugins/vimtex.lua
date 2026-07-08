return {
  {
    "lervag/vimtex",
    init = function()
      vim.g.vimtex_compiler_latexmk = {
        continuous = 0,
        callback = 1,
        options = {
          "-verbose",
          "-file-line-error",
          "-synctex=1",
          "-interaction=nonstopmode",
        },
      }
    end,
  },
}

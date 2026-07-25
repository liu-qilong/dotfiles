return {
  {
    "lervag/vimtex",
    init = function()
      -- Display literal LaTeX source.
      vim.g.vimtex_syntax_conceal_disable = 1

      -- Use Skim for viewing and SyncTeX forward search.
      vim.g.vimtex_view_method = "skim"

      -- Do not automatically open quickfix.
      vim.g.vimtex_quickfix_mode = 0

      -- One-off compilation with \ll
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

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "tex", "plaintex" },
        callback = function()
          vim.opt_local.conceallevel = 0
          vim.opt_local.concealcursor = ""
        end,
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        texlab = {
          settings = {
            texlab = {
              inlayHints = {
                labelDefinitions = false,
                labelReferences = false,
              },
            },
          },
        },
      },
    },
  },
}

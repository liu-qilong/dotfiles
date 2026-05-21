return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      actions = {
        copy_file_name = function(picker, item)
          item = item or picker:current()
          if not item then
            return
          end

          local path = item.file or item.path or item.text
          if not path then
            return
          end

          vim.fn.setreg("+", vim.fn.fnamemodify(path, ":t"))
          vim.notify("Copied file name: " .. vim.fn.fnamemodify(path, ":t"))
        end,

        copy_relative_path = function(picker, item)
          item = item or picker:current()
          if not item then
            return
          end

          local path = item.file or item.path or item.text
          if not path then
            return
          end

          local rel = vim.fn.fnamemodify(path, ":.")
          vim.fn.setreg("+", rel)
          vim.notify("Copied relative path: " .. rel)
        end,

        copy_absolute_path = function(picker, item)
          item = item or picker:current()
          if not item then
            return
          end

          local path = item.file or item.path or item.text
          if not path then
            return
          end

          local abs = vim.fn.fnamemodify(path, ":p")
          vim.fn.setreg("+", abs)
          vim.notify("Copied absolute path: " .. abs)
        end,
      },

      sources = {
        explorer = {
          win = {
            list = {
              keys = {
                ["gy"] = "copy_relative_path",
                ["gY"] = "copy_absolute_path",
                ["gf"] = "copy_file_name",
              },
            },
          },
        },
      },
    },
  },
}

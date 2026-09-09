return {
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    lazy = false,

    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()

      local set = vim.keymap.set

      -- <C-n>: select word under cursor / add next occurrence
      set({ "n", "x" }, "<C-n>", function()
        mc.matchAddCursor(1)
      end)

      -- Add cursor vertically
      set({ "n", "x" }, "<M-Down>", function()
        mc.lineAddCursor(1)
      end)

      set({ "n", "x" }, "<M-Up>", function()
        mc.lineAddCursor(-1)
      end)

      -- These mappings only exist while multiple cursors are active.
      mc.addKeymapLayer(function(layerSet)
        -- vim-visual-multi:
        -- q = skip current match and go to next
        layerSet({ "n", "x" }, "q", function()
          mc.matchSkipCursor(1)
        end)

        -- vim-visual-multi:
        -- Q = remove current cursor/selection
        layerSet({ "n", "x" }, "Q", mc.deleteCursor)

        -- Esc = exit multicursor
        layerSet("n", "<Esc>", function()
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        end)
      end)
    end,
  },
}

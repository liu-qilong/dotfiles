local deepspace_path = "/Users/knpob/Library/Mobile Documents/iCloud~md~obsidian/Documents/DeepSpace"

local function current_markdown_dir()
  local bufname = vim.api.nvim_buf_get_name(0)

  if bufname ~= "" then
    return assert(vim.fs.dirname(bufname))
  end

  return assert(vim.fn.getcwd())
end

local function workspaces()
  local specs = {}

  -- when deepspace exists, add it and return
  if vim.uv.fs_stat(deepspace_path) then
    table.insert(specs, {
      name = "DeepSpace",
      path = deepspace_path,
      overrides = {
        frontmatter = { enabled = false },
      },
    })
    return specs
  end

  -- otherwise, add current markdown path as the workspace and return
  table.insert(specs, {
    name = "no-vault",
    path = current_markdown_dir,
    overrides = {
      frontmatter = { enabled = false },
    },
  })

  return specs
end

return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  ft = "markdown",
  -- dependencies = {
  --   "saghen/blink.cmp", -- declare blink as dependency
  -- },
  opts = function()
    return {
      legacy_commands = false,
      workspaces = workspaces(),
      completion = {
        -- nvim_cmp = false,
        -- blink = true,
        min_chars = 2,
      },
    }
  end,
}

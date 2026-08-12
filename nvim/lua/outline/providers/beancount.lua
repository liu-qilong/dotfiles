local M = {
  name = "beancount",
}

function M.supports_buffer(bufnr)
  return vim.bo[bufnr].filetype == "beancount"
end

local function parse_heading(line)
  -- Org-style:
  -- * Heading
  -- ** Subheading
  local stars, title = line:match("^(%*+)%s+(.+)$")
  if stars then
    return #stars, title
  end

  -- Beancount comment-style:
  -- ;;; Heading
  -- ;;;; Subheading
  local semis, comment_title = line:match("^(;;;+)%s+(.+)$")
  if semis then
    return #semis - 2, comment_title
  end
end

function M.request_symbols(callback, opts)
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  local root = { children = {} }
  local stack = {}
  local max_level = 0

  for i, line in ipairs(lines) do
    local level, title = parse_heading(line)

    if level and title then
      -- Close sections at this level or deeper.
      for j = level, max_level do
        local symbol = stack[j]
        if symbol then
          symbol.range["end"].line = i - 2
          stack[j] = nil
        end
      end

      -- Find nearest active parent.
      local parent = root.children
      for j = level - 1, 1, -1 do
        if stack[j] then
          parent = stack[j].children
          break
        end
      end

      local line_nr = i - 1 -- LSP/outline positions are 0-indexed

      local symbol = {
        name = title,
        kind = "Module",

        selectionRange = {
          start = { line = line_nr, character = 0 },
          ["end"] = { line = line_nr, character = #line },
        },

        range = {
          start = { line = line_nr, character = 0 },
          ["end"] = { line = line_nr, character = #line },
        },

        children = {},
      }

      table.insert(parent, symbol)
      stack[level] = symbol
      max_level = math.max(max_level, level)
    end
  end

  -- Extend remaining sections to EOF.
  local last_line = math.max(#lines - 1, 0)

  for _, symbol in pairs(stack) do
    symbol.range["end"].line = last_line
  end

  callback(root.children, opts)
end

return M

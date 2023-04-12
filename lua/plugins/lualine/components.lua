local M = {}

local foreground = ""
local add = ""
local delete = ""
local change = ""
local error = ""
local warn = ""
local hint = ""
local mode_color = {}

if vim.o.background == "dark" then
  foreground = "#BBC2CF"
  add = "#98BE65"
  delete = "#DB4B4B"
  change = "#7AA2F7"
  error = "#DB4B4B"
  warn = "#ECBE7B"
  hint = "#A9A1E1"
  mode_color = require("plugins.lualine.modes").dark_colors
else
  foreground = "#443D30"
  add = "#67519B"
  delete = "#24B4B4"
  change = "#855D08"
  error = "#24B4B4"
  warn = "#2E6576"
  mode_color = require("plugins.lualine.modes").light_colors
  hint = "#855D08"
end

local hide_in_width = function()
  return vim.fn.winwidth(0) > 80
end

M.mode = {
  function()
    -- I made it this way so it won't be hard to find the index
    local icons = {
      [1] = "",
      [2] = "",
      [3] = "",
      [4] = "",
      [5] = "",
      [6] = "",
      [7] = "",
      [8] = "",
      [9] = "",
      [10] = "", --> new icon
    }
    -- local mode_names = require("plugins.lualine.modes").name
    -- local mode_name = vim.api.nvim_get_mode().mode
    -- if mode_names[mode_name] == nil then
    --   return mode_name
    -- end
    -- return mode_names[mode_name]
    return icons[8]
  end,
  color = function()
    return { fg = mode_color[vim.api.nvim_get_mode().mode], bg = "NONE" }
  end,
}

M.diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  sections = { "error", "warn", "hint" },
  symbols = { error = " ", warn = " ", hint = " " },
  diagnostics_color = {
    error = { fg = error },
    warn = { fg = warn },
    hint = { fg = hint },
  },
  update_in_insert = false,
  always_visible = false,
  color = { fg = foreground, bg = "NONE" },
}

M.diff = {
  "diff",
  symbols = { added = " ", modified = " ", removed = " " },
  diff_color = {
    added = { fg = add },
    modified = { fg = change },
    removed = { fg = delete },
  },
  cond = hide_in_width,
  color = { fg = foreground, bg = "NONE" },
}

M.branch = {
  "branch",
  icons_enabled = true,
  color = { fg = foreground, bg = "NONE" },
  icon = " ",
}

M.filesize = {
  function()
    local function format_file_size(file)
      local size = vim.fn.getfsize(file)
      if size <= 0 then
        return ""
      end
      local sufixes = { " B", " KB", " MB", " GB" }
      local i = 1
      while size > 1024 do
        size = size / 1024
        i = i + 1
      end
      return string.format("%.1f%s", size, sufixes[i])
    end

    local file = vim.fn.expand("%:p")
    if string.len(file) == 0 then
      return ""
    end
    return format_file_size(file)
  end,
  color = { fg = foreground, bg = "NONE" },
}

M.lsp = {
  function()
    -- Initialize an empty table to store client names
    local clients = {}

    -- Iterate through all the clients for the current buffer
    for _, client in pairs(vim.lsp.buf_get_clients()) do
      -- Skip the client if its name is "null-ls"
      if client.name ~= "null-ls" then
        -- Add the client name to the `clients` table
        table.insert(clients, client.name)
      end
    end

    -- Call the `list_registered_formatters` function and store the result and error (if any)
    local formatters_ok, supported_formatters, _ = pcall(list_registered_formatters, vim.bo.filetype)

    -- Call the `list_registered_linters` function and store the result and error (if any)
    local linters_ok, supported_linters = pcall(list_registered_linters, vim.bo.filetype)

    -- If the call to `list_registered_formatters` was successful and there are more than 0 formatters registered
    if formatters_ok and #supported_formatters > 0 then
      -- Extend the `clients` table with the registered formatters
      vim.list_extend(clients, supported_formatters)
    end

    -- If the call to `list_registered_linters` was successful and there are more than 0 linters registered
    if linters_ok and #supported_linters > 0 then
      -- Extend the `clients` table with the registered linters
      vim.list_extend(clients, supported_linters)
    end

    -- If there are more than 0 clients in the `clients` table
    if #clients > 0 then
      -- Return the clients concatenated as a string, separated by commas
      return table.concat(clients, ", ")
    else
      -- Return the message "LS Inactive" if there are no clients
      return "LS Inactive"
    end
  end,
  color = { fg = foreground, bg = "NONE" },
}

M.progress = {
  function()
    local current_line = vim.fn.line(".")
    local total_lines = vim.fn.line("$")
    local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
    local line_ratio = current_line / total_lines
    local index = math.ceil(line_ratio * #chars)
    return chars[index]
  end,
  color = { fg = foreground, bg = "NONE" },
}

M.total_lines = {
  function()
    return "%L"
  end,
  color = { fg = foreground, bg = "NONE" },
}

M.percent = {
  "progress",
  color = { fg = foreground, bg = "NONE" },
}

M.spaces = {
  function()
    return vim.api.nvim_buf_get_option(0, "shiftwidth")
  end,
  color = { fg = foreground, bg = "NONE" },
}

M.filetype = {
  "filetype",
  color = { fg = foreground, bg = "NONE" },
  pading = 0,
}

M.filename = {
  "filename",
  icon = "",
  color = { fg = foreground },
  path = 4,
}

return M
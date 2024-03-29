-- Plugin configuration: indent-blankline
-- vim.g.indent_blankline_buftype_exclude = {'terminal'}
-- vim.g.indent_blankline_filetype_exclude = {'help', 'startify', 'dashboard', 'packer', 'neogitstatus'}
-- vim.g.indent_blankline_filetype_exclude = {'dashboard', 'help', 'packer', 'tex'}
-- vim.g.indent_blankline_char = '▏'
-- vim.g.indent_blankline_show_trailing_blankline_indent = false
vim.g.indent_blankline_context_patterns = {
    "class",
    "return",
    "function",
    "method",
    "^if",
    "^while",
    "jsx_element",
    "^for",
    "^object",
    "^table",
    "block",
    "arguments",
    "if_statement",
    "else_clause",
    "jsx_element",
    "jsx_self_closing_element",
    "try_statement",
    "catch_clause",
    "import_statement",
}

-- Map blankline
vim.g.indent_blankline_char = "┊"
vim.g.indent_blankline_filetype_exclude = {
    "help",
    "packer",
    "dashboard",
    "packer",
}
vim.g.indent_blankline_buftype_exclude = { "terminal", "nofile" }
vim.g.indent_blankline_char_highlight = "LineNr"
vim.g.indent_blankline_show_trailing_blankline_indent = false

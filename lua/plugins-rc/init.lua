-----------------------------------------------------------
-- configuration of plugins
-- 載入各擴充套件(plugins) 的設定
-----------------------------------------------------------
-- Lua initialization file
vim.cmd [[colorscheme nightfly]]
-- Load Which-key
-- 提供【選單】式的指令操作
require("config.plugins-rc.which-key")
-- Neovim kernel
require("config.plugins-rc.nvim-treesitter")

-- lsp
-- require("lsp")

-- status line
-- require("config.plugins-rc.lualine-material")
require("config.plugins-rc.tabline")

-- User Interface
require("config.plugins-rc.nvim-web-devicons")
require("config.plugins-rc.indent-blankline")
-- require("config.plugins-rc.nvim-lightbulb")

-- files management
require("config.plugins-rc.telescope-nvim")
-- require("my-telescope")
require("config.plugins-rc.nvim-tree")
-- require("config.plugins-rc.harpoon")

-- editting tools
require("config.plugins-rc.comment-nvim")
require("config.plugins-rc.nvim-ufo-rc")
require("config.plugins-rc.undotree")
require("config.plugins-rc.trim-nvim")
require("config.plugins-rc.autopairs")
require("config.plugins-rc.nvim-ts-autotag")
vim.cmd([[runtime lua.config.plugins-rc.vim-surround.rc.vim]])
vim.cmd([[runtime lua.config.plugins-rc.tagalong-vim.rc.vim]])

-- programming
require("config.plugins-rc.toggleterm")
require("config.plugins-rc.consolation-nvim")
require("config.plugins-rc.yabs")

-- versional control
require("config.plugins-rc.gitsigns")
require("config.plugins-rc.neogit")
require("config.plugins-rc.vim-gist")
-- vim.cmd([[ runtime lua.config.plugins-rc.vim-signify.rc.vim]])

-- Utilities
vim.cmd([[runtime lua.config.plugins-rc.vim-instant-markdown.rc.vim]])
vim.cmd([[runtime lua.config.plugins-rc.markdown-preview-nvim.rc.vim]])
vim.cmd([[runtime lua.config.plugins-rc.plantuml-previewer.rc.vim]])
vim.cmd([[runtime lua.config.plugins-rc.vimtex.rc.vim]])
vim.cmd([[runtime lua.config.plugins-rc.bracey.rc.vim]])

-- debug & unit testing
-- require("debugger")
-- require("unit-test")

-- AI tools
-- require("config.plugins-rc.ChatGPT-rc")

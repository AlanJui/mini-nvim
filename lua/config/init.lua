-----------------------------------------------------------
-- Global Functions
-- 為後續作業，需先載入之「共用功能（Global Functions）」。
-----------------------------------------------------------
require("config.globals")
require("config.utils")

-----------------------------------------------------------
-- Essential settings for Neovim
-- 初始時需有的 Neovim 基本設定
-----------------------------------------------------------
require("config.essential")

------------------------------------------------------------------------------
-- Configurations for Neovim
-- 設定 Neovim 的 Options
------------------------------------------------------------------------------
-- General options of Neovim
-- Neovim 執行時期，應有之預設
require("config.options")

-- User's specific options of Neovim
-- 使用者為個人需求，須變預設之設定
require("config.settings")

-----------------------------------------------------------
-- Key bindings
-- 快捷鍵設定：操作時的按鍵設定
-----------------------------------------------------------
require("config.keymaps")

-----------------------------------------------------------
-- Get configurations of DAP
-- 取得 DAP 設定結果
-----------------------------------------------------------
-- print("config.DAP = debugger/adapter/vscode-nodejs-dap")
-- print(require("config.debugger/adapter/vscode-nodejs-dap").show_config())

-----------------------------------------------------------
-- Experiments
-- 實驗用的臨時設定
-----------------------------------------------------------
-- require("config.utils/markdown")

-----------------------------------------------------------
-- code folding
-----------------------------------------------------------
-- vim.cmd([[
-- set foldmethod=indent
-- set foldnestmax=10
-- set nofoldenable
-- set foldlevel=5
-- ]])
-- Ref: https://www.jmaguire.tech/posts/treesitter_folding/
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
------------------------------------------------------------------------------
-- Test
------------------------------------------------------------------------------

-- Add local LuaRocks installation directory to package path
-- package.path = package.path .. ";~/.config/nvim/lua/rocks/?.lua"
-- package.path = package.path .. ";~/.config/nvim/lua/?.lua"
-- package.cpath = package.cpath .. ";~/.config/nvim/lua/rocks/?.so"
-- vim.cmd([[
-- luafile ~/.config/nvim/lua/my-chatgpt.lua
-- ]])


------------------------------------------------------------------------------
-- Initial Neovim environment
-- 初始階段
------------------------------------------------------------------------------
local my_nvim = os.getenv("MY_NVIM") or "nvim"
local is_debug = os.getenv("DEBUG") or false

local home_dir = os.getenv("HOME")
local config_dir = home_dir .. "/.config/" .. my_nvim
local runtime_dir = home_dir .. "/.local/share/" .. my_nvim
local cache_dir = home_dir .. "/.cache/" .. my_nvim

------------------------------------------------------------------------------
-- Setup Neovim Run Time Path
-- 設定 RTP ，要求 Neovim 啟動時的設定作業、執行作業，不採預設。
-- 故 my-nvim 的設定檔，可置於目錄： ~/.config/my-nvim/ 運行；
-- 執行作業（Run Time）所需使用之擴充套件（Plugins）與 LSP Servers
-- 可置於目錄： ~/.local/share/my-nvim/
------------------------------------------------------------------------------
local function join_paths(...)
	local PATH_SEPERATOR = vim.loop.os_uname().version:match("Windows") and "\\" or "/"
	local result = table.concat({ ... }, PATH_SEPERATOR)
	return result
end

local function print_rtp()
	print("-----------------------------------------------------------")
	-- P(vim.api.nvim_list_runtime_paths())
	local rtp_table = vim.opt.runtimepath:get()
	for k, v in pairs(rtp_table) do
		print("key = ", k, "    value = ", v)
	end
end

local function setup_run_time_environment()
	-- 變更kstdpath('config') 預設的 rtp : ~/.config/nvim/
	vim.opt.rtp:remove(join_paths(vim.fn.stdpath("data"), "site"))
	vim.opt.rtp:remove(join_paths(vim.fn.stdpath("data"), "site", "after"))
	vim.opt.rtp:prepend(join_paths(runtime_dir, "site"))
	vim.opt.rtp:append(join_paths(runtime_dir, "site", "after"))

	-- 變更 stdpath('data') 預設的 rtp : ~/.local/share/my-nvim/
	vim.opt.rtp:remove(vim.fn.stdpath("config"))
	vim.opt.rtp:remove(join_paths(vim.fn.stdpath("config"), "after"))
	vim.opt.rtp:prepend(config_dir)
	vim.opt.rtp:append(join_paths(config_dir, "after"))

	-- 引用 rpt 設定 package path （即擴充擴件(plugins)的安裝路徑）
	-- 此設定需正確，指令：require('<PluginName>') 才能正常執行。
	vim.cmd([[let &packpath = &runtimepath]])

	-- Change cahche dir
	vim.loop.os_setenv("XDG_CACHE_HOME", cache_dir)
end

-------------------------------------------------------------------------------
-- 插件管理器安裝及載入作業
-------------------------------------------------------------------------------
local lazy_dir = runtime_dir .. "/lazy"
local lazypath = lazy_dir .. "/lazy.nvim"

if vim.fn.isdirectory(lazypath) == 0 then
	vim.notify("  Installing lazy...", vim.log.levels.INFO, { title = "lazy.nvim" })
	vim.fn.system({
		"git",
		"clone",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end

vim.opt.runtimepath:prepend(lazypath)

local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
	return
end

vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct

local opts = {
	root = lazy_dir,
	install = {
		-- install missing plugins on startup. This doesn't increase startup time.
		missing = true,
		-- try to load one of these colorschemes when starting an installation during startup
		colorscheme = { "gruvbox", "onedark" },
	},
	lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json", -- lockfile generated after running update.
}

lazy.setup("plugins", opts)

-------------------------------------------------------------------------------
-- Main Program
-------------------------------------------------------------------------------

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 設定 Neovim 的執行環境
if my_nvim ~= "nvim" then
	-- 在「除錯」作業時，顯示 setup_rtp() 執行前、後， rtp 的設定內容。
	if is_debug then
		-- before RTP is changed
		print_rtp()
		-- show current cache path
		print("Cache path:", vim.fn.stdpath("cache"))
		-- change Neovm default RTP
		setup_run_time_environment()
		-- after new RTP is setuped
		print_rtp() -- Check if the cache directory was updated successfully
		print("Cache path:", vim.fn.stdpath("cache"))
	else
		-- change Neovm default RTP
		setup_run_time_environment()
	end
end

require("config")
require("plugins-loader")

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

local lazy_dir = runtime_dir .. "/lazy"
local lazypath = lazy_dir .. "/lazy.nvim"

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
-- Main Program
-------------------------------------------------------------------------------

-- 設定 Neovim 的執行環境
if is_debug then
  -- 在「除錯」作業時，顯示 setup_rtp() 執行前、後， rtp 的設定內容。
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

-------------------------------------------------------------------------------
-- Neovim 執行環境設定作業
-------------------------------------------------------------------------------
vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.maplocalleader = " "

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

------------------------------------------------------------------------------
-- 安裝擴充套件管理軟體及載入擴充套件
-- Install Plugin Manager & Plugins
-- 確保擴充套件管理器（Lazy.nvim）已完成安裝；以便擴充套件能正常安裝、更新。
--  ①  若擴充套件管理器：packer.nvim 尚未安裝，執行下載及安裝作業；
--  ②  透過擴充套件管理器，執行擴充套件 (plugins) 之載入／安裝作業。
------------------------------------------------------------------------------
require("config.plugins")

------------------------------------------------------------------------------
-- (2) 載入各擴充套件之設定
-- Setup configuration of plugins
-- 對已載入之各擴充套件，進行設定作業
------------------------------------------------------------------------------
setup_run_time_environment()
require("config.plugins-rc")
if is_debug then
  print("config module loaded!!")
  print_rtp()
end

----------------------------------------------------------------------------
-- configurations
----------------------------------------------------------------------------
local nvim_config = _G.GetConfig()

local function show_current_working_dir()
  -- Automatic change to working directory you start Neovim
  local my_working_dir = vim.fn.getcwd()
  print(string.format("current working dir = %s", my_working_dir))
  vim.api.nvim_command("cd " .. my_working_dir)
end

---@diagnostic disable-next-line: unused-function, unused-local
local function nvim_env_info() -- luacheck: ignore
  ----------------------------------------------------------------------------
  -- Neovim installed info
  ----------------------------------------------------------------------------
  print("init.lua is loaded!")
  print("Neovim RTP(Run Time Path ...)")
  ---@diagnostic disable-next-line: undefined-field
  _G.PrintTableWithIndent(vim.opt.runtimepath:get(), 4) -- luacheck: ignore
  print("====================================================================")
  print(string.format("OS = %s", nvim_config["os"]))
  print(string.format("Working Directory: %s", vim.fn.getcwd()))
  print("Configurations path: " .. nvim_config["config"])
  print("Run Time Path: " .. nvim_config["runtime"])
  print("Cache path:", vim.fn.stdpath("cache"))
  print(string.format("Plugins management installed path: %s", nvim_config.install_path))
  print("path of all snippets")
  _G.PrintTableWithIndent(nvim_config["snippets"], 4)
  print("--------------------------------------------------------------------")
end

---@diagnostic disable-next-line: unused-function, unused-local
local function debugpy_info()
  ----------------------------------------------------------------------------
  -- Debugpy installed info
  ----------------------------------------------------------------------------
  local venv = nvim_config["python"]["venv"]
  print(string.format("$VIRTUAL_ENV = %s", venv))
  local debugpy_path = nvim_config["python"]["debugpy_path"]
  if _G.IsFileExist(debugpy_path) then
    print("Debugpy is installed in path: " .. debugpy_path)
  else
    print("Debugpy isn't installed in path: " .. debugpy_path .. "yet!")
  end
  print("--------------------------------------------------------------------")
end

---@diagnostic disable-next-line: unused-function, unused-local
local function nodejs_info() -- luacheck: ignore
  ----------------------------------------------------------------------------
  -- vscode-js-debug installed info
  ----------------------------------------------------------------------------
  print(string.format("node_path = %s", nvim_config.nodejs.node_path))
  print(string.format("vim.g.node_host_prog = %s", vim.g.node_host_prog))
  local js_debugger_path = nvim_config["nodejs"]["debugger_path"]
  if _G.IsFileExist(js_debugger_path) then
    print(string.format("nodejs.debugger_path = %s", nvim_config.nodejs.debugger_path))
  else
    print("JS Debugger isn't installed! " .. js_debugger_path .. "yet!")
  end
  print(string.format("debugger_cmd = %s", ""))
  _G.PrintTableWithIndent(nvim_config.nodejs.debugger_cmd, 4)
  print("====================================================================")
end

-----------------------------------------------------------
-- Debug Tools
-- 除錯用工具
-----------------------------------------------------------

-- nvim_env_info()
-- show_current_working_dir()
-- debugpy_info()
-- nodejs_info()

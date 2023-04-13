------------------------------------------------------------------------------
-- Initial Neovim environment
-- 初始階段
------------------------------------------------------------------------------
local is_debug = os.getenv("DEBUG") or false
local nvim_appname = os.getenv("NVIM_APPNAME") or ""
-- local my_nvim = nvim_appname

-- local config_dir = os.getenv("XDG_CONFIG_HOME")
-- local runtime_dir = os.getenv("XDG_DATA_HOME")
-- local cache_dir = os.getenv("XDG_CACHE_HOME")

local my_nvim = os.getenv("MY_NVIM") or "nvim"
local home_dir = os.getenv("HOME")
local config_dir = home_dir .. "/.config/" .. my_nvim
local runtime_dir = home_dir .. "/.local/share/" .. my_nvim
local cache_dir = home_dir .. "/.cache/" .. my_nvim

local lazy_dir = runtime_dir .. "/lazy"
local lazypath = lazy_dir .. "/lazy.nvim"

if is_debug then
  print("===========================================================")
  print("My vars:")
  print("===========================================================")
  print(string.format("nvim_appname = %s", nvim_appname))
  print(string.format("my_nvim = %s", my_nvim))
  print(string.format("config_dir = %s", config_dir))
  print(string.format("runtime_dir = %s", runtime_dir))
  print(string.format("cache_dir = %s", cache_dir))
  print(string.format("lazy_dir = %s", lazy_dir))
  print(string.format("lazypath = %s", lazypath))
end

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

local function tprint(tbl, indent)
  if not indent then
    indent = 0
  end
  local toprint = string.rep(" ", indent) .. "{\n"
  indent = indent + 2
  for k, v in pairs(tbl) do
    toprint = toprint .. string.rep(" ", indent)
    if type(k) == "number" then
      toprint = toprint .. "[" .. k .. "] = "
    elseif type(k) == "string" then
      toprint = toprint .. k .. "= "
    end
    if type(v) == "number" then
      toprint = toprint .. v .. ",\n"
    elseif type(v) == "string" then
      toprint = toprint .. '"' .. v .. '",\n'
    elseif type(v) == "table" then
      toprint = toprint .. tprint(v, indent + 2) .. ",\n"
    else
      toprint = toprint .. '"' .. tostring(v) .. '",\n'
    end
  end
  toprint = toprint .. string.rep(" ", indent - 2) .. "}"
  return toprint
end

local function PrintTableWithIndent(table, indent_size)
  print(tprint(table, indent_size))
end

local function print_stdpath()
  print("====================================================================")
  print("vim.fn.stdpath('XXX')")
  print("====================================================================")
  print("Configurations path: " .. config_dir)
  print("stdpath('config') = " .. vim.fn.stdpath("config"))
  print("--------------------------------------------------------------------")
  print("Run Time Path: " .. runtime_dir)
  print("stdpath('data') = " .. vim.fn.stdpath("data"))
  print("--------------------------------------------------------------------")
  print("Cache path:", cache_dir)
  print("stdpath('cache') = " .. vim.fn.stdpath("cache"))
end

local function print_rtp()
  print("====================================================================")
  print("RTP Paths")
  print("====================================================================")
  -- P(vim.api.nvim_list_runtime_paths())
  local rtp_table = vim.opt.runtimepath:get()
  -- for k, v in pairs(rtp_table) do
  --   print("key = ", k, "    value = ", v)
  -- end
  PrintTableWithIndent(rtp_table, 4)
end

local function setup_run_time_environment()
  -- 變更kstdpath('config') 預設的 rtp : ~/.config/nvim/
  vim.opt.rtp:remove(join_paths(vim.fn.stdpath("data"), "site"))
  vim.opt.rtp:remove(join_paths(vim.fn.stdpath("data"), "site", "after"))
  -- vim.opt.rtp:prepend(join_paths(runtime_dir, "site"))
  -- vim.opt.rtp:append(join_paths(runtime_dir, "site", "after"))

  -- 變更 stdpath('data') 預設的 rtp : ~/.local/share/my-nvim/
  vim.opt.rtp:prepend(runtime_dir)

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

-- -- 設定 Neovim 的執行環境
-- if is_debug then
--   -- 在「除錯」作業時，顯示 setup_rtp() 執行前、後， rtp 的設定內容。
--   -- before RTP is changed
--   print_rtp()
--   -- show current cache path
--   print("Cache path:", vim.fn.stdpath("cache"))
-- end
--
-- -- change Neovm default RTP
-- setup_run_time_environment()
--
-- if is_debug then
--   -- after new RTP is setuped
--   print_rtp() -- Check if the cache directory was updated successfully
--   print("Cache path:", vim.fn.stdpath("cache"))
-- end

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
require("config")
require("config.lazy")
-- require("plugins-loader")

------------------------------------------------------------------------------
-- (2) 載入各擴充套件之設定
-- Setup configuration of plugins
-- 對已載入之各擴充套件，進行設定作業
------------------------------------------------------------------------------
setup_run_time_environment()
if is_debug then
  print("===========================================================")
  print("Lazy.nvim has been installed and loaded!!")
  print("===========================================================")
  print_stdpath()
  print_rtp()
end
-- require("plugins-rc")

-----------------------------------------------------------
-- Setup colorscheme
-- 設定作業環境配色
-----------------------------------------------------------
-- local name = "nightly"
--
-- local theme_ok = pcall(vim.cmd.colorscheme, name)
-- if not theme_ok then
--   vim.notify("The theme isn't installed or you had a typo", vim.log.levels.ERROR)
--   -- vim.cmd.colorscheme("habamax")
--   vim.cmd.colorscheme("gruvbox")
-- else
--   require("plugins.colorscheme." .. name)
-- end

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
  print("====================================================================")
  print("init.lua is loaded!")
  print("====================================================================")
  print(string.format("OS = %s", nvim_config["os"]))
  print(string.format("Working Directory: %s", vim.fn.getcwd()))
  print("--------------------------------------------------------------------")
  print(string.format("Plugins management installed path: %s", nvim_config.install_path))
  print("--------------------------------------------------------------------")
  print("path of all snippets")
  _G.PrintTableWithIndent(nvim_config["snippets"], 4)
end

---@diagnostic disable-next-line: unused-function, unused-local
local function list_rtp() -- luacheck: ignore
  ----------------------------------------------------------------------------
  -- List all path of RTP
  ----------------------------------------------------------------------------
  print("====================================================================")
  print("Neovim RTP(Run Time Path ...)")
  print("====================================================================")
  _G.PrintTableWithIndent(vim.opt.runtimepath:get(), 4) -- luacheck: ignore
end

---@diagnostic disable-next-line: unused-function, unused-local
local function debugpy_info()
  ----------------------------------------------------------------------------
  -- Debugpy installed info
  ----------------------------------------------------------------------------
  print("====================================================================")
  print("Debugpy")
  print("====================================================================")
  local venv = nvim_config["python"]["venv"]
  print(string.format("$VIRTUAL_ENV = %s", venv))
  local debugpy_path = nvim_config["python"]["debugpy_path"]
  if _G.IsFileExist(debugpy_path) then
    print("Debugpy is installed in path: " .. debugpy_path)
  else
    print("Debugpy isn't installed in path: " .. debugpy_path .. "yet!")
  end
end

---@diagnostic disable-next-line: unused-function, unused-local
local function nodejs_info() -- luacheck: ignore
  ----------------------------------------------------------------------------
  -- vscode-js-debug installed info
  ----------------------------------------------------------------------------
  print("====================================================================")
  print("Node.js Environment")
  print("====================================================================")
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
end

-----------------------------------------------------------
-- Debug Tools
-- 除錯用工具
-----------------------------------------------------------

-- nvim_env_info()
-- list_rtp()
-- show_current_working_dir()
-- debugpy_info()
-- nodejs_info()

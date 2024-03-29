------------------------------------------------------------------------------
-- Initial environments for Neovim
-- 初始階段
------------------------------------------------------------------------------
-- local my_nvim = os.getenv("NVIM_APPNAME") or ""
-- local is_debug = os.getenv("DEBUG") or false
local my_nvim = os.getenv("MY_NVIM") or "nvim"
local is_debug = false

local home_dir = os.getenv("HOME")
local config_dir = home_dir .. "/.config/" .. my_nvim
local runtime_dir = home_dir .. "/.local/share/" .. my_nvim
local cache_dir = home_dir .. "/.cache/" .. my_nvim

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

------------------------------------------------------------------------------
-- Setup Neovim Run Time Path
-- 設定 RTP ，要求 Neovim 啟動時的設定作業、執行作業，不採預設。
-- 故 my-nvim 的設定檔，可置於目錄： ~/.config/my-nvim/ 運行；
-- 執行作業（Run Time）所需使用之擴充套件（Plugins）與 LSP Servers
-- 可置於目錄： ~/.local/share/my-nvim/
------------------------------------------------------------------------------
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

---------------------------------------------------------------------
-- Main Process
---------------------------------------------------------------------
if my_nvim ~= "nvim" then
  -- 在「除錯」作業時，顯示 setup_rtp() 執行前、後， rtp 的設定內容。
  if is_debug then
    -- before RTP is changed
    print_stdpath()
    print_rtp()
    -- show current cache path
    print("Cache path:", vim.fn.stdpath("cache"))
    -- change Neovm default RTP
    setup_run_time_environment()
    -- after new RTP is setuped
    print_stdpath()
    print_rtp() -- Check if the cache directory was updated successfully
    print("Cache path:", vim.fn.stdpath("cache"))
  else
    -- change Neovm default RTP
    setup_run_time_environment()
  end
end

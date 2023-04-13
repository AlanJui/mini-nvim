-- Install plugins manager
-- https://github.com/folke/lazy.nvim
-- `:help lazy.nvim.txt` for more info
-- local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
local runtime_dir = os.getenv("XDG_DATA_HOME")
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

lazy.setup("plugins", {
  -- spec = {
  --   { import = "plugins" },
  --   { import = "plugins.extras.lang" },
  --   { import = "plugins.extras.db" },
  --   { import = "plugins.extras.ui" },
  --   { import = "plugins.extras.pde" },
  --   { import = "plugins.extras.pde.notes" },
  -- },
  root = lazy_dir,
  install = {
    -- install missing plugins on startup. This doesn't increase startup time.
    missing = true,
    -- try to load one of these colorschemes when starting an installation during startup
    colorscheme = { "gruvbox", "onedark" },
  },
  lockfile = runtime_dir .. "/lazy-lock.json", -- lockfile generated after running update.
})
vim.keymap.set("n", "<leader>zz", "<cmd>:Lazy<cr>", { desc = "Manage Plugins" })

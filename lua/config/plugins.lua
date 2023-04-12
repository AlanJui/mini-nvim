-----------------------------------------------------------------
-- 確認 lazy.nvim 套件已安裝，然後再「載入」及「更新」。
-----------------------------------------------------------------
local my_nvim = os.getenv("MY_NVIM") or "nvim"
local home_dir = os.getenv("HOME")
local runtime_dir = home_dir .. "/.local/share/" .. my_nvim

local lazy_dir = runtime_dir .. "/lazy"
local lazypath = lazy_dir .. "/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-----------------------------------------------------------------
-- 透過 packer 執行「擴充套件載入作業」
-----------------------------------------------------------------
local plugins_list = {
  -----------------------------------------------------------
  -- Essential plugins
  -----------------------------------------------------------
  -- lua functions that many plugins use
  "nvim-lua/plenary.nvim",
  -- Tools to migrating init.vim to init.lua
  "norcalli/nvim_utils",
  -----------------------------------------------------------
  -- Completion: for auto-completion/suggestion/snippets
  -----------------------------------------------------------
  -- A completion plugin for neovim coded in Lua.
  {
    -- Completion framework
    "hrsh7th/nvim-cmp",
    dependencies = {
      -- LSP completion source
      "hrsh7th/cmp-nvim-lsp",
      -- Useful completion sources
      "hrsh7th/cmp-nvim-lua", -- nvim-cmp source for buffer words
      "hrsh7th/cmp-buffer", -- nvim-cmp source for filesystem paths
      "hrsh7th/cmp-path", -- nvim-cmp source for math calculation
      "hrsh7th/cmp-calc",
      "hrsh7th/cmp-emoji",
      "hrsh7th/cmp-cmdline",
      -- LuaSnip completion source for nvim-cmp
      "saadparwaiz1/cmp_luasnip",
    },
  },
  -- Snippet Engine for Neovim written in Lua.
  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "<CurrentMajor>.*",
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
  },
  -- Snippets collection for a set of different programming languages for faster development
  "rafamadriz/friendly-snippets",
  -----------------------------------------------------------
  -- LSP/LspInstaller: configurations for the Nvim LSP client
  -----------------------------------------------------------
  {
    -- companion plugin for nvim-lspconfig that allows you to seamlessly
    -- install LSP servers locally
    "williamboman/mason.nvim",
    build = ":MasonUpdate", -- :MasonUpdate updates registry contents
  },
  {
    -- A collection of common configurations for Neovim's built-in language
    -- server client
    "neovim/nvim-lspconfig",
    "williamboman/mason-lspconfig.nvim",
    -- helps users keep up-to-date with their tools and to make certain
    -- they have a consistent environment.
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  -- LSP plugin based on Neovim build-in LSP with highly a performant UI
  {
    "glepnir/lspsaga.nvim",
    event = "LspAttach",
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      --Please make sure you install markdown and markdown_inline parser
      { "nvim-treesitter/nvim-treesitter" },
    },
  },
  --
  -- All in one LSP plugin (include auto-complete)
  --
  -- {
  --     "VonHeikemen/lsp-zero.nvim",
  --     branch = "v1.x",
  --     dependencies = {
  --         -- LSP Support
  --         { "neovim/nvim-lspconfig" }, -- Required
  --         { "williamboman/mason.nvim" }, -- Optional
  --         { "williamboman/mason-lspconfig.nvim" }, -- Optional
  --
  --         -- Autocompletion
  --         { "hrsh7th/nvim-cmp" }, -- Required
  --         { "hrsh7th/cmp-nvim-lsp" }, -- Required
  --         { "hrsh7th/cmp-buffer" }, -- Optional
  --         { "hrsh7th/cmp-path" }, -- Optional
  --         { "saadparwaiz1/cmp_luasnip" }, -- Optional
  --         { "hrsh7th/cmp-nvim-lua" }, -- Optional
  --
  --         -- Snippets
  --         { "L3MON4D3/LuaSnip" }, -- Required
  --         { "rafamadriz/friendly-snippets" }, -- Optional
  --
  --         -- Optional
  --         { "simrat39/rust-tools.nvim" },
  --     },
  -- },
  -- bridges gap b/w mason & null-ls
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "jose-elias-alvarez/null-ls.nvim",
    },
  },
  -- formatting & linting
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- stylua-nvim is a mini Lua code formatter
      "ckipp01/stylua-nvim",
    },
  },
  -- vscode-like pictograms for neovim lsp completion items Topics
  "onsails/lspkind-nvim",
  --
  -- automatically highlighting other uses of the current word under the cursor
  -- 'RRethy/vim-illuminate',
  --
  -- Support LSP CodeAction
  -- 'kosayoda/nvim-lightbulb',
  --
  -- additional functionality for typescript server
  -- (e.g. rename file & update imports)
  -- 'jose-elias-alvarez/typescript.nvim',

  -----------------------------------------------------------
  -- AI Tooles
  -----------------------------------------------------------
  -- AI code auto-complete
  "github/copilot.vim",
  "hrsh7th/cmp-copilot",
  -----------------------------------------------------------
  -- Treesitter: for better syntax
  -----------------------------------------------------------
  -- Nvim Treesitter configurations and abstraction layer
  {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  },
  -- 'nvim-treesitter/playground',
  -- Additional textobjects for treesitter
  -- 'nvim-treesitter/nvim-treesitter-textobjects',
  -----------------------------------------------------------
  -- colorscheme for neovim written in lua specially made for roshnvim
  -----------------------------------------------------------
  "bluz71/vim-nightfly-guicolors", -- preferred colorscheme
  "bluz71/vim-moonfly-colors",
  "shaeinst/roshnivim-cs",
  "mhartington/oceanic-next",
  "folke/tokyonight.nvim",
  -----------------------------------------------------------
  -- User Interface
  -----------------------------------------------------------
  -- Quick switch between files
  "ThePrimeagen/harpoon",
  -- maximizes and restores current window
  "szw/vim-maximizer",
  -- tmux & split window navigation
  "christoomey/vim-tmux-navigator",
  -- Add indentation guides even on blank lines
  "lukas-reineke/indent-blankline.nvim",
  -- Status Line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", opt = true },
  },
  {
    "kdheepak/tabline.nvim",
    require = { "hoob3rt/lualine.nvim", "nvim-tree/nvim-web-devicons" },
  },
  "arkav/lualine-lsp-progress",
  -- Utility functions for getting diagnostic status and progress messages
  -- from LSP servers, for use in the Neovim statusline
  "nvim-lua/lsp-status.nvim",
  -- Fuzzy files finder
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-live-grep-raw.nvim",
    },
  },
  -- Telescope Extensions
  -- 'cljoly/telescope-repo.nvim',
  "nvim-telescope/telescope-file-browser.nvim",
  "nvim-telescope/telescope-ui-select.nvim",
  "dhruvmanila/telescope-bookmarks.nvim",
  "nvim-telescope/telescope-github.nvim",
  -- Trying command palette
  "LinArcX/telescope-command-palette.nvim",
  {
    "AckslD/nvim-neoclip.lua",
    config = function()
      require("neoclip").setup()
    end,
  },
  -- dependency for better sorting performance
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    run = "make",
  },
  "jvgrootveld/telescope-zoxide",
  -- File explorer: vifm
  "vifm/vifm.vim",
  -- vs-code like icons
  "nvim-tree/nvim-web-devicons",
  -- File/Flolders explorer:nvim-tree
  {
    "kyazdani42/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- optional, for file icon
    },
  },
  -- Screen Navigation
  { "folke/which-key.nvim", lazy = true },
  -----------------------------------------------------------
  -- Git Tools
  -----------------------------------------------------------
  -- Git commands in nvim
  "tpope/vim-fugitive",
  -- Fugitive-companion to interact with github
  "tpope/vim-rhubarb",
  -- Add git related info in the signs columns and popups
  {
    "lewis6991/gitsigns.nvim",
    requires = { "nvim-lua/plenary.nvim" },
  },
  -- A work-in-progress Magit clone for Neovim that is geared toward the Vim philosophy.
  {
    "TimUntersberger/neogit",
    dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
  },
  -- for creating gist
  -- Personal Access Token: ~/.gist-vim
  -- token XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  { "mattn/vim-gist", dependencies = "mattn/webapi-vim" },
  -----------------------------------------------------------
  -- Editting Tools
  -----------------------------------------------------------
  -- To make Neovim's fold look modern and keep high performance.
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
  },
  -- replace with register contents using motion (gr + motion)
  -- 'inkarkat/vim-ReplaceWithRegister',
  -- surroundings: parentheses, brackets, quotes, XML tags, and more
  {
    "tpope/vim-surround",
    dependencies = { "tpope/vim-repeat" },
  },
  -- Toggle comments in Neovim
  -- 'tpope/vim-commentary',
  "numToStr/Comment.nvim",
  -- A Neovim plugin for setting the commentstring option based on the cursor
  -- location in the file. The location is checked via treesitter queries.
  "JoosepAlviste/nvim-ts-context-commentstring",
  -- Causes all trailing whitespace characters to be highlighted
  "cappyzawa/trim.nvim",
  -- Multiple cursor editting
  "mg979/vim-visual-multi",
  -- visualizes undo history and makes it easier to browse and switch between different undo branches
  "mbbill/undotree",
  -- Auto close parentheses and repeat by dot dot dot ...
  "windwp/nvim-autopairs",
  -- Use treesitter to autoclose and autorename html tag
  "windwp/nvim-ts-autotag",
  -- Auto change html tags
  "AndrewRadev/tagalong.vim",
  -----------------------------------------------------------
  -- Coding Tools
  -----------------------------------------------------------
  -- A pretty list for showing diagnostics, references, telescope results, quickfix and
  -- location lists to help you solve all the trouble your code is causing.
  {
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("trouble").setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      })
    end,
  },
  -- Yet Another Build System
  {
    "pianocomposer321/yabs.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  -- terminal
  "pianocomposer321/consolation.nvim",
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = true,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
    },
  },
  "nvim-neotest/neotest-plenary",
  "nvim-neotest/neotest-python",
  -----------------------------------------------------------
  -- DAP
  -----------------------------------------------------------
  {
    "mfussenegger/nvim-dap",
    -- bridges mason.nvim with the nvim-dap plugin - making it
    -- easier to use both plugins together.
    "jay-babu/mason-nvim-dap.nvim",
  },
  --
  -- Language specific exensions
  --
  -- DAP for Python
  "mfussenegger/nvim-dap-python",
  -- DAP for Lua work in Neovim
  "jbyuki/one-small-step-for-vimkind",
  -- DAP for Node.js (nvim-dap adapter for vscode-js-debug)
  -- 'mxsdev/nvim-dap-vscode-js", dependencies = { "mfussenegger/nvim-dap" } },
  -- {
  -- 	"microsoft/vscode-js-debug",
  -- 	opt = true,
  -- 	run = "npm install --legacy-peer-deps && npm run compile",
  -- },
  --
  -- DAP UI Extensions
  --
  -- UI for nvim-dap
  -- Install icons for dap-ui: https://github.com/ChristianChiarulli/neovim-codicons
  "folke/neodev.nvim",
  -- 'rcarriga/nvim-dap-ui',
  -- Reset nvim-dap-ui to a specific commit
  {
    "rcarriga/nvim-dap-ui",
    tag = "v3.6.4",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
  },

  -- Inlines the values for variables as virtual text using treesitter.
  "theHamsta/nvim-dap-virtual-text",
  -- -- Integration for nvim-dap with telescope.nvim
  "nvim-telescope/telescope-dap.nvim",
  -- UI integration for nvim-dat with fzf
  "ibhagwan/fzf-lua",
  -- nvim-cmp source for using DAP completions inside the REPL.
  "rcarriga/cmp-dap",
  -----------------------------------------------------------
  -- Utility
  -----------------------------------------------------------
  -- Floater Terminal
  "voldikss/vim-floaterm",
  -- Live server
  {
    "turbio/bracey.vim",
    run = "npm install --prefix server",
  },
  -- Open URI with your favorite browser from your most favorite editor
  "tyru/open-browser.vim",
  -- PlantUML
  "weirongxu/plantuml-previewer.vim",
  -- PlantUML syntax highlighting
  "aklt/plantuml-syntax",
  -- provides support to mermaid syntax files (e.g. *.mmd, *.mermaid)
  "mracos/mermaid.vim",
  -- Markdown support Mermaid
  -- 'iamcco/markdown-preview.nvim',
  -- install without yarn or npm
  {
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    setup = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
  -- Markdown preview
  -- 'instant-markdown/vim-instant-markdown',
  -- highlight your todo comments in different styles
  -- {
  -- 	'folke/todo-comments.nvim',
  -- 	dependencies = 'nvim-lua/plenary.nvim',
  -- 	config = function()
  -- 	    require('todo-comments').setup({
  --              -- configuration comes here
  --              -- or leave it empty to use the default setting
  -- 	    },
  -- 	end,
  -- },
  -----------------------------------------------------------
  -- LaTeX
  -----------------------------------------------------------
  -- Vimtex
  "lervag/vimtex",
  -- Texlab configuration
  {
    "f3fora/nvim-texlabconfig",
    config = function()
      require("texlabconfig").setup({
        cache_active = true,
        cache_filetypes = { "tex", "bib" },
        cache_root = vim.fn.stdpath("cache"),
        reverse_search_edit_cmd = "edit",
        file_permission_mode = 438,
      })
    end,
    ft = { "tex", "bib" },
    cmd = { "TexlabInverseSearch" },
  },
}

-----------------------------------------------------------------
-- Main Program
-----------------------------------------------------------------
local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
  return
end

local opts = {
  root = lazy_dir,
  install = {
    -- install missing plugins on startup. This doesn't increase startup time.
    missing = true,
    -- try to load one of these colorschemes when starting an installation during startup
    colorscheme = { "gruvbox", "onedark" },
  },
  lockfile = runtime_dir .. "/lazy-lock.json", -- lockfile generated after running update.
}

lazy.setup(plugins_list, opts)

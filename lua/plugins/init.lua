return {
  -----------------------------------------------------------
  -- Essential plugins
  -----------------------------------------------------------
  -- lua functions that many plugins use
  "nvim-lua/plenary.nvim",
  -- Tools to migrating init.vim to init.lua
  "norcalli/nvim_utils",
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts = {
      -- background_colour = "#A3CCBE",
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
    config = function(_, opts)
      require("notify").setup(opts)
      vim.notify = require("notify")
    end,
  },
  -- Add indentation guides even on blank lines
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      -- char = "▏",
      char = "│",
      filetype_exclude = { "help", "alpha", "dashboard", "NvimTree", "Trouble", "lazy" },
      show_trailing_blankline_indent = false,
      show_current_context = false,
    },
  },
  -- Toggle comments in Neovim
  {
    "numToStr/Comment.nvim",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    keys = { { "gc", mode = { "n", "v" } }, { "gcc", mode = { "n", "v" } }, { "gbc", mode = { "n", "v" } } },
    config = function(_, _)
      local opts = {
        ignore = "^$",
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      }
      require("Comment").setup(opts)
    end,
  },
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
  -- -- To make Neovim's fold look modern and keep high performance.
  -- {
  --   "kevinhwang91/nvim-ufo",
  --   dependencies = "kevinhwang91/promise-async",
  -- },
  -- replace with register contents using motion (gr + motion)
  -- 'inkarkat/vim-ReplaceWithRegister',
  -- surroundings: parentheses, brackets, quotes, XML tags, and more
  {
    "tpope/vim-surround",
    dependencies = { "tpope/vim-repeat" },
  },
  -- A Neovim plugin for setting the commentstring option based on the cursor
  -- location in the file. The location is checked via treesitter queries.
  -- "JoosepAlviste/nvim-ts-context-commentstring",
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
  -- Yet Another Build System
  {
    "pianocomposer321/yabs.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  -----------------------------------------------------------
  -- Utility
  -----------------------------------------------------------
  -- File explorer: vifm
  "vifm/vifm.vim",
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

{ ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    initLua = ''

      -- Transparent neovim, set after colorscheme
      local function set_transparent()
        vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
        -- Add other groups if needed, like SignColumn or LineNr
        vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
        vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
      end

      vim.opt.number = true
      -- vim.opt.wrap = false
      vim.opt.wrap = true -- temporary
      vim.opt.shiftwidth = 2
      vim.opt.softtabstop = 2
      vim.opt.tabstop = 2
      vim.opt.expandtab = true
      vim.opt.swapfile = false
      vim.opt.signcolumn = "yes"
      vim.g.mapleader=" "

      -- Status bar
      vim.cmd(":hi statusline guibg=NONE") -- Transparent status line
      -- vim.opt.laststatus = 0 -- hide bottom status bar
      -- vim.opt.winbar = "%f %m %= %l:%c" -- top status bar : [Filename] [Modified flag] [Right-aligned line:column]
      -- vim.opt.cmdheight = 0 -- Another part of status bar hidden until needed

      -- Keybinds
      -- Helix-like keybinds
      local map = vim.keymap.set
      local opts = { noremap = true, silent = true }

      -- Keep the selection after indenting
      map("x", "<", "<gv", opts)
      map("x", ">", ">gv", opts)

      -- Helix-like save and quit
      map("n", "<C-s>", "<cmd>write<cr>", { desc = "Save" })
      map("n", "<C-q>", "<cmd>quit<cr>", { desc = "Quit" })

      -- File navigation
      map("n", "gh", "0", { desc = "Start of line" }) -- This one is used by mini.diff, figure that out
      map("n", "gl", "$", { desc = "End of line" })
      map("n", "gs", "^", { desc = "First word of line" })
      map("n", "ge", "G", { desc = "End of file" })
      map("n", "gg", "gg", { desc = "Start of file" })
      map("n", "<leader>y", 'ggVG"+y', { desc = "Yank file to System Clipboard" })

      -- LSP actions
      map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
      map("n", "gr", vim.lsp.buf.references, { desc = "Find references" })
      map("n", "<leader>k", vim.lsp.buf.hover, { desc = "Hover documentation" })
      map("n", "<leader>a", vim.lsp.buf.code_action, { desc = "Code action" })
      map("n", "<leader>r", vim.lsp.buf.rename, { desc = "Rename symbol" })

      -- Diagnostics
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic", })
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic", })
      -- vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostic", })
      -- vim.keymap.set("n", "<leader>D", vim.diagnostic.setloclist, { desc = "Show file diagnostics", }) -- Replaced by Telescope

      -- sh (helix), read shell output into buffer
      vim.api.nvim_create_user_command(
        'Sh',
        function(opts)
          vim.cmd('read ! ' .. opts.args)
        end,
        { nargs = '+', desc = 'Read shell output into buffer' }
      )


      -- Plugin load
      vim.pack.add(
        {
          -- Depedency
      	  {src='https://github.com/nvim-mini/mini.diff', version="stable"},   -- mini.git
      	  {src='https://github.com/nvim-mini/mini.notify', version="stable"}, -- mini.git
          {src="https://github.com/nvim-lua/plenary.nvim"},                   -- telescope.nvim

          {src="https://github.com/vague2k/vague.nvim"}, -- Colorscheme
      	  {src="https://github.com/smoka7/hop.nvim"}, -- Press two characters first of a word to jump to
          {src="https://github.com/neovim/nvim-lspconfig"}, -- Pre-configured LSP settings
          {src="https://github.com/jake-stewart/multicursor.nvim"},

          {src="https://github.com/stevearc/oil.nvim"}, -- Emacs-like file explorer
          {src="https://github.com/nvim-telescope/telescope.nvim", version="*"}, -- File, Buffer, Jumplist picker

      	  -- Mini series
          -- {src="https://github.com/nvim-mini/mini.pick",       version="stable" }, -- File picker and grep picker -- Replaced by telescope.nvim
      	  {src='https://github.com/nvim-mini/mini.comment',    version="stable"},
      	  {src='https://github.com/nvim-mini/mini.completion',    version="stable"}, -- Completion
      	  {src='https://github.com/nvim-mini/mini-git',        version="stable"},   -- Productivity, maybe? I am used to lazygit
          {src = 'https://github.com/nvim-mini/mini.icons',    version = 'stable' }, -- Icons since I am lazy to install that system-wide
      	  {src='https://github.com/nvim-mini/mini.pairs',    version="stable"},

          -- FYP College Todo/Meeting Minutes requirement
      	  {src='https://github.com/nvim-treesitter/nvim-treesitter'}, -- Depedency for render-markdown
      	  {src='https://github.com/MeanderingProgrammer/render-markdown.nvim'},
          -- https://github.com/epwalsh/obsidian.nvim -- Not sure if this is needed
          
          -- https://github.com/nvim-mini/mini.files
          -- https://github.com/nvim-mini/mini.snippets
          -- Watch the videos on their README when wifi is fast enough
        }
      )


      -- Plugin setup/config
      vim.cmd("colorscheme vague")
      set_transparent()

      -- require("mini.pick").setup() -- Replaced by telescope.nvim
      require("mini.completion").setup()
      require("mini.diff").setup() -- Required for mini.git
      require("mini.notify").setup() -- Required for mini.git
      require("mini.git").setup()
      require('mini.icons').setup()
      require('mini.pairs').setup()

      -- Extend misc features
      require("hop").setup()
      require("multicursor-nvim").setup()

      -- File navigation
      require("oil").setup()
      require('telescope').setup()

      -- FYP College Todo/Meeting Minutes requirement
      require('render-markdown').setup()

      map('n', '<leader>f', ':Telescope find_files<CR>')
      map('n', '<leader>g', ':Telescope live_grep<CR>')
      map('n', '<leader>b', ':Telescope buffers<CR>')
      map('n', '<leader>d', ':Telescope diagnostics<CR>')

      map('n', '<leader>w', ':HopWord<CR>')
      map('n', '<leader>o', ':Oil<CR>')

      local mc = require("multicursor-nvim")
      map({"n", "x"}, "C", function() mc.lineAddCursor(1) end)
      map({"n"     }, "s", function() mc.matchAddCursor(1) end)
      map({"n", "x"}, ",", function() mc.clearCursors()   end)

      -- LSP Load (nvim-lspconfig)
      -- LSP is installed using Home Manager
      vim.lsp.enable(
        {
          "superhtml",
      	  "pyright",
      	  "nimlangserver",
          "tinymist",
        }
      )
    '';
  };
}

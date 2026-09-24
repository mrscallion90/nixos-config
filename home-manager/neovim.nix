{ ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    initLua = ''
      vim.opt.number = true
      vim.opt.wrap = false
      vim.opt.shiftwidth = 2
      vim.opt.softtabstop = 2
      vim.opt.tabstop = 2
      vim.opt.expandtab = true
      vim.opt.swapfile = false
      vim.opt.signcolumn = "yes"
      vim.cmd(":hi statusline guibg=NONE") -- Transparent status line
      vim.g.mapleader=" "

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

      -- LSP actions
      map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
      map("n", "gr", vim.lsp.buf.references, { desc = "Find references" })
      map("n", "<leader>k", vim.lsp.buf.hover, { desc = "Hover documentation" })
      map("n", "<leader>a", vim.lsp.buf.code_action, { desc = "Code action" })
      map("n", "<leader>r", vim.lsp.buf.rename, { desc = "Rename symbol" })

      -- Diagnostics
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic", })
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic", })
      vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostic", })
      vim.keymap.set("n", "<leader>D", vim.diagnostic.setloclist, { desc = "Show file diagnostics", })


      -- Plugin load
      vim.pack.add(
        {
          {src="https://github.com/vague2k/vague.nvim"}, -- Colorscheme
          {src="https://github.com/neovim/nvim-lspconfig"}, -- Pre-configured LSP settings
          {src="https://github.com/stevearc/oil.nvim"}, -- Emacs-like file explorer
      	  {src="https://github.com/smoka7/hop.nvim"}, -- Press two characters first of a word to jump to
      	  -- Mini series
          {src="https://github.com/nvim-mini/mini.pick",       version="stable" }, -- File picker and grep picker
      	  {src="https://github.com/nvim-mini/mini.completion", version="stable"},  -- Auto completion and LSP
      	  {src='https://github.com/nvim-mini/mini.comment',    version="stable"},
      	  {src='https://github.com/nvim-mini/mini.diff',       version="stable"},  -- Required for mini.git
      	  {src='https://github.com/nvim-mini/mini.notify',     version="stable"},  -- Required for mini.git
      	  {src='https://github.com/nvim-mini/mini-git',        version="stable"}   -- Productivity, maybe? I am used to lazygit

          -- [TODO] https://github.com/jake-stewart/multicursor.nvim -- add this guy later
          -- Also find org mode for neovim
        }
      )


      -- Plugin setup/config
      vim.cmd("colorscheme vague")

      require("mini.pick").setup()
      require("mini.completion").setup()
      require("mini.diff").setup() -- Required for mini.git
      require("mini.notify").setup() -- Required for mini.git
      require("mini.git").setup()

      require('mini.comment').setup()
      -- require('mini.comment').config = { comment="<C-c>" }

      require("hop").setup()
      require("oil").setup()

      -- Plugins keybinds
      map('n', '<leader>f', ':Pick files<CR>')
      map('n', '<leader>g', ':Pick grep<CR><CR>')
      map('n', '<leader>w', ':HopWord<CR>')


      -- LSP Load (nvim-lspconfig)
      -- LSP is installed using Home Manager
      vim.lsp.enable(
        {
          "superhtml",
      	  "pyright",
      	  "nimlangserver",
        }
      )
    '';
  };
}

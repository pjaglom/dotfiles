-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- <TAB> mapping option for Copilot. Source: https://github.com/orgs/community/discussions/52918
vim.g.copilot_assume_mapped = true

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Set shiftwidth to 4 spaces
vim.o.shiftwidth = 4

-- Set tabstop to 4 spaces
vim.o.tabstop = 4

-- Set softtabstop to 4 spaces 
vim.o.softtabstop = 4

-- Enable expandtab (use spaces instead of tabs)
vim.o.expandtab = true

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Prevent bad habits like using arrow keys for movement. Adapted from 
-- https://missing.csail.mit.edu/2020/editors/
-- Normal mode:
vim.api.nvim_set_keymap('n', '<Left>', ':echo "Use h"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Right>', ':echo "Use l"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Up>', ':echo "Use k"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Down>', ':echo "Use j"<CR>', { noremap = true, silent = true })
-- Insert mode:
vim.api.nvim_set_keymap('i', '<Left>', '<ESC>:echo "Use h"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<Right>', '<ESC>:echo "Use l"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<Up>', '<ESC>:echo "Use k"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<Down>', '<ESC>:echo "Use j"<CR>', { noremap = true, silent = true })

-- vim: ts=2 sts=2 sw=2 et

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ The Primeagen Recs - https://github.com/ThePrimeagen/init.lua/ ]]
-- Remap to open netrw file tree
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = 'Open netrw' })

-- allow you to move text up and down when selected in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = 'Move selected text down' })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = 'Move selected text up' })

-- keep cursor in same place when bringing text up with J
vim.keymap.set("n", "J", "mzJ`z", { desc = 'Bring text up to same line' })

-- keep cursor in middle of screen when scrolling with C-u and C-d
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- keep cursor in middle of screen when searching for text
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- when pasting over a highlight, keeps the original cut text in the register 
-- instead of replacing with the deleted highlighted text
vim.keymap.set("x", "<leader>p", [["_dP]])

-- yank into system clipboard (so can keep them separate but still access)
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- delete to void register (so it isn't available for pasting)
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

-- not sure what 'Q' does, but apparently it's bad, so this disables it
vim.keymap.set("n", "Q", "<nop>")

-- not totally sure how to use this one, but allows you to switch projects with
-- C-f, find new project and open it, then to come back, use C-a, then L
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- request formatting for the current buffer from the language server associated with the current filetype
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- quick fix navigation - allows you to quickly move between lsp/linter-identified errors
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- bring up substitution command to replace current text under cursor with 
-- arbitrary text you input - could be awesome for refactoring names
vim.keymap.set("n", "<leader>i", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- make current buffer executable (chmod +x)
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- vim: ts=2 sts=2 sw=2 et

-- [[ Custom setting options ]]
-- Primeagen Recs
-- let undotree go back days by saving undos (I think)
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Incremental search
vim.opt.incsearch = true

-- Scroll settings
vim.opt.scrolloff = 8

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

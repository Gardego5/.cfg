-- leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.showmode = false
vim.opt.relativenumber = true

vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)

vim.g.have_nerd_font = true

vim.opt.breakindent = true
vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.updatetime = 1250
vim.opt.timeoutlen = 300

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4

vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.cmdheight = 0

vim.opt.scrolloff = 2

-- ask for confirmation when doing things like `:q` with unsaved files
vim.opt.confirm = true

-- diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- buffers
vim.keymap.set("n", "H", "<cmd>bp<cr>", { desc = "Previous Buffer" })
vim.keymap.set("n", "L", "<cmd>bn<cr>", { desc = "Next Buffer" })

-- terminal mode exit easily
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- disable arrow keys in normal mode
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

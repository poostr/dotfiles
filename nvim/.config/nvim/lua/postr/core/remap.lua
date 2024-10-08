vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set('n', "<leader>rp", "<CMD>!tmux split-window -l 10 python %<CR> <Enter>", { desc = "Run python file"})
keymap.set({'n', 'v'}, "<M-c>", [["+y]])

-- buffer movement
-- keymap.set("n", "<leader>]", vim.cmd.bnext, { desc = "Next buffer"})
-- keymap.set("n", "<leader>[", vim.cmd.bprevious, { desc = "Previous biffer"})
keymap.set("n", "<leader>W", vim.cmd.bdelete, { desc = "Delete buffer"})
keymap.set("n", "<leader>bh", "<cmd>set showtabline=0<CR>", { desc = "[B]uffer [H]ide"})
keymap.set("n", "<leader>bs", "<cmd>set showtabline=2<CR>", { desc = "[B]uffer [S]how"})

-- copy all and select all
keymap.set("n", "<C-a>", "gg<S-v>G")
keymap.set('n', '<leader>Ya', "<cmd>%y+<CR>", { noremap = true }, { silent = true })


-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window
-- keymap.set("n", "<leader>w+", "3<C-w>_", { desc = "Increase the height of current split" })
-- keymap.set("n", "<leader>w+", "3<C-w>|", { desc = "Decrease the height of current split" })


-- Primgean remaps
keymap.set("n", "J", "mzJ`z")
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
keymap.set({ "n", "v" }, "<leader>y", [["+y]])
keymap.set("n", "<leader>Y", [["+Y]])

keymap.set({ "n", "v" }, "<leader>d", [["_d]])

keymap.set("n", "<leader>R", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

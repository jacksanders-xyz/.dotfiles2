-- FIRST WE GRAB OUR REMAP MODULE:
local Remap = require("jacksvimlua.remap-binder-helper")
local nnoremap = Remap.nnoremap
local vnoremap = Remap.vnoremap
local inoremap = Remap.inoremap
local xnoremap = Remap.xnoremap
local nmap = Remap.nmap

-- GENERAL VIM REMAPS

-- SCROLL
nnoremap("<C-E>", 'jzz')
nnoremap("<C-Y>", 'kzz')

-- EASIER SEARCH AND REPLACE
nnoremap("<leader>fr", ":%s/")
xnoremap("<leader>fr", ":s/")

-- ZEN
nnoremap("<leader>m", ":TZAtaraxis<CR>")

-- MAXIMIZER FOR VIMSPECTOR
nnoremap("<leader>,", "<cmd>MaximizerToggle!<CR>")

-- BUFFER MANAGEMENT
nnoremap("<leader>x", "<cmd>bd<CR>")
nnoremap("<leader>X", "<cmd>bd!<CR>")
nnoremap("<leader>n", "<cmd>bn!<CR>")
nnoremap("<leader>N", "<cmd>bN!<CR>")

-- Repeat last ex command
nnoremap("<leader>.", "@:")

-- YANK/PUT FROM/TO CLIPBOARD
vnoremap('<leader>y', '"*y')
nnoremap('<leader>p', '"*P')
vnoremap('<leader>p', '"*P')
inoremap('<c-p>', '<ESC>*Pi"')

-- MAKE Y BEHAVE LIKE ALL THE OTHER CAPITAL LETTERS
nnoremap("Y", "y$")

-- CENTER
nnoremap("n", "nzzzv")
nnoremap("N", "Nzzzv")
nnoremap("J", "mzJ`z")
nnoremap("<C-d>", "<C-d>zz")
nnoremap("<C-u>", "<C-u>zz")

-- SPELLCHECK TOGGLE IS <F4>
nnoremap('<leader>s', ':setlocal spell! spelllang=en_us<CR>"')

-- MOVING TEXT AROUND
vnoremap("J", ":m '>+1<CR>gv=gv")
vnoremap("K", ":m '<-2<CR>gv=gv")
inoremap("<C-k>", "<esc>:m .-2<CR>==")
inoremap("<C-j>", "<esc>:m .+1<CR>==")
nnoremap("<leader>j", ":m .+1<CR>==")
nnoremap("<leader>k", ":m .-2<CR>==")
nnoremap("]e", "I<CR><ESC>==")

-- NETRW
nnoremap("<leader>iv", ":Ex<CR>")
nnoremap("<leader>is", "<C-w><C-v>:Ex<CR>")

-- UNDOTREE
nnoremap("<leader>u", ":UndotreeToggle<CR>")

-- COMMANDS

-- REMAP W to :w
vim.api.nvim_create_user_command('W', 'write', {})

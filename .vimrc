""" Colorscheme
colorscheme desert

""" Sets
set incsearch
set hlsearch
set nu
set showmatch
set relativenumber
set tabstop=4
set smd
set nocompatible
set ic
syntax on

""" Maps
inoremap <C-s> <Esc>:w!<CR>a

imap <C-q> <Esc>:wq!<CR>
imap <C-d> <Esc>Vyp$i
imap <C-x> <Esc>Vda
imap <C-o> <Esc>:edit 

map <C-Tab>   gt
map <C-S-Tab> gT
map <C-q> :wq!<CR>
map <C-d> Vyp$
map <C-x> Vda
map <C-s> :w!<CR>

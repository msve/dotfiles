"""
" General
"""
set nocompatible

set history=700
filetype plugin on
filetype indent on
set autoread
" file save on buffer change (with eg :make)
set autowrite

let mapleader = ","
let g:mapleader = ","


"""
" User interface
"""
set so=7
set wildmenu
set wildignore=*.o,*~,*.puc,*.class
set ruler
set backspace=eol,start,indent
set whichwrap+=<,>,h,l
set ignorecase " ignore case when searching
set hlsearch
set incsearch
set lazyredraw " better redrawing logic when executing macros
set magic
set showmatch

set noerrorbells
set novisualbell
set t_vb=
set tm=500

set mouse=a
set mousehide


"""
" Colors and fonts
"""
syntax enable
colorscheme BusyBee

set background=dark
set encoding=utf8
set ffs=unix,dos,mac

if has("gui_running")
    set guioptions-=T
    set guioptions+=e
    set t_Co=256
    set guitablabel=%M\ %t
endif


"""
" Backups and undo
"""
set nobackup
set nowb
set noswapfile


"""
" Indenting
"""
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4
" linebreak on 500 chars
set lbr
set tw=500

set autoindent
set smartindent
set wrap


"""
" Spell checking
"""
" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" default spell checking
" set spell spelllang=en_us


"""
" Visual mode
"""
" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>


"""
" Status line
"""
set laststatus=2
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l

set showmode
set showcmd


"""
" Moving around
"""
" managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove<cr>

" Opens a new tab with the current buffer's path
" Useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/


"""
" Formatting
"""
" cislovani radku
set number

au BufWrite *.java :call DeleteTrailingWS()

au BufWrite *.h :call DeleteTrailingWS()
au BufWrite *.c :call DeleteTrailingWS()

au BufWrite *.py :call DeleteTrailingWS()

"""
" Helper functions
"""
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction


" Delete trailing whitespaces
function! DeleteTrailingWS()
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
endfunction

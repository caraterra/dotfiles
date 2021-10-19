"
" NeoVim Configuration
" Written by Alexander J Carter
"
" {{{ plugin installation

" Installs vim-plug if it is not already installed
let vimplug_exists=expand('~/.config/nvim/autoload/plug.vim')
let curl_exists=expand('curl')

if !filereadable(vimplug_exists)
	if !executable(curl_exists)
		echoerr "You have to install curl or first install vim-plug yourself!"
		execute "q!"
	endif
	echo "Installing Vim-Plug..."
	echo ""
	silent exec "!"curl_exists" -fLo " . shellescape(vimplug_exists) . " --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
	let g:not_finish_vimplug = "yes"
	autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.config/nvim/plugged')
	" Pretty things
	Plug 'vim-airline/vim-airline'
	Plug 'mhinz/vim-startify'
	Plug 'sheerun/vim-polyglot'
	" Themes
	Plug 'morhetz/gruvbox'
	Plug 'sainnhe/edge'
	Plug 'sainnhe/everforest'
	Plug 'sainnhe/sonokai'
	" Quality of life
	Plug 'tpope/vim-commentary'
	Plug 'SirVer/ultisnips'
	" Writing
	Plug 'lervag/vimtex', { 'for' : 'tex' }
	Plug 'reedes/vim-pencil', { 'for' : ['text', 'nroff', 'markdown', 'tex']}
call plug#end()

" Run PlugInstall if there are missing plugins
if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" }}}

" {{{ plugin settings
" airline
set noshowmode
let g:airline_powerline_fonts = 1
let g:airline_skip_empty_sections = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#whitespace#enabled = 0

" vimtex
let g:vimtex_compiler_progname = 'nvr'

" vim-pencil
let g:pencil#conceallevel = 0

" ultisnips
let g:UltiSnipsEditSplit="tabdo"

" }}}

" {{{ general settings
" colorscheme
set t_Co=256 termguicolors background=dark

let g:sonokai_style = 'maia'
let g:sonokai_enable_italic = 1
colorscheme sonokai

" clipboard
set clipboard+=unnamedplus

" indent
set tabstop=4 shiftwidth=4 smartindent
set showbreak=↪\
set listchars=tab:→\ ,eol:¬,space:·,trail:·,extends:›,precedes:‹

" input
set mouse=a
let mapleader = ","

" line numbers and relative line numbers
set nu rnu
nmap <silent> <Leader>ln :set rnu!<CR>

" search
nmap <silent> <esc> :noh<CR>

" splits
set fillchars+=vert:!
set splitright splitbelow
nmap - :split<CR>
nmap \| :vsplit<CR>

" swapfile
set noswapfile

" tabs
nmap <silent> <A-t> :tabnew<CR>
nmap <silent> <A-,> :tabprevious<CR>
nmap <silent> <A-.> :tabnext<CR>

"  highlights
hi! Normal ctermbg=none guibg=none
hi! NonText ctermbg=none ctermfg=8 guibg=none guifg=Gray
hi! EndOfBuffer ctermbg=none ctermfg=8 guibg=none guifg=Gray
hi! Folded ctermbg=none guibg=none
hi! VertSplit ctermbg=none guibg=none ctermfg=8 guifg=Gray
hi! LineNr ctermbg=none guibg=none
hi! CursorLineNr ctermbg=none guibg=none
hi! SignColumn ctermbg=none ctermfg=none guibg=none guifg=none
hi! Whitespace ctermbg=none ctermfg=8 guibg=none guifg=Gray
" }}}

" {{{ spell-checking and formatting
nnoremap <silent> <Leader>s :set spell!<CR>
autocmd Filetype noft,text,nroff,markdown,tex set spelllang=en_us
	\ | call pencil#init({'wrap': 'soft'})

" removes whitespace on save
au BufWritePre * :%s/\s\+$//e

set foldmethod=marker

" Add modeline to first line of buffer
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX files.
function! AppendModeline()
	let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d %set :",
		\ &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
	let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
	call append(line("0"), l:modeline)
endfunction
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>
" }}}

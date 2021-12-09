"
" NeoVim Configuration
" Written by Alexander J Carter
"
" TODO: Separate all this junk into separate files
" plugin installation

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
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'lifepillar/vim-solarized8'
Plug 'tpope/vim-commentary'
Plug 'SirVer/ultisnips'
Plug 'lervag/vimtex', { 'for' : 'tex' }
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/nvim-cmp'
Plug 'quangnguyen30192/cmp-nvim-ultisnips' " See if there are more configurations for this
Plug 'junegunn/limelight.vim'
Plug 'junegunn/goyo.vim'
Plug 'dense-analysis/ale'
call plug#end()

" Run PlugInstall if there are missing plugins
if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" plugin settings

" lualine
set noshowmode
lua << EOF
require'lualine'.setup {
	options = {
		icons_enabled = false,
		theme = 'solarized_dark',
		component_separators = { left = '', right = ''},
		section_separators = { left = '', right = ''},
		disabled_filetypes = {},
		always_divide_middle = true,
		},
	sections = {
		lualine_a = {'mode'},
		lualine_b = {'branch', 'diff'},
		lualine_c = {'filename'},
		lualine_x = {'encoding', 'fileformat', 'filetype'},
		lualine_y = {'progress'},
		lualine_z = {'location'}
		},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {'filename'},
		lualine_x = {'location'},
		lualine_y = {},
		lualine_z = {}
		},
	tabline = {},
	extensions = {}
	}
EOF

" treesitter
lua << EOF
require'nvim-treesitter.configs'.setup {
	highlight = {
		enable = true,
	},
	indent = {
		enable = true
	}
}
EOF

set completeopt=menu,menuone,noselect

lua <<EOF
-- setup nvim-cmp.
local cmp = require'cmp'

cmp.setup({
	snippet = {
		-- required - you must specify a snippet engine
		expand = function(args)
			-- vim.fn["vsnip#anonymous"](args.body) -- for `vsnip` users.
			-- require('luasnip').lsp_expand(args.body) -- for `luasnip` users.
			vim.fn["ultisnips#anon"](args.body) -- for `ultisnips` users.
			-- require'snippy'.expand_snippet(args.body) -- for `snippy` users.
end,
	},
mapping = {
		['<c-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
		['<c-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
		['<c-space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
		['<c-y>'] = cmp.config.disable, -- specify `cmp.config.disable` if you want to remove the default `<c-y>` mapping.
		['<c-e>'] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		['<cr>'] = cmp.mapping.confirm({ select = true }),
	},
	sources = cmp.config.sources({
		-- { name = 'nvim_lsp' },
		-- { name = 'vsnip' }, -- for vsnip users.
		-- { name = 'luasnip' }, -- for luasnip users.
		{ name = 'ultisnips' }, -- for ultisnips users.
		-- { name = 'snippy' }, -- for snippy users.
	}, {
		{ name = 'path'},
	}, {
		{ name = 'buffer' },
	}
	)
})
EOF

"  general settings
" colorscheme
set t_Co=256 termguicolors background=dark

colorscheme solarized8

" clipboard
set clipboard+=unnamedplus

" indent
set title
set tabstop=4 shiftwidth=4 smartindent
set showbreak=↪\
set listchars=tab:→\ ,eol:¬,space:·,trail:·,extends:›,precedes:‹
set lazyredraw

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
function! HighlightAll()
	hi! Normal ctermbg=none guibg=none
	hi! NonText ctermbg=none ctermfg=8 guibg=none guifg=Gray
	hi! EndOfBuffer ctermbg=none ctermfg=8 guibg=none guifg=Gray
	hi! Folded ctermbg=none guibg=none
	hi! VertSplit ctermbg=none guibg=none ctermfg=8 guifg=Gray
	hi! LineNr ctermbg=none guibg=none
	hi! CursorLineNr ctermbg=none guibg=none
	hi! SignColumn ctermbg=none ctermfg=none guibg=none guifg=none
	hi! Whitespace ctermbg=none ctermfg=8 guibg=none guifg=Gray
endfunction
call HighlightAll()

"  spell-checking and formatting
nnoremap <silent> <Leader>s :set spell!<CR>
au Filetype noft,text,nroff,markdown,tex set spelllang=en_us

" Add modeline to first line of buffer
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX files.
function! AppendModeline()
	let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d %set :",
				\ &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
	let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
	call append(line("0"), l:modeline)
endfunction
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>

" limelight
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_guifg = '#1C4954'
let g:limelight_default_coefficient = 0.2
nnoremap <silent> <Leader>z :Limelight!!<CR>

" goyo
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight! | call HighlightAll()
nnoremap <silent> <Leader>Z :Goyo<CR>

" vimtex
let g:vimtex_compiler_progname = 'nvr'

" ale
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0

let b:ale_linters = {
	\ 'c':['cppcheck --language=c --std=c89 --std=posix --enable=all --platform=unix64 --template=gcc',
	\		'gcc'],
	\ 'cpp':['cppcheck --language=c++ --std=c++11 --std=posix --enable=all --platform=unix64 --template=gcc',
	\		'gcc'],
	\ 'sh':['shellcheck -fgcc -Cnever -ssh',
	\		'sh -n'],
	\ }

let b:ale_fixers = {
	\ '*': ['remove_trailing_lines', 'trim_whitespace'],
	\ 'c': ['astyle -A3 -t -p -H -U -k3 -xC80'],
	\ 'cpp':['astyle -A3 -t -p -H -U -k3 -xC80']
	\ }

call pathogen#runtime_append_all_bundles() 
call pathogen#helptags()

if has('gui_running')
	set guioptions-=T  " no toolbar
	set columns=150
	set lines=50
	set guifont=Droid\ Sans\ Mono\ 9
endif
" set autochdir
let moria_fontface='mixed'
let moria_style='dark'
set background=dark
colorscheme solarized
" colorscheme molokai
" colorscheme moria
set number
set tabstop=4
set shiftwidth=4
set nowrap
set showmatch                   " Show matching brackets/braces/parantheses.
set confirm
set number
set foldmethod=syntax
set foldenable
set foldlevel=1
set expandtab
set autoindent
set cindent
set makeprg=make\ -j4
set hlsearch "use * command!
set incsearch
set switchbuf=usetab,newtab " when errors during make => look in existing tabs otherwise open a new tab
set laststatus=2 " Always show the status line

filetype plugin on
map <C-F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

fu Select_Ruby_Style()
	set sw=2
	set tabstop=2
endf

fu Select_Python_Style()
	set expandtab
endf

fu Build(path)
    echo "Building in '" a:path "'"
    exe 'cd' a:path
    make
    cd ..
endf

fu Run_Make()
    if isdirectory("build")
        call Build("build")
    elseif isdirectory("CMakeDebug")
        call Build("CMakeDebug")
    elseif isdirectory("CMakeBuild")
        call Build("CMakeBuild")
    else
        echo "No build directory found!"
    endif
endf

au BufRead,BufNewFile *.rb,*.erb call Select_Ruby_Style()
au BufRead,BufNewFile *.py,*.pyw call Select_Python_Style()

" Use the below highlight group when displaying bad whitespace is desired.
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

map <C-c> :TlistToggle<cr>
map <C-b> :call Run_Make()<cr>
nmap <Leader>f :call SearchRecursive()<cr>

set wildignore+=*.o,*.git,build/**,CMakeBuild/**,CMakeDebug/**

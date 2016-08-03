" vimrc for Vim(Version:7.4)
" Author: Kohei kanno.
" Last Modified: 02-Aug-2016.
" Source: https://github.com/kohei-moriwaki0330

" Prefix {{{
" Leader
let g:mapleader='[Leader]'
let g:maplocalleader="\<Space>"
noremap [Leader] <Nop>
map <Space> [Leader]
noremap [Leader]<Space> <Nop>
map <LocalLeader> [Leader]
noremap [Leader]<LocalLeader> <Nop>
" Unite
nnoremap [Unite] <Nop>
nmap , [Unite]
" Tab
nnoremap [Tab] <Nop>
nmap t [Tab]
" Cscope
noremap [Cscope] <Nop>
nmap <C-\> [Cscope]
" }}} End of Prefix

" Cscope {{{
cs add ~/kanno/Tool/.cscope/View/cscope.out
cs add ~/kanno/Tool/.cscope/Model/cscope.out
cs add ~/kanno/Tool/.cscope/Etc/cscope.out
cs add ~/kanno/Tool/.cscope/Framework/cscope.out
cs add ~/kanno/Tool/.cscope/Nmsystem/cscope.out
" }}} End of Cscope

" Mappings {{{
" Wrapped lines goes down/up to next row, rather than next line in file.
nnoremap j gj
nnoremap k gk
" Goes to Another window
nnoremap <Tab> <C-W>w
" Open HelpText
nnoremap <silent> <Leader>h :<C-u>botright vs ~/.vim/bundle/help.jax<CR>
" gf
nnoremap gf :<C-u>execute 'tabfind ' .expand('<cfile>')<CR>
" Set relativenumber or no relativenumber.
nnoremap <silent> <Leader>rel :<C-u>set relativenumber! relativenumber?<CR>
" Escope InserMode
inoremap <silent> jj <ESC>
" Breakline with Enter
"nnoremap <CR> o<ESC>
" Get info ( get the total of lines, words, chars and bytes )
nnoremap <Leader>gi g<C-G>
" Shortcut to rapildly toggle ' set list'
nnoremap <silent> <Leader>l :<C-u>set list! list?<CR>
" Cscope
"   's'   symbol: find all references to the token under cursor
"   'g'   global: find global definition(s) of the token under cursor
"   'c'   calls:  find all calls to the function name under cursor
"   't'   text:   find all instances of the text under cursor
"   'e'   egrep:  egrep search for the word under cursor
"   'f'   file:   open the filename under cursor
"   'i'   includes: find files that include the filename under cursor
"   'd'   called: find functions that function under cursor calls
nmap [Cscope]s :tab cs find s <C-R>=expand("<cword>")<CR><CR>
nmap [Cscope]g :tab cs find g <C-R>=expand("<cword>")<CR><CR>
nmap [Cscope]c :tab cs find c <C-R>=expand("<cword>")<CR><CR>
nmap [Cscope]t :tab cs find t <C-R>=expand("<cword>")<CR><CR>
nmap [Cscope]e :tab cs find e <C-R>=expand("<cword>")<CR><CR>
nmap [Cscope]f :tab cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap [Cscope]i :tab cs find i <C-R>=expand("<cfile>")<CR><CR>
nmap [Cscope]d :tab cs find d <C-R>=expand("<cword>")<CR><CR>
" Tab
nnoremap <silent> [Tab]c :tablast <bar> tabnew %<CR>
nnoremap <silent> [Tab]f :tablast <bar> tabnew .<CR>
nnoremap <silent> [Tab]d :tabclose<CR>
nnoremap <silent> [Tab]l :tabnext <CR>
nnoremap <silent> [Tab]h :tabprevious<CR>
for s:n in range(1,9)
    execute 'nnoremap <silent> [Tab]'.s:n ':<C-u>tabnext'.s:n.'<CR>'
endfor
unlet s:n
" Buffer
nnoremap <silent> [Tab]] :<C-u>buffers<CR>
nnoremap <silent> [Tab]n :<C-u>bnext<CR>
nnoremap <silent> [Tab]p :<C-u>bprevious<CR>
nnoremap <silent> [Tab]D :<C-u>bdelete<CR>
" Use command-line window
nnoremap <Leader>: q:
vnoremap <Leader>: q:

" }}} End of Mappings

" release autogroup in MyAutoCmd {{{
augroup MyAutoCmd
    autocmd!
augroup END
" Autocmd Settings
command! -nargs=* Autocmd autocmd MyAutoCmd <args>
command! -nargs=* AutocmdFT autocmd MyAutoCmd FileType <args>
"Open & AutoReload .vimrc
command! EVimrc e $MYVIMRC
command! ETabVimrc tabnew $MYVIMRC
command! SoVimrc source $MYVIMRC
Autocmd BufWritePost *vimrc source $MYVIMRC
Autocmd BufWritePost *gvimrc if has('gui_running') source $MYVIMRC
" Close Vim help by q
AutocmdFT help nnoremap <buffer> q <C-w>c
AutocmdFT help nnoremap <buffer> ;q q
AutocmdFT help nnoremap <buffer> Q q
" 最後のカーソル位置に戻る
autocmd MyAutoCmd BufRead * silent! execute'normal! `"zv'
" :make実行後、自動でQuickfixウィンドウを開く
autocmd MyAutoCmd QuickfixCmdPost make if len(getqflist()) != 0 | copen | endif
" 最後のWindowのbuftypeがQuickFixであれば、自動で閉じる
autocmd MyAutoCmd WinEnter * if winnr('$') == 1 && &buftype == 'quickfix' | quit | endif
" Include Guard
au BufNewFile *.h call IncludeGuard()
" Resize splits when the window is resized
Autocmd VimResized * :wincmd=
" Comand-Line-Window
Autocmd CmdwinEnter * call s:init_cmdwin()
" Save as root
cnoreabbrev w!! w !sudo tee > /dev/null %
" }}
"}}} End of MyAutoCmd

" Echo startup time on start {{{
if has('vim_starting') && has('reltime')
    let g:startuptime=reltime()
    Autocmd VimEnter * let g:startuptime=reltime(g:startuptime) | 
    \redraw | echomsg 'startuptime: '. reltimestr(g:startuptime)
endif
" }}} End of Echo startup time

" NeoBundle {{{
filetype plugin indent off
if ! isdirectory(expand('~/.vim/bundle'))
    echon 'Installing neobundle.vim'
    silent call mkdir(expand('~/.vim/bundle'), 'p')
    silent !git clone://github.com/Shougo/neobundle.vim $HOME/.vim/bundle/neobundle.vim
    echo 'done.'
    if v:shell_error
        echoerr 'neobundle.vim installation has failed!'
        finish
    endif
endif
if has('vim_starting')
    set nocompatible
    set runtimepath& runtimepath+=~/.vim/bundle/neobundle.vim/
endif
call neobundle#begin(expand('~/.vim/bundle'))
"filetype plugin indent on
" }}} End of NeoBundle

" Basic {{{
set encoding=japan "Sets the character encoding used inside Vim.
set fileencodings=japan,utf-0,euc-jp,sjis "A list of character encodings.
set termencoding=japan,utf-0,euc-jp,sjis "Automatically detected character encodings
set fileformats=unix,dos " This gives the end-of-line(<EOL>) formats.
set title "Sets the title used inside Vim.
set expandtab "Use the appropriate number of spaces to insert a <Tab>.
set tabstop=4 "Number of spaces that a <Tab> in the file counts for.
set shiftwidth=4 "Number of spaces to use for each step of (auto)indent.
set list listchars=tab:>-,trail:-,extends:>,precedes:< "Use the same symbols as TextMate for tabstops
set cinoptions=:0,p0,t0 "Options for C-indent
set cinwords=if,else,while,do,for,switch,case "list of words that cause more C-indent
set number "Setting Column Number
set hlsearch | nohlsearch "Highlight search patterns, suport reloading.
set infercase " Ignore case on insert completion.
set incsearch " From before you confirm with the enter key, or do a search.
set ignorecase " It doesn't distinguish with upper / lower character.
set smartcase " Override the ignorecase option if the pattern contains upper case.
set wrap "Lines longer than the width of the window will wrap.
set wrapscan " Searches wrap around the end of the file.
set laststatus=2 showtabline=2 " Always dispaly statusline/tabline.
set display=lastline " Display as much as possible of the last line.
set noequalalways " Don't auto resize Window.
set showcmd " Display input command.
set showmatch "Briefly jump to the matching one.
"set ttytype=builtin_xterm " Setting the terminal type.
set helpheight=12 "minimal intial height of the help window
set helplang=ja " Setting the help language.
set keywordprg=:help " Open vim internal help by k command
set background=dark "Setting the Vim background.
set t_Co=256 "Number of colors
set nobackup " Don't make a backup file before overwriting a file.
set noswapfile " Don't make a swap file before overwriting a file.
set autoread "Automatically read file again which has been changed outside of Vim.
set cmdheight=1 "Number of screen lines to use for the command-line.
set cmdwinheight=5 "Number of screen lines to use for the command-line window.
set completeopt-=preview "Do not use preview window
set diffopt+=iwhite
set grepprg=internal "Program to use for the :grep command.
set hidden " Display anather buffer when current buffer isn't saved.
set spelllang=en,cjk "Spell checking language.
"set relativenumber "Show the relative line number for each line
set cursorline "Emphasize the cursorline
set timeout timeoutlen=1000 ttimeoutlen=100 "Setting timeoutlent(<Leader>) or ttimeoutlen(Esc)
set wildmenu wildmode=list:longest,full "Shows all the vim options
set wildignore& "A file that matches with one of these patterns is ignored
set wildignore+=*.sw? "Vim swap files
set wildignore+=*.bak,*.?~,*.??~,*.???~,*.~ "Backup files
set wildignore+=*.luac "Lua byte code
set wildignore+=*.jar  "Java archives
set wildignore+=*.pyc  "Pythons byte code
set wildignore+=*.states "Pylint stats
syntax enable
" }}} End of Basic

" Plugins {{{
runtime! plugins/*.vim

" Neobundle {{
NeoBundleFetch 'Shougo/neobundle.vim'
" }}

" Unite {{
NeoBundleLazy 'Shougo/unite.vim', {'on_cmd' : 'Unite'}
NeoBundleLazy 'Shougo/neomru.vim', {'on_source' : 'unite.vim'}
NeoBundleLazy 'tsukkee/unite-help', {'on_source' : 'unite.vim'}
NeoBundleLazy 'ujihisa/unite-colorscheme', {'on_source' : 'unite.vim'}
NeoBundleLazy 'hewes/unite-gtags', {'on_source' : 'unite.vim'}
NeoBundleLazy 'Shougo/vimfiler.vim', {'depends' : 'Shougo/unite.vim', 'on_path' : '.*'}
" }}

" Document {{
NeoBundle 'vim-jp/vimdoc-ja'
NeoBundleLazy 'vim-scripts/Conque-GDB', {'on_cmd' : 'ConqueGdb'}
" }}

" Writing {{
NeoBundle 'Shougo/neocomplcache.vim'
NeoBundleLazy 'tyru/caw.vim', {'on_map' : ['<Plug>(caw:']}

" }}

" Application {{
NeoBundleLazy 'itchyny/calendar.vim', {'commands' : ['Calendar']}
" }}

" Operator {{
NeoBundleLazy 'kana/vim-operator-user'
" }}

" Text Object {{
NeoBundleLazy 'kana/vim-textobj-user'

NeoBundleLazy 'kana/vim-textobj-function', {
    \   'depends'   :   'kana/vim-textobj-user',
    \   'on_map'    :   [['xo', 'if', 'af', 'iF', 'aF']],
    \ }
NeoBundleLazy 'sgur/vim-textobj-parameter', {
    \   'depends'   :   'kana/vim-textobj-user',
    \   'on_map'    :   [['xo', 'i,', 'a,']],
    \ }
" }}

" UI {{
NeoBundle 'cocopon/lightline-hybrid.vim'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'osyo-manga/vim-brightest'
NeoBundleLazy 'nathanaelkane/vim-indent-guides', {'on_cmd' : 'IndentGuidesToggle'}
" }}

" Colorscheme {{
NeoBundle 'tomasr/molokai'
" }}

" Motion {{
NeoBundle 'vim-scripts/sudo.vim'
NeoBundleLazy 'toshi32tony3/vim-repeat'
NeoBundleLazy 'haya14busa/incsearch.vim'
NeoBundleLazy 'Lokaltog/vim-easymotion', {'on_map' : '<Plug>'}
NeoBundleLazy 'deris/vim-shot-f', {'on_map' : '<Plug>'}
" }}

" Network {{
NeoBundleLazy 'tyru/open-browser.vim', {
    \   'on_map'    :   '<Plug>(open',
    \   'on_cmd'    :   ['OpenBrowserSearch'],
    \ }
" }}

" Extend Basic Vim Commands {{
NeoBundle 'mhinz/vim-startify'
NeoBundleLazy 'vim-scripts/a.vim'
NeoBundleLazy 'haya14busa/vim-asterisk', {'on_map' : '<Plug>'}
NeoBundleLazy 'osyo-manga/vim-anzu', {'on_map' : '<Plug>' }
" }}
call neobundle#end()

" }}} End of Plugins

" Shougo/unite.vim {{
if neobundle#tap('unite.vim')
    function! neobundle#tapped.hooks.on_source(bundle)
        let g:unite_source_history_yank_enable=0
        let g:unite_kind_jump_list_after_jump_scroll=0
        let g:unite_enable_start_ignore_case=1
        let g:unite_enable_smart_case=1
        let g:unite_enable_start_insert=1
        let g:unite_source_rec_min_cache_files=1000
        let g:unite_source_rec_max_cache_files=5000
        let g:unite_source_file_mru_long_limit=6000
        let g:unite_source_file_mru_long_limit=6000
        let g:unite_source_directory_mru_limit=500
        let g:unite_winheight=25
        let g:unite_prompt='$'
        let g:unite_source_file_mru_filename_format=' '
        let g:unite_source_file_mru_limit=50
        let g:unite_enable_split_vertically=0
        let g:unite_split_rule='botright'
    endfunction

    nnoremap <silent> [Unite]u :<C-u>Unite<CR>
    nnoremap <silent> [Unite]f :<C-u>Unite file<CR>
    nnoremap <silent> [Unite]b :<C-u>Unite -silent buffer file_mru bookmark<CR>
    nnoremap <silent> [Unite]r :<C-u>UniteResume<CR>
    nnoremap <silent> [Unite]g :<C-u>Unite -silent -no-quit grep<CR>
    nnoremap <silent> [Unite]r :<C-u>Unite runtimepath<CR>
    nnoremap <silent> [Unite]c :<C-u>Unite -auto-preview colorscheme<CR>
    nnoremap <silent> [Unite]s :<C-u>Unite source<CR>
    nnoremap <silent> [Unite]h :<C-u>Unite help<CR>
    nnoremap <silent> [Unite]ma :<C-u>Unite -silent mapping<CR>
    nnoremap <silent> [Unite]me :<C-u>Unite -silent output:message<CR>

    autocmd FileType unite call s:unite_my_settings()
    function! s:unite_my_settings()
        imap <buffer> jj <Plug>(unite_insert_leave)
        imap <buffer> kk <Plug>(unite_insert_leave)
        nmap <buffer> <ESC> <Plug>(unite_exit)
    endfunction
    call neobundle#untap()
endif
" }}

" ujihisa/unite-colorscheme {{
if neobundle#tap('unite-colorscheme')
    command! -nargs=* BeautifulAttack Unite colorscheme -auto-preview -winheight=3
    call neobundle#untap()
endif
" }}

" vim-scripts/Conque-GDB {{
if neobundle#tap('Conque-GDB')
    function! neobundle#tapped.hooks.on_source(bundle)
        let g:ConqueTerm_Color=2
        let g:ConqueTerm_CloseOnEnd=1
        let g:ConqueTerm_StartMessages=0
    endfunction
    call neobundle#untap()
endif
" }}

" Shougo/vimfiler {{
if neobundle#tap('vimfiler.vim')
    function! neobundle#tapped.hooks.on_source(bundle)
        let g:vimfiler_as_default_explorer=1
        let g:vimfiler_fource_overwrite_statusline=0
    endfunction

    autocmd FileType vimfiler nmap <buffer> <CR> <Plug>(vimfiler_expand_or_edit)
    "VimFiler Mapping List
    nnoremap <silent> <Leader>vi :<C-u>VimFilerBufferDir -direction=botright -split -simple -winwidth=40 -no-quit<CR>
    call neobundle#untap()
endif
" }}

" kana/vim-textobj-function
if neobundle#tap('vim-textobj-function')
    call neobundle#untap()
endif

" sgur/vim-textobj-parameter
if neobundle#tap('vim-textobj-parameter')
    call neobundle#untap()
endif

" tomasr/molokai {{
if neobundle#tap('molokai')
    let g:molokai_originail=1
    let g:rehash256=1
    colorschem molokai
    Autocmd BufWinEnter,ColorScheme * call s:hl_colorscheme_modify_molokai()
    function! s:hl_colorscheme_modify_molokai()
        hi! DiffText term=reverse cterm=bold ctermbg=239 gui=bold,italic guibg=#4C4745
        hi! DiffDelete term=bold ctermfg=180 ctermbg=0 gui=bold guifg=#960050 guibg=#1E0010
        hi! DiffAdd term=bold ctermbg=0 guibg=#13354A
        hi! Visual ctermfg=236 ctermbg=119 guifg=#353535 guibg=#95e454
        hi! default link MatchParen Title
    endfunction
    call neobundle#untap()
endif
" }}

" itchyny/lightline.vim {{
if neobundle#tap('lightline.vim')
    let g:lightline = {
          \ 'colorscheme':'hybrid',
          \ 'active': {
          \   'left': [ ['mode', 'paste'], ['readonly', 'filename', 'modified'] ]
          \ },
          \ 'component_function': {
          \   'mode': 'LightLineMode'
          \ }
          \ }
    function! neobundle#tapped.hooks.on_source(bundle)
        let g:unite_sorce_overwrite_statusline=0
        let g:vimfiler_force_overwrite_statusline=0
    endfunction

    function! LightLineMode()
          return  &ft == 'unite' ? 'Unite' :
                  \ &ft == 'vimfiler' ? 'VimFiler' :
                  \ winwidth(0) > 60 ? lightline#mode() : ''
    endfunction
    call neobundle#untap()
endif
" }}

" nathanaelkane/vim-indent-guides {{
if neobundle#tap('vim-indent-guides')
    function! neobundle#tapped.hooks.on_source(bundle)
        "vim立ち上げ時に、vim-indent-guidesをオフ
        let g:indent_guides_enable_on_vim_startup=0
        "ガイドの幅
        let g:indent_guides_guide_size=1
        "自動カラーを有効にする
        let g:indent_guides_auto_colors=1
        "guideをスタートするインデント量
        let g:indent_guides_start_level=2
        "ハイライト色の変化の幅
        let g:indent_guides_color_change_percent=20
        let g:indent_guides_default_mapping=0
        "奇数インデントのカラー
        autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd guibg=#262626 ctermbg=gray
        "偶数のインデントのカラー
        autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#3c3c3c ctermbg=darkgray
    endfunction

    nnoremap <Leader>i :<C-u>IndentGuidesToggle<CR>
    call neobundle#untap()
endif
" }}

"  osyo-manga/vim-brightest {{
if neobundle#tap('vim-brightest')
    function! neobundle#tapped.hooks.on_source(bundle)
        " ui.hを有効にする
        let g:brightest#enable_filetypes={
            \ "ui.h" : 1 
            \}
    endfunction

    call neobundle#untap()
endif
" }}

" toshi32tony3/vim-repeat {{
if neobundle#tap('vim-repeat')
    "TBD:after setting
    call neobundle#untap()
endif
" }}

" haya14busa/vim-asterisk {{
if neobundle#tap('vim-asterisk')
    function! neobundle#tapped.hooks.on_source(bundle)
        "検索開始時のカーソル位置を保持
        let g:asterisk#keeppos=1
    endfunction

    map * <Plug>(asterisk-z*)
    map # <Plug>(asterisk-z#)
    map g* <Plug>(asterisk-gz*)
    map g# <Plug>(asterisk-gz#)
    call neobundle#untap()
endif
" }}

" osyo-manga/vim-anzu
if neobundle#tap('vim-anzu')
    nmap n <Plug>(anzu-n-with-echo)zv
    nmap N <Plug>(anzu-N-with-echo)zv
    call neobundle#untap()
endif

" Shougo/neocomplcache.vim
if neobundle#tap('neocomplcache.vim')
    let g:neocomplcache_enable_at_startup = 1
  call neobundle#untap()
endif
" }}

" tyru/caw.vim {{
if neobundle#tap('caw.vim')
    function! neobundle#tapped.hooks.on_source(bundle)
        let g:caw_no_default_keymappings=1
    endfunction
    " Beggining of Line Comment Toggle
    nmap <Leader>cc <Plug>(caw:hatpos:toggle)
    vmap <Leader>cc <Plug>(caw:hatpos:toggle)
    nmap <Leader>ci <Plug>(caw:hatpos:toggle)
    vmap <Leader>ci <Plug>(caw:hatpos:toggle)

    " End of Line Comment Toggle
    nmap <Leader>ca <Plug>(caw:dollarpos:toggle)
    vmap <Leader>ca <Plug>(caw:dollarpos:toggle)

    " Bloak Comment Toggle
    nmap <Leader>cw <Plug>(caw:wrap:toggle)
    vmap <Leader>cw <Plug>(caw:wrap:toggle)

    "Break line and Comment
    nmap <Leader>co <Plug>(caw:jump:comment-next)
    nmap <Leader>cO <Plug>(caw:jump:comment-prev)
    call neobundle#untap()
endif
" }}

" itchyny/calendar.vim {{
if neobundle#tap('calendar.vim')
    function! neobundle#tapped.hooks.on_source(bundle)
        let g:calendar_google_calendar=1
        let g:calendar_google_task=1
        let g:calendar_date_endian='big'
        let g:calendar_frame='default'
        AutocmdFT calendar call s:init_calendar()
        function! s:init_calendar()
            nmap <buffer>l <Plug>(calendar_next)
            nmap <buffer>h <Plug>(calendar_prev)
            nmap <buffer>e <Plug>(calendar_event)
            highlight clear TrailingSpaces
        endfunction
    endfunction
    call neobundle#untap()
endif
" }}

" vim-scripts/sudo.vim {{
if neobundle#tap('sudo.vim')
    nnoremap <Leader>su :<C-u>e sudo:%<CR>
    call neobundle#untap()
endif
" }}

" mhinz/vim-startify'
if neobundle#tap('vim-startify')
"    function! neobundle#tapped.hooks.on_source(bundle)
        let g:startify_files_number = 15
        let g:startify_change_to_dir = 5
        let g:startify_session_dir = '~/vimfiles/session'
        let g:startify_session_delete_buffers = 0
        let g:startify_custom_indices=
        \['a', 'b', 'c', 'd', 'f', 'g',
        \ 'h', 'i', 'j', 'k', 'l', 'm',
        \ 'n', 'o', 'p', 'r', 's', 't',
        \ 'u', 'v', 'w', 'x', 'y', 'z']
        let g:startify_bookmarks=["~/.vimrc"]
"    endfunction
    function! neobundle#hooks.on_post_source(bundle)
        delcommand StartifyDebug
        delcommand SClose
    endfunction
    nnoremap [Unite], :<C-u>Startify<CR>
    call neobundle#untap()
endif
" }}

" vim-scripts/a.vim {{
if neobundle#tap('a.vim')
    call neobundle#untap()
endif
" }}

" haya14busa/incsearch.vim {{
if neobundle#tap('incsearch.vim')
    noremap <silent> <expr> g/ incsearch#go({'command':'/','is_stay':1})
    noremap <silent> <expr> g? incsearch#go({'command':'?','is_stay':1})
    call neobundle#untap()
endif
" }}

" Lokaltog/vim-easymotion {{
if neobundle#tap('vim-easymotion')
    function! neobundle#tapped.hooks.on_post_source(bundle)
        EMCommandLineNoreMap <Space> <CR>
        EMCommandLineNoreMap <C-j> <Space>
    endfunction

    function! neobundle#tapped.hooks.on_source(bundle)
        let g:EasyMotion_do_mapping=0
        let g:EasyMotion_keys=';hklyuiopnm,qwertzxcvbasdgjf'
        let g:EasyMotion_use_upper=1
        let g:EasyMotion_smartcase=1
        let g:EasyMotion_use_smartsign_us=1
        let g:EasyMotion_startofline=0
        let g:EasyMotion_skipfoldedline=0
        let g:EasyMotion_use_migemo=1
        let g:EasyMotion_enter_jump_first=1
        let g:EasyMotion_space_jump_first=1
        let g:EasyMotion_prompt='Target Keys> '
        let g:EasyMotion_cursor_highlight=1
        hi EasyMotionTarget guifg=#80a0ff ctermfg=81
"        hi EasyMotionTarget ctermbg=none ctermfg=red
    endfunction

    map <Leader><Space> <Plug>(easymotion-s)
    map <Leader>j <Plug>(easymotion-j)
    map <Leader>k <Plug>(easymotion-k)
    call neobundle#untap()
endif
" }}

" deris/vim-shot-f {{
if neobundle#tap('vim-shot-f')
    map f <Plug>(shot-f-f)
    map F <Plug>(shot-f-F)
    call neobundle#untap()
endif
" }}

" tyru/open-browser.vim {{
if neobundle#tap('open-browser.vim')
    nmap gx <Plug>(openbrowser-smart-search)
    vmap gx <Plug>(openbrowser-smart-search)
    call neobundle#untap()
endif
" }}

" functions {{{
" Cvsdiff {{
if exists("loaded_cvsdiff") || &cp
    finish
endif
let loaded_cvsdiff = 1
com! -bar -nargs=? Cvsdiff :call s:Cvsdiff(<f-args>)
function! s:Cvsdiff(...)
    colorscheme evening
    if a:0 > 1
        let rev = a:2
    else
        let rev = ''
    endif
    let ftype = &filetype
    let tmpfile = tempname()
    let cmd = "cat " . bufname("%") . " > " . tmpfile
    let cmd_output = system(cmd)
    let tmpdiff = tempname()
    let cmd = "cvs diff" . rev . " " . bufname("%") . " > " . tmpdiff
    let cmd_output = system(cmd)
    if v:shell_error && cmd_output != ""
        echohl WarningMsg | echon cmd_output-
        return
    endif
    let cmd = "patch -R -p0 " . tmpfile . " " . tmpdiff
    let cmd_output = system(cmd)
    if v:shell_error && cmd_output != ""
        echohl WarningMsg | echon cmd_output-
        return
    endif
    if a:0 > 0 && a:1 == "v"
        exe "vert diffsplit" . tmpfile
    else
        exe "diffsplit" . tmpfile
    endif
    exe "set filetype=" . ftype
endfunction
" }} End of Cvsdiff

" IncludeGuard {{
function! IncludeGuard()
let fl = getline(1)
if fl =~ "^#if"
    return
endif
let fileName = substitute(toupper(expand("%:t")), "\\.", "_", "g")
normal! gg
execute "normal! i#ifndef " . fileName . ""
execute "normal! o#define " . fileName .  "\<CR>\<CR>\<CR>\<CR>\<CR>"
endfunction
" }} End of IncludeGuard

" Command-line Window {{
function! s:init_cmdwin()
    setlocal nonumber
    silent! 1,$-20 delete _ | call cursor('$', 0 )
    nnoremap <silent><buffer>q  :<C-u>quit<CR>
    nnoremap <silent><buffer><CR>   <CR>

    "Completiton.
    inoremap <silent><buffer><expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
    inoremap <silent><buffer><expr><C-p> pumvisible() ? "\<C-p>" : "\<C-o>0"\<UP>
    inoremap <silent><buffer><expr><C-n> pumvisible() ? "\<C-n>" : "\<C-o>0"\<DOWN>
    startinsert!
endfunction
" }} End of Command-line Window

" CDPath {{
function! s:CommandCompleteCPPath(argLead, cmdLine, cursorPos)
    let l:pattern = substitute($HOME, '\\','\\\\','g')
    return split(substitute(globpath(&cdpath, a:argLead . '*/'), l:pattern, '~', 'g' ),"\n" )
endfunction
function! s:CD(...)
    if a:0 == 0 | execute 'cd ' . expand('%:p:h')
    else        | execute 'cd ' . a:1           | endif
    echo substitute(getcwd(), substitute($HOME, '\\', '\\\\', 'g'),'~','g')
endfunction
command! -complete=customlist,<SID>CommandCompleteCDPath -nargs=? CD call s:CD(<f-args>)
" }} End of CDPath

"}}} end of functions

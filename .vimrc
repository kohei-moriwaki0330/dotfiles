" vimrc for Vim(Version:7.4)
" Author: Kohei kanno.
" Last Modified: 01-July-2016.

" Prefix {{{
" Leader {{
let g:mapleader='[Leader]'
let g:maplocalleader="\<Space>"
noremap [Leader] <Nop>
map <Space> [Leader]
noremap [Leader]<Space> <Nop>
map <LocalLeader> [Leader]
noremap [Leader]<LocalLeader> <Nop>
" }}
" Unite {{
nnoremap [Unite] <Nop>
nmap , [Unite]
" }}
" Tab {{
nnoremap [Tab] <Nop>
nmap t [Tab]
" }}
" Cscope {{
noremap [Cscope] <Nop>
nmap <C-\> [Cscope]
" }}
" }}} End of Prefix

" release autogroup in MyAutoCmd {{{
augroup MyAutoCmd
    autocmd!
augroup END
"}}} End of MyAutoCmd

" NeoBundle {{{
filetype plugin indent off
if has('vim_starting')
    set nocompatible
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
call neobundle#begin(expand('~/.vim/bundle'))
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
set ttytype=builtin_xterm " Setting the terminal type.
set helplang=ja " Setting the help language.
set keywordprg=:help " Open vim internal help by k command
set background=dark "Setting the Vim background.
set t_Co=256 "Enable 256 colors forcely on screen
set nobackup " Don't make a backup file before overwriting a file.
set noswapfile " Don't make a swap file before overwriting a file.
set autoread "Automatically read file again which has been changed outside of Vim.
set cmdheight=1 "Number of screen lines to use for the command-line.
set cmdwinheight=5 "Number of screen lines to use for the command-line window.
set grepprg=internal "Program to use for the :grep command.
set hidden " Display anather buffer when current buffer isn't saved.
set spelllang=en,cjk "Spell checking language.
set relativenumber "Show the relative line number for each line
set cursorline "Emphasize the cursorline
set timeout timeoutlen=1000 ttimeoutlen=100 "Setting timeoutlent(<Leader>) or ttimeoutlen(Esc)
syntax enable "Setting the Syntax

" }}} End of Basic

" Plugins {{{
runtime! plugins/*.vim

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
"}}

" Writing {{
NeoBundleLazy 'tyru/caw.vim', {'on_map' : ['<Plug>(caw:']}
"}}

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
"}}

" UI {{
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'osyo-manga/vim-brightest'
NeoBundleLazy 'nathanaelkane/vim-indent-guides', {'on_cmd' : 'IndentGuidesToggle'}
"}}

" Colorscheme {{
NeoBundle 'tomasr/molokai'
"}}

" Motion {{
NeoBundle 'vim-scripts/sudo.vim'
NeoBundleLazy 'toshi32tony3/vim-repeat'
NeoBundleLazy 'haya14busa/incsearch.vim'
NeoBundleLazy 'Lokaltog/vim-easymotion', {'on_map' : '<Plug>'}
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
"}}

call neobundle#end()
" }}} End of Plugins

" Shougo/unite.vim {{
if neobundle#tap('unite.vim')
    function! neobundle#tapped.hooks.on_source(bundle)
        let g:unite_kind_jump_list_after_jump_scroll=0
        "Uniteのpromtp設定
        let g:unite_prompt='$'
        let g:unite_source_rec_min_cache_files=1000
        let g:unite_source_rec_max_cache_files=5000
        "最近開いたファイル履歴の保存数
        let g:unite_source_file_mru_limit=300
        "大文字小文字を区別しない
        let g:unite_enable_start_ignore_case=1
        let g:unite_enable_smart_case=1
        "InsertModeで開始する
        let g:unite_enable_start_insert=1
        "file_mruの表示フォーマットを指定。空に表示すると表示スピードが高速化
        let g:unite_source_file_mru_filename_format=' '
        "最近開いたファイル履歴の保存数
        let g:unite_source_file_mru_limit=50
        "横分割で開く
        let g:unite_enable_split_vertically=0
        "下(右)に開く
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
            colorscheme molokai
    call neobundle#untap()
endif
" }}

" itchyny/lightline.vim {{
if neobundle#tap('lightline.vim')
    let g:lightline = {
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

endif

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

" vim-scripts/sudo.vim {{
if neobundle#tap('sudo.vim')
    nnoremap <Leader>su :<C-u>e sudo:%<CR>
    call neobundle#untap()
endif
" }}

" mhinz/vim-startify'
if neobundle#tap('vim-startify')
  let g:startify_files_number = 15
  let g:startify_change_to_dir = 5
  let g:startify_session_dir = '~/vimfiles/session'
  let g:startify_session_delete_buffers = 1
  nnoremap [Unite], :<C-u>Startify<CR>

  function! neobundle#hooks.on_post_source(bundle)
    delcommand StartifyDebug
    delcommand SClose
  endfunction

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
"        hi EasyMotionTarget guifg=#80a0ff ctermfg=81
        hi EasyMotionTarget ctermbg=none ctermfg=red
    endfunction

    map <Leader><Space> <Plug>(easymotion-s)
    map <Leader>j <Plug>(easymotion-j)
    map <Leader>k <Plug>(easymotion-k)
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

" Etc Setting List {{{

" Cscope add {{
cs add ~/kanno/Tool/.cscope/View/cscope.out
cs add ~/kanno/Tool/.cscope/Model/cscope.out
cs add ~/kanno/Tool/.cscope/Etc/cscope.out
cs add ~/kanno/Tool/.cscope/Framework/cscope.out
cs add ~/kanno/Tool/.cscope/Nmsystem/cscope.out
"cs add ~/kanno/Tool/.gtags/Atc/GTAGS
"cs add ~/kanno/Tool/.gtags/Nmsystem/GTAGS
" }}

" Cscope KeyMaphaya14busas {{
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
" }}

" Set relativenumber or no relativenumber.
nnoremap <silent> <Leader>rel :<C-u>set relativenumber! relativenumber?<CR>

" Tab KeyMaps {{
nnoremap <silent> [Tab]c :tablast <bar> tabnew %<CR>
nnoremap <silent> [Tab]f :tablast <bar> tabnew .<CR>
nnoremap <silent> [Tab]d :tabclose<CR>
nnoremap <silent> [Tab]n :tabnext<CR>
nnoremap <silent> [Tab]p :tabprevious<CR>
" }}

" Tab jump {{
for n in range(1,9)
    execute 'nnoremap <silent> [Tab]'.n ':<C-u>tabnext'.n.'<CR>'
endfor
" }}

" gfの結果をタブ複製にする
nnoremap gf :<C-u>execute 'tabfind ' .expand('<cfile>')<CR>

" 最後のカーソル位置に戻る
autocmd MyAutoCmd BufRead * silent! execute'normal! `"zv'

" Bufferが呼ばれたときに、選択したBufferに移動する
au BufEnter * execute ":lcd " . expand("%:p:h")

" hファイルの場合は、ifndef/define/endifを自動挿入
au BufNewFile *.h call IncludeGuard() "{{
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
" }}

" Cvsdiff
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

" Goes to Another window
nnoremap <Tab> <C-W>w
" .vimrc Mapping List
nnoremap <silent> <Leader>ev :<C-u>edit $MYVIMRC<CR>
" vimhelp List
nnoremap <silent> <Leader>h :<C-u>botright vs ~/.vim/bundle/help.jax<CR>

" Wrapped lines goes down/up to next row, rather than next line in file.
nnoremap j gj
nnoremap k gk

"}}} End of Etc Setting List

" vimrc for Vim(Version:7.4)
" Author: Kohei kanno.
" Last Modified: 22-May-2016.

" Prefix {{{
" Leader
let g:mapleader='[Leader]'
let g:maplocalleader="<Space>"
noremap [Leader] <Nop>
map <Space> [Leader]
noremap [Leader]<Space> <Nop>
map <LocalLeader> [Leader]
noremap [Leader]<LocalLeader> <Nop>
" Unite
nnoremap [Unite] <Nop>
nmap , [Unite]
" Tag
nnoremap [Tag] <Nop>
nmap t [Tag]
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
set encoding=japan
set incsearch
set expandtab
set tabstop=4
set shiftwidth=4
set list listchars=tab:>-,trail:-,extends:>,precedes:<
set cinoptions=:0,p0,t0
set cinwords=if,else,while,do,for,switch,case
set number relativenumber
set laststatus=2 showtabline=2 " Always Status/TabLine display
set display=lastline " Don't skip the long text
set noequalalways " Don't auto resize Window
set showcmd " Display input command
set ttytype=builtin_xterm " Setting the terminal type
set helplang=ja " Setting the help language
" }}} End of Basic

" Plugins {{{
runtime! plugins/*.vim
NeoBundleLazy 'Shougo/unite.vim', {'on_cmd' : 'Unite'}
NeoBundleLazy 'Shougo/neomru.vim', {'on_source' : 'unite.vim'}
NeoBundleLazy 'tsukkee/unite-help', {'on_source' : 'unite.vim'}
NeoBundleLazy 'ujihisa/unite-colorscheme', {'on_source' : 'unite.vim'}
NeoBundleLazy 'hewes/unite-gtags', {'on_source' : 'unite.vim'}
NeoBundleLazy 'vim-jp/vimdoc-ja'

" Command:
" 1.gci:ʸ��Ƭ���饳���ȥ�����
" 2.gcI:��Ƭ���饳���ȥ�����
" 3.gca:�����˥����ȥ�����
" 4.gco:��������Ԥβ��˥����ȥ�����
" 5.gcO:��������Ԥξ�˥����ȥ�����
" Help: caw-introduction
NeoBundle 'tyru/caw.vim'
NeoBundle 'haya14busa/vim-asterisk'
NeoBundleLazy 'kana/vim-operator-user'
NeoBundleLazy 'kana/vim-textobj-user'
NeoBundleLazy 'sgur/vim-textobj-parameter'
NeoBundleLazy 'kana/vim-textobj-indent'
NeoBundleLazy 'Shougo/vimfiler.vim', {
    \ 'depends' : 'Shougo/unite.vim',
    \ 'on_path' : '.*',
    \ }
NeoBundle 'tomasr/molokai'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'osyo-manga/vim-brightest'

call neobundle#end()
" }}} End of Plugins

" Cscope {{{
cs add ~/kanno/Tool/.cscope/View/cscope.out
cs add ~/kanno/Tool/.cscope/Model/cscope.out
cs add ~/kanno/Tool/.cscope/Etc/cscope.out
cs add ~/kanno/Tool/.cscope/Nmsystem/cscope.out
"   's'   symbol: find all references to the token under cursor
"   'g'   global: find global definition(s) of the token under cursor
"   'c'   calls:  find all calls to the function name under cursor
"   't'   text:   find all instances of the text under cursor
"   'e'   egrep:  egrep search for the word under cursor
"   'f'   file:   open the filename under cursor
"   'i'   includes: find files that include the filename under cursor
"   'd'   called: find functions that function under cursor calls
nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-\>i :cs find i <C-R>=expand("<cfile>")<CR><CR>
nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
" }}} End of Cscope

" Unite Setting List{{{
" Shougo/unite.vim {{
if neobundle#tap('unite.vim')
    function! neobundle#tapped.hooks.on_source(bundle)
        let g:unite_kind_jump_list_after_jump_scroll=0
        "Unite��promtp����
        let g:unite_prompt='$'
        let g:unite_source_rec_min_cache_files=1000
        let g:unite_source_rec_max_cache_files=5000
        "�Ƕᳫ�����ե������������¸��
        let g:unite_source_file_mru_limit=300
        "��ʸ����ʸ������̤��ʤ�
        let g:unite_enable_start_ignore_case=1
        let g:unite_enable_smart_case=1
        "InsertMode�ǳ��Ϥ���
        let g:unite_enable_start_insert=1
        "file_mru��ɽ���ե����ޥåȤ���ꡣ����ɽ�������ɽ�����ԡ��ɤ���®��
        let g:unite_source_file_mru_filename_format=' '
        "�Ƕᳫ�����ե������������¸��
        let g:unite_source_file_mru_limit=50
        "��ʬ��ǳ���
        let g:unite_enable_split_vertically=1
        "����50�ǳ���
        let g:unite_winwidth=50
    endfunction

    nnoremap <silent> [Unite]u :<C-u>Unite<CR>
    nnoremap <silent> [Unite]f :<C-u>UniteWithBufferDir -silent -buffer-name=files file<CR>
    nnoremap <silent> [Unite]b :<C-u>Unite -silent buffer file_mru bookmark<CR>
    nnoremap <silent> [Unite]r :<C-u>UniteResume<CR>
    nnoremap <silent> [Unite]g :<C-u>Unite -silent -no-quit grep<CR>
    nnoremap <silent> [Unite]r :<C-u>Uniteruntimepath<CR>
    nnoremap <silent> [Unite]c :<C-u>Unite<Space>-auto-preview colorscheme<CR>
    nnoremap <silent> [Unite]s :<C-u>Unite source<CR>
    nnoremap <silent> [Unite]ma :<C-u>Unite -silent mapping<CR>
    nnoremap <silent> [Unite]me :<C-u>Unite -silent output:message<CR>

    autocmd FileType unite call s:unite_my_settings()
    function! s:unite_my_settings()"{{{
        imap <buffer> jj <Plug>(unite_insert_leave)
        nmap <buffer> <ESC> <Plug>(unite_exit)
    endfunction"}}}
    call neobundle#untap()
endif
"}}

" ujihisa/unite-colorscheme {{
if neobundle#tap('unite-colorscheme')
    command! -nargs=* BeautifulAttack Unite colorscheme -auto-preview -winheight=3
    call neobundle#untap()
endif
"}}

" Shougo/vimfiler {{
if neobundle#tap('vimfiler.vim')
    autocmd FileType vimfiler nmap <buffer> <CR> <Plug>(vimfiler_expand_or_edit)
    let g:vimfiler_as_default_explorer=1
    let g:vimfiler_fource_overwrite_statusline=0
    "VimFiler Mapping List
    nnoremap <silent> <Leader>vi :<C-u>VimFilerBufferDir -split -simple -winwidth=35 -no-quit<CR>
    call neobundle#untap()
endif
"}}

" tomasr/molokai {{
if neobundle#tap('molokai')
    syntax on
    set background=dark
    let g:molokai_original=1
    let g:rehash256=1
    colorscheme molokai
    call neobundle#untap()
endif
"}}

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
    function! LightLineMode()
          return  &ft == 'unite' ? 'Unite' :
                  \ &ft == 'vimfiler' ? 'VimFiler' :
                  \ winwidth(0) > 60 ? lightline#mode() : ''
      endfunction
    call neobundle#untap()
endif
"}}

" nathanaelkane/vim-indent-guides {{
if neobundle#tap('vim-indent-guides')
    "vimΩ���夲���ˡ���ưŪ��vim-indent-guides�򥪥�
    let g:indent_guides_enable_on_vim_startup=1
    "guide�򥹥����Ȥ��륤��ǥ����
    let g:indent_guides_start_level=2
    "��ư���顼��̵���ˤ���
    let g:indent_guides_auto_colors=0
    "�������ǥ�ȤΥ��顼
    autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd guibg=#262626 ctermbg=gray
    "�����Υ���ǥ�ȤΥ��顼
    autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#3c3c3c ctermbg=darkgray
    "�ϥ��饤�ȿ����Ѳ�����
    let g:indent_guides_color_change_percent=30
    "�����ɤ���
    let g:indent_guides_guide_size=1
    call neobundle#untap()
endif
" }}

"  osyo-manga/vim-brightest {{
if neobundle#tap('vim-brightest')
    " ui.h��ͭ���ˤ���
    let g:brightest#enable_filetypes= {
        \ "ui.h" : 1 
        \}
    call neobundle#untap()
endif
"}}

" haya14busa/vim-asterisk {{
if neobundle#tap('vim-asterisk')
    "�������ϻ��Υ���������֤��ݻ�
"    let g:asterisk#keeppos=1
"    map * <Plug> (asterisk-z*)
"    map # <Plug> (asterisk-z#)
"    map g* <Plug> (asterisk-gz*)
"    map g# <Plug> (asterisk-gz#)
    call neobundle#untap()
endif
"}}

" }}} End of Unite Setting List

" Etc Setting List {{{
nnoremap <silent> <Leader>rel :<C-u>set relativenumber! relativenumber?<CR>
" .vimrc Mapping List
nmap <silent> <Leader>rc :vs ~/.vimrc<CR>
" ���ִ�Ϣ Mapping List
map <silent> [Tag]c :tablast <bar> tabnew <CR>
map <silent> [Tag]x :tabclose<CR>
map <silent> [Tag]n :tabnext<CR>
map <silent> [Tag]p :tabprevious<CR>
for n in range(1,9)
    "t1��1�ֺ��Υ���,t2��1�ֺ�����2���ܤΥ��֤˥�����
    execute 'nnoremap <silent> [Tag]'.n ':<C-u>tabnext'.n.'<CR>'
endfor
" gf�η�̤򥿥�ʣ���ˤ���
nnoremap gf :<C-u>execute 'tabfind ' .expand('<cfile>')<CR>

" �Ǹ�Υ���������֤����
autocmd MyAutoCmd BufRead * silent! execute'normal! `"zv'

" Buffer���ƤФ줿�Ȥ��ˡ����򤷤�Buffer�˰�ư����
au BufEnter * execute ":lcd " . expand("%:p:h")
"}}} End of Etc Setting List


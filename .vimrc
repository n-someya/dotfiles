" タブを表示するときの幅
set tabstop=4
" タブを挿入するときの幅
set shiftwidth=4
" タブをタブとして扱う(スペースに展開しない)
set noexpandtab
" tabをスペース展開する
set expandtab
" 
set softtabstop=0
set number
set nocompatible
" be iMproved
filetype off
" 対応括弧に'<'と'>'のペアを追加
set matchpairs& matchpairs+=<:>
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%,eol:↲

" vimdiffの色設定
highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=22
highlight DiffDelete cterm=bold ctermfg=10 ctermbg=52
highlight DiffChange cterm=bold ctermfg=10 ctermbg=17
highlight DiffText   cterm=bold ctermfg=10 ctermbg=21

" ## dein.vim ## 
" プラグインが実際にインストールされるディレクトリ
let s:dein_dir = expand('~/.cache/dein')
" dein.vim 本体
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

set rtp+=~/.cache/dein/repos/github.com/Lokaltog/powerline/powerline/bindings/vim
" dein.vim がなければ github から落としてくる
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

" 設定開始
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " プラグインリストを収めた TOML ファイル
  " 予め TOML ファイル（後述）を用意しておく
  let g:rc_dir    = expand('~/.vim/rc')
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'
  " TOML を読み込み、キャッシュしておく
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})


  " 設定終了
  call dein#end()
  call dein#save_state()
endif


" もし、未インストールものものがあったらインストール
if dein#check_install()
  call dein#install()
endif


"neocomplcacheの設定"
filetype plugin indent on     " required!
filetype indent on
syntax on

" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'
" 1番目の候補を自動選択
let g:neocomplcache_enable_auto_select = 1
"" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
			\ 'default' : ''
			\ }
" powerlineの設定
" Powerline
"python from powerline.vim import setup as powerline_setup
"python powerline_setup()
"python del powerline_setup

set laststatus=2
set showtabline=2
set noshowmode
let g:Powerline_symbols = 'fancy'
set t_Co=256
let g:Powerline_dividers_override = ['>>', '⮀', '<<', '<']

let g:syntastic_mode_map = { 'mode': 'passive' }
let g:syntastic_python_checkers = ['pyflakes', 'pep8']
augroup AutoSyntastic
	autocmd!
	autocmd BufWritePost *.c,*.cpp,*.js,*.py,*.rb call s:syntastic()
augroup END
function! s:syntastic()
    SyntasticCheck
"   call lightline#update()
endfunction

function! MyModified()
	return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
	return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? '⭤' : ''
endfunction

function! MyFilename()
	return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
				\ (&ft == 'vimfiler' ? vimfiler#get_status_string() : 
				\  &ft == 'unite' ? unite#get_status_string() : 
				\  &ft == 'vimshell' ? vimshell#get_status_string() :
				\ '' != expand('%:p') ? expand('%:p') : '[No Name]') .
				\ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFugitive()
	if &ft !~? 'vimfiler\|gundo' && exists("*fugitive#head")
		let _ = fugitive#head()
		return strlen(_) ? '⭠ '._ : ''
	endif
	return ''
endfunction

function! MyFileformat()
	return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! MyFiletype()
	return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
	return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyMode()
	return winwidth(0) > 60 ? lightline#mode() : ''
endfunction
 

"" Plugin key-mappings.
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
	return neocomplcache#smart_close_popup() . "\<CR>"
endfunction

" <TAB> completion.
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
" C-nでneocomplcache補完
inoremap <expr><C-n>  pumvisible() ? "\<C-n>" : "\<C-x>\<C-u>\<C-p>"
" C-pでkeyword補完
inoremap <expr><C-p> pumvisible() ? "\<C-p>" : "\<C-p>\<C-n>"
" 補完候補が表示されている場合は確定。そうでない場合は改行
inoremap <expr><CR>  pumvisible() ? neocomplcache#close_popup() : "<CR>"

" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()

"vimfilerの設定
let g:vimfiler_as_default_explorer = 1
command Vfe :VimFilerExplore
let g:vimfiler_edit_action = 'tabopen'

" neosnippet の設定
" 自分用 snippet ファイルの場所
let g:neosnippet#snippets_directory='~/.vim/bundle/neosnippet-snippets/snippets/'

hi Pmenu ctermbg=4
hi PmenuSel ctermbg=1
hi PMenuSbar ctermbg=4
hi Comment ctermfg=2
set laststatus=2
set noshowmode
" rename用のマッピングを無効にしたため、代わりにコマンドを定義
 command! -nargs=0 JediRename :call jedi#rename()
"
" " pythonのrename用のマッピングがquickrunとかぶるため回避させる
let g:jedi#rename_command = ""
let  g:jedi#documentation_command = "P"

" Unite
nnoremap [unite]    <Nop>
nmap     <Space>u [unite]

nnoremap <silent> [unite]c   :<C-u>UniteWithCurrentDir -buffer-name=files buffer bookmark file<CR>
nnoremap <silent> [unite]b   :<C-u>Unite buffer<CR>
nnoremap <silent> [unite]g   :<C-u>Unite grep -buffer-name=search-buffer<CR>

"vim-ref
"Ref webdictでalcを使う設定
let g:ref_source_webdict_cmd = 'lynx -dump -pauth=''someya.naoki@jp.fujitsu.com'':7088850600 %s'
"let g:ref_source_webdict_use_cache = 1
let g:ref_source_webdict_sites = {
            \ 'alc' : 'http://eow.alc.co.jp',
            \ 'wikipedia:ja': 'http://jp.wikipedia.org/wiki/%s'
            \ }

" バイナリファイル編集時の設定
augroup Binary
    autocmd!
    autocmd BufReadPre  *.bin let &binary = 1
    autocmd BufReadPost * call BinReadPost()
    autocmd BufWritePre * call BinWritePre()
    autocmd BufWritePost * call BinWritePost()
    function! BinReadPost()
        if &binary
            silent %!xxd -g1
            set ft=xxd
        endif
    endfunction
    function! BinWritePre()
        if &binary
            let s:saved_pos = getpos( '.' )
            silent %!xxd -r
        endif
    endfunction
    function! BinWritePost()
        if &binary
            silent %!xxd -g1
            call setpos( '.', s:saved_pos )
            set nomod
        endif
    endfunction
augroup END
" NeoBundleCheck を走らせ起動時に未インストールプラグインをインストールする
NeoBundleCheck

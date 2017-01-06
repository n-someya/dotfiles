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


"neocompleteの設定"
filetype plugin indent on     " required!
filetype indent on
syntax on

" Use neocomplete.
let g:neocomplete_enable_at_startup = 1
" Use smartcase.
let g:neocomplete_enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete_min_syntax_length = 3
let g:neocomplete_lock_buffer_name_pattern = '\*ku\*'
" 1番目の候補を自動選択
let g:neocomplete_enable_auto_select = 1
"" Define dictionary.
let g:neocomplete_dictionary_filetype_lists = {
			\ 'default' : ''
			\ }

set laststatus=2
set showtabline=2
set noshowmode
set t_Co=256

" powerlineの設定
let g:lightline = {
    \ 'colorscheme': 'wombat',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'fugitive', 'readonly', 'filename', 'modified' ] ]
    \ },
    \ 'component': {
    \   'readonly': '%{&filetype=="help"?"":&readonly?"⭤":""}',
    \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
    \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}'
    \ },
    \ 'component_visible_condition': {
    \   'readonly': '(&filetype!="help"&& &readonly)',
    \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
    \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
    \ },
    \ 'separator': { 'left': '⮀', 'right': '⮂'},
    \ 'subseparator': { 'left': "\u2b81", 'right': "\u2b83" }
    \}


let g:syntastic_mode_map = { 'mode': 'passive' }
let g:syntastic_python_checkers = ['pyflakes', 'pep8']
augroup AutoSyntastic
    autocmd!
    autocmd BufWritePost *.c,*.cpp,*.js,*.py,*.rb,*.go call s:syntastic()
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
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
	return neocomplete#smart_close_popup() . "\<CR>"
endfunction

" <TAB> completion.
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
" C-nでneocomplete補完
inoremap <expr><C-n>  pumvisible() ? "\<C-n>" : "\<C-x>\<C-u>\<C-p>"
" C-pでkeyword補完
inoremap <expr><C-p> pumvisible() ? "\<C-p>" : "\<C-p>\<C-n>"
" 補完候補が表示されている場合は確定。そうでない場合は改行
inoremap <expr><CR>  pumvisible() ? neocomplete#close_popup() : "<CR>"

" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()

"vimfilerの設定
let g:vimfiler_as_default_explorer = 1
command Vfe :VimFilerExplore
"let g:vimfiler_edit_action = 'tabopen'

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

" Gundo
nnoremap [gundo]    <Nop>
nmap     <Space>g [gundo]

nnoremap <silent> [gundo]t :<C-u>GundoToggle<CR>


"vim-ref
"Ref webdictでalcを使う設定
let g:ref_source_webdict_cmd = 'lynx -dump -pauth=''someya.naoki@jp.fujitsu.com'':7088850600 %s'
"let g:ref_source_webdict_use_cache = 1
let g:ref_source_webdict_sites = {
            \ 'alc' : 'http://eow.alc.co.jp',
            \ 'wikipedia:ja': 'http://jp.wikipedia.org/wiki/%s'
            \ }

let g:quickrun_config = { 
    \"python" :{
    \   "hook/output_encode/enable" : 1,
    \   "hook/output_encode/encoding" : "utf-8",
    \}
\}

" Go lang
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
autocmd FileType go :highlight goErr cterm=bold ctermfg=214
autocmd FileType go :match goErr /\<err\>/
" 保存時にビルド自動実行
autocmd BufWritePost *.go :GoBuild
hi Search ctermfg=0 ctermbg=11 guibg=Yellow

function! _ErBuild()
    !eralchemy -i % -o %:r.png
endfunction

command! ErBuild call _ErBuild()
autocmd BufWritePost *.er :ErBuild

autocmd VimEnter * execute 'Vfe'

set backspace=indent,eol,start

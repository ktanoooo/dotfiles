"" ----------------------------------------
""  Plugin
"" ----------------------------------------
let s:vimdir   = has('nvim') ? '~/.config/nvim/' : '~/.vim/'
let s:plugdir  = s:vimdir . 'plugged'
let s:plugfile = s:vimdir . 'autoload/plug.vim'
let s:plugurl  = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
if empty(glob(s:plugfile))
  silent execute '!mkdir -p ' . s:vimdir . 'autoload'
  if executable('curl')
    silent execute '!curl -sLo ' . s:plugfile ' ' . s:plugurl
  else
    silent !echo 'vim-plug failed: you need curl to install' | cquit
  endif
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin(s:plugdir)
  Plug 'ap/vim-css-color'
  Plug 'cohama/lexima.vim'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-commentary'
  Plug 'bfredl/nvim-miniyank'
  Plug 'machakann/vim-sandwich'
  Plug 'rhysd/conflict-marker.vim'
  Plug 'bronson/vim-trailing-whitespace'
  Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
  Plug 'junegunn/fzf.vim' | Plug 'junegunn/fzf', {'do': { -> fzf#install() }}
call plug#end()

"" ----------------------------------------
""  Configure
"" ----------------------------------------
set nobomb
set number
set lazyredraw
set termguicolors
set signcolumn=yes
let $LANG='en_US.UTF-8'
let mapleader="\<Space>"
set title titlestring=%F
set splitright splitbelow
set clipboard=unnamedplus
set fileformats=unix,dos,mac
set whichwrap=b,s,h,l,<,>,[,]
set ignorecase wildignorecase
set hidden nobackup noswapfile
set expandtab tabstop=2 softtabstop=2 shiftwidth=2 smartindent
set encoding=utf-8 fileencodings=cp932,sjis,euc-jp,utf-8,iso-2022-jp
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
if has('nvim')
  set inccommand=split
else
  sy on
  set ttyfast
  set autoread
  set wildmenu
  set belloff=all
  set ruler showcmd
  set hlsearch incsearch
  filetype plugin indent on
  set backspace=indent,eol,start
endif

"" ----------------------------------------
""  Mapping
"" ----------------------------------------
nn Y y$
tno <ESC> <C-\><C-n>
nn + <C-a>| nn - <C-x>
nn <Up> gk| nn <Down> gj
nn <Leader>n :set invnumber<CR>
nn <Leader>sh :split \| terminal<CR>
nn <Leader>sg :split \| terminal git diff<CR>
nn <Leader>uu :resize +5<CR>| nn <Leader>dd :resize -5<CR>
nn <Leader>rr :vertical resize -5<CR>| nn <Leader>ll :vertical resize +5<CR>

"" ----------------------------------------
""  PluginSetting
"" ----------------------------------------
"" ========== VimPlug ==========
nn <Leader>clean :PlugClean<CR>
nn <Leader>inst :PlugInstall<CR>
nn <Leader>upd :PlugUpgrade \| PlugUpdate<CR>

"" ========== Coc.nvim ==========
let g:coc_config_home = "~/.config/coc"
let g:coc_global_extensions = [
  \ 'coc-go',
  \ 'coc-css',
  \ 'coc-git',
  \ 'coc-rls',
  \ 'coc-json',
  \ 'coc-html',
  \ 'coc-clangd',
  \ 'coc-docker',
  \ 'coc-python',
  \ 'coc-tsserver',
  \ 'coc-solargraph',
  \ 'coc-fzf-preview',
  \ 'coc-markdownlint',
\ ]
nn <Leader>cup :CocUpdate<CR>
nn <Leader>cstop :CocDisable<CR>
nn <Leader>ee :CocCommand explorer<CR>
nm <silent> <Leader>gnn <Plug>(coc-git-nextchunk)
nm <silent> <Leader>gpp <Plug>(coc-git-prevchunk)
nm <silent> <Leader>nn <Plug>(coc-diagnostic-next)
nm <silent> <Leader>pp <Plug>(coc-diagnostic-prev)
nm <silent> <Leader>rn :call CocAction('rename')<CR>
nm <silent> <Leader>see :call CocAction('doHover')<CR>
nm <silent> <Leader>jj :call CocAction('jumpDefinition','split')<CR>
nm <silent> <Leader>jv :call CocAction('jumpDefinition','vsplit')<CR>
nm <silent> <Leader>ii :call CocAction('jumpImplementation','split')<CR>
nm <silent> <Leader>iv :call CocAction('jumpImplementation','vsplit')<CR>

"" ========== Completion ==========
ino <expr> <UP> pumvisible() ? '<C-e><UP>' : '<UP>'
ino <expr> <DOWN> pumvisible() ? '<C-e><DOWN>' : '<DOWN>'
fun! TabComp()
  if pumvisible()
    return "\<C-n>"
  elseif coc#jumpable()
    return "\<C-r>=coc#rpc#request('snippetNext',[])\<CR>"
  else
    return "\<Tab>"
  endif
endfun
im <expr> <Tab> TabComp()| smap <expr> <Tab> TabComp()
fun! TabShiftComp()
  if pumvisible()
    return "\<C-p>"
  elseif coc#jumpable()
    return "\<C-r>=coc#rpc#request('snippetPrev',[])\<CR>"
  else
    return "\<S-Tab>"
  endif
endfun
im <expr> <S-Tab> TabShiftComp()| smap <expr> <S-Tab> TabShiftComp()

"" ========== FzfPreview ==========
nn <silent> <Leader>gg :<C-u>CocCommand fzf-preview.GitActions<CR>
nn <silent> <Leader>hist :<C-u>CocCommand fzf-preview.OldFiles<CR>
nn          <Leader>grep :<C-u>CocCommand fzf-preview.ProjectGrep<Space>
nn <silent> <Leader>ff :<C-u>CocCommand fzf-preview.FromResources project_mru git<CR>
let g:fzf_preview_disable_mru = 0
let g:fzf_preview_command = 'bat --color=always --theme=ansi --plain {-1}'
let g:fzf_preview_default_fzf_options = { '--reverse': v:true, '--preview-window': 'wrap:70%' }
let g:fzf_preview_grep_cmd = 'rg --line-number --no-heading --color=never --hidden'
let g:fzf_preview_filelist_command = 'rg --files --hidden --follow --no-messages -g \!"* *"'
let g:fzf_preview_git_status_preview_command =
  \ "[[ $(git diff --cached -- {-1}) != \"\" ]] && git diff --cached --color=always -- {-1} | delta || " .
  \ "[[ $(git diff -- {-1}) != \"\" ]] && git diff --color=always -- {-1} | delta || " .
  \ g:fzf_preview_command

"" ========== VimFugitive ==========
set diffopt+=vertical
nn <Leader>gd :Gdiff<CR>
nn <Leader>gb :Git blame<CR>

"" ========== NvimMiniyank ==========
if has("nvim")
  map p <Plug>(miniyank-autoput)| map P <Plug>(miniyank-autoPut)
endif

"" ========== ConflictMarker ==========
hi ConflictMarkerEnd guibg=#2f628e
hi ConflictMarkerOurs guibg=#2e5049
hi ConflictMarkerBegin guibg=#2f7366
hi ConflictMarkerTheirs guibg=#344f69
hi ConflictMarkerCommonAncestorsHunk guibg=#754a81
let g:conflict_marker_end = '^>>>>>>> .*$'
let g:conflict_marker_begin = '^<<<<<<< .*$'

"" ========== VimTrailingSpace ==========
nn <Leader>trim :FixWhitespace<CR>

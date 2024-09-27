set tabstop=4
set softtabstop=4 
set shiftwidth=4
set expandtab
set number	
set nocompatible 
set noerrorbells

filetype plugin indent on
colo 1
highlight LineNr ctermfg=darkgrey


" searching 
set hlsearch 
set incsearch 

set noerrorbells

" download vim-plug if missing
if empty(glob("~/.vim/autoload/plug.vim"))
  silent! execute '!curl --create-dirs -fsSLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * silent! PlugInstall
endif

" Plugins will be downloaded under the specified directory.
call plug#begin()
        Plug 'tpope/vim-sensible'
		Plug 'https://github.com/scrooloose/nerdtree'
		Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }	
		Plug 'statico/vim-javascript-sql'
        Plug 'AndrewRadev/splitjoin.vim'
        "Plug 'SirVer/ultisnips'
        "Plug 'ctrlpvim/ctrlp.vim'
        Plug 'leafgarland/typescript-vim'
        Plug 'peitalin/vim-jsx-typescript'
        Plug 'elixir-editors/vim-elixir'
        Plug 'tomlion/vim-solidity'
        Plug 'mrk21/yaml-vim'
        Plug 'nvim-lua/plenary.nvim'
        Plug 'nvim-telescope/telescope.nvim', {'tag': '0.1.2'}
        Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
        Plug 'slugbyte/lackluster.nvim'
        Plug 'frankroeder/parrot.nvim'
call plug#end()

nnoremap <leader>ff <cmd>Telescope find_files<cr> 
nnoremap <leader>f <cmd>Telescope live_grep<cr> 
nnoremap <leader>fg <cmd>Telescope git_files<cr> 


" set filetypes as typescriptreact
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescriptreact
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType markdown setlocal spell
autocmd FileType elixir setlocal omnifunc=lsp#complete

let g:go_play_browser_command = 'firefox %URL% &'
let g:go_jump_to_error = 0
let g:go_fmt_autosave = 1
let g:go_fmt_command = "goimports"
let g:go_metalinter_command='golangci-lint run'
let g:go_template_autocreate = 1
let g:go_template_use_pkg = 1
let g:go_list_autoclose = 1 
let g:go_textobj_include_function_doc = 1
let g:go_auto_sameids = 0
let g:go_highlight_function_calls = 0
let g:go_highlight_extra_types = 1
let g:go_highlight_operators = 1
let g:go_auto_type_info = 0
let g:go_highlight_format_strings = 1


" au filetype go inoremap <buffer> . .<C-x><C-o>
autocmd FileType go nmap <leader>b <Plug>(go-build)
autocmd FileType go nmap <leader>r <Plug>(go-run)
autocmd FileType go nmap <leader>t <Plug>(go-test)
autocmd FileType go nmap <leader>l <Plug>:GoMetaLinter
autocmd FileType go nmap <leader>f <Plug>:GoFmt 
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
" autocmd FileType go nmap <leader>d <Plug>:GoDoc :GoDoc is 'K'
" GoDef --> gd
" GoDefPop --> <C,t>
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>
map <leader>n :bnext<CR>
map <leader>p :bprevious<CR>
map <leader>d :bdelete<CR>

" parrot 
map <leader>cn :PrtChatNew vsplit<CR> 
map <leader>c :PrtChatToggle vsplit <CR> 
map <leader>cr :PrtChatResponde <CR> 


"  :AV open test file in vsp 
autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
" :AS open test file in sp
autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')

lua << EOF
    require('nvim-treesitter.configs').setup {
        -- Modules and its options go here
        highlight = { enable = true },
        incremental_selection = { enable = true },
        textobjects = { enable = true },
    }

    local lsp = require('lspconfig')

    lsp.gleam.setup({})
    lspconfig.gopls.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      cmd = {"gopls"},
      filetypes = { "go", "gomod", "gowork", "gotmpl" },
      root_dir = util.root_pattern("go.work", "go.mod", ".git"),
      settings = {
        gopls = {
          completeUnimported = true
          usePlaceholders = true,
          analyses = {
            unusedparams = true,
          },
        },
      },
    }

    lspconfig.gdscript.setup({})

    require("parrot").setup({
     chat_user_prefix = ">",
     llm_prefix = "llm>",
     toggle_target = "vsplit",
      providers = {
        anthropic = {
          api_key = os.getenv "ANTHROPIC_API_KEY",
        },
      }
    })
EOF

autocmd FileType gleam LspStart gleam 
autocmd BufWritePre *.gleam lua vim.lsp.buf.format({ async = false })
autocmd FileType gleam nmap <leader>ca <cmd>lua vim.lsp.buf.code_action()<CR> 

let g:gdot_executable = '/mnt/c\Users\tyler\Downloads\Godot_v4.2.1-stable_win64.exe'

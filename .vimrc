set tabstop=4
set softtabstop=4 
set shiftwidth=4
set expandtab
set number	
set nocompatible 
set hlsearch 
set incsearch 
set noerrorbells
set termguicolors 
set nowrap
filetype plugin indent on
colo 1

" download vim-plug if missing
if empty(glob("${XDG_CONFIG_HOME:-$HOME/.local/share}"))
  silent! execute '!curl --create-dirs -fsSLo ${XDG_CONFIG_HOME:-$HOME/.local/share} https://raw.github.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * silent! PlugInstall
endif

" Plugins will be downloaded under the specified directory.
call plug#begin()
        Plug 'tpope/vim-sensible'
		Plug 'https://github.com/scrooloose/nerdtree'
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
        Plug 'neovim/nvim-lspconfig'
        Plug 'slugbyte/lackluster.nvim'
        Plug 'hashivim/vim-terraform'
        Plug 'tpope/vim-fugitive'
        Plug 'ray-x/go.nvim'
        Plug 'ray-x/guihua.lua'
call plug#end()

nnoremap <leader>ff <cmd>Telescope find_files<cr> 
nnoremap <leader>f <cmd>Telescope live_grep<cr> 
nnoremap <leader>fg <cmd>Telescope git_files<cr> 


" set filetypes as typescriptreact
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescriptreact
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType markdown setlocal spell
autocmd FileType elixir setlocal omnifunc=lsp#complete

"let g:go_play_browser_command = 'firefox %URL% &'
"let g:go_jump_to_error = 0
"let g:go_fmt_autosave = 1
"let g:go_fmt_command = \"goimports\"
"let g:go_metalinter_command='golangci-lint run'
"let g:go_template_autocreate = 1
"let g:go_template_use_pkg = 1
"let g:go_list_autoclose = 1 
"let g:go_textobj_include_function_doc = 1
"let g:go_auto_sameids = 0
"let g:go_highlight_function_calls = 0
"let g:go_highlight_extra_types = 1
"let g:go_highlight_operators = 1
"let g:go_auto_type_info = 0
"let g:go_highlight_format_strings = 1


" au filetype go inoremap <buffer> . .<C-x><C-o>
" autocmd FileType go nmap <leader>b <Plug>(go-build)
" autocmd FileType go nmap <leader>r <Plug>(go-run)
" autocmd FileType go nmap <leader>t <Plug>(go-test)
" autocmd FileType go nmap <leader>l <Plug>:GoMetaLinter
" autocmd FileType go nmap <leader>f <Plug>:GoFmt 
" autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
" autocmd FileType go nmap <leader>d <Plug>:GoDoc :GoDoc is 'K'
" GoDef --> gd
" GoDefPop --> <C,t>
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>
map <leader>n :bnext<CR>
map <leader>p :bprevious<CR>
map <leader>d :bdelete<CR>

"  :AV open test file in vsp 
"autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
" :AS open test file in sp
"autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')

lua << EOF
    -- Install parsers (async, runs on startup)
    require('nvim-treesitter').install { 'go', 'markdown', 'vimdoc', 'vim', 'lua', 'javascript', 'typescript', 'html', 'css' }

    -- Enable treesitter highlighting for these filetypes
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'go', 'markdown', 'vim', 'lua', 'javascript', 'typescript', 'html', 'css' },
      callback = function() vim.treesitter.start() end,
    })

    -- LSP keymaps on attach
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(args)
        local opts = { noremap = true, silent = true, buffer = args.buf }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<leader>rf', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<leader>i', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<leader>dc', vim.lsp.buf.declaration, opts)
      end,
    })

    -- Configure gopls using native vim.lsp.config (Neovim 0.11+)
    vim.lsp.config.gopls = {
      cmd = { 'gopls' },
      filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
      root_markers = { 'go.work', 'go.mod', '.git' },
      settings = {
        gopls = {
          gofumpt = true,
          completeUnimported = true,
          staticcheck = true,
          analyses = {
            unusedparams = true,
          },
        },
      },
    }
    vim.lsp.enable('gopls')

    require('go').setup({
      lsp_codelens = true, 
      gocoverage_sign = "+",
    })

     -- Location list navigation (global)
     vim.keymap.set('n', '<C-n>', ':lnext<CR>', { noremap = true, silent = true })
     vim.keymap.set('n', '<C-m>', ':lprevious<CR>', { noremap = true, silent = true })
     vim.keymap.set('n', '<C-c>', ':lclose<CR>', { noremap = true, silent = true })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "go", 
      callback = function()
        local opts = { noremap = true, silent = false}
        vim.keymap.set('n', '<leader>l', function() vim.diagnostic.setloclist({open = true}) end, { desc = "Diagnostics to Loclist" })
        vim.keymap.set('n', '<leader>t', ":GoTestFile<CR>", opts)
        vim.keymap.set('n', '<leader>tc', ":GoCoverage<CR>", opts)
        vim.keymap.set('n', '<leader>a', ":GoAlt! <CR>", opts) -- Go to test file
      end
    })

     local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
       vim.api.nvim_create_autocmd("BufWritePre", {
         pattern = "*.go",
         callback = function()
          require('go.format').goimports()
         end,
         group = format_sync_grp,
       })


    vim.diagnostic.config({
     virtual_text = false, 
    })

    vim.keymap.set("n", "f", vim.diagnostic.open_float, { noremap = true, silent = true, desc = "Show diagnostics" })

      vim.api.nvim_create_autocmd('DiagnosticChanged', {
       group = vim.api.nvim_create_augroup('GoDiagnosticsLoclist', { clear = true }),
       pattern = '*.go',
       callback = function(args)
         vim.fn.setloclist(0, {}, ' ', {
           title = 'Go Diagnostics',
           items = vim.diagnostic.get(args.buf, { severity = { min = vim.diagnostic.severity.WARN } })
         })
       end,
    })

    vim.api.nvim_create_autocmd('FileType', { 
        pattern = {'tf'}, 
        callback = function(ev) 
          vim.cmd([[let g:terraform_fmt_on_save=1]])
          vim.cmd([[let g:terraform_align=1]])
          vim.keymap.set("n", "<leader>ti", ":!terraform init<CR>")
          vim.keymap.set("n", "<leader>tv", ":!terraform validate<CR>")
          vim.keymap.set("n", "<leader>tp", ":!terraform plan<CR>")
          vim.keymap.set("n", "<leader>taa", ":!terraform apply -auto-approve<CR>")
        end, 
        }
    )
    vim.opt.updatetime = 1000
EOF


" Author: Landon Bouma (landonb &#x40; retrosoft &#x2E; com)
" Project: https://github.com/DepoXy/vim-depoxy-coc-defaults#🥥
" License: CC0 1.0 <https://creativecommons.org/publicdomain/zero/1.0/>

if exists("g:plugin_vim_depoxy_coc_defaults_language_client") || &cp
  finish
endif
let g:plugin_vim_depoxy_coc_defaults_language_client = 1

" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

" REFER: Various vim-lsp options:
"
"   :h vim-lsp

" ***

" REFER: To disable LSP, run:
"
"   call lsp#disable()

" ***

" SAVVY: Already set:
"
"   let g:lsp_diagnostics_enabled = 1

" ***

" SAVVY: By default, vim-lsp shows a diagnostic column (two characters
" wide, just to the left of the line number) that shows diagnostic errors.
"
" - If you'd like to see the error message in the status line when the
"   cursor is on a line with a diagnostic message, set this:
"
"     let g:lsp_diagnostics_echo_cursor = 1
"
" - If you'd like to see the message in a popup under the cursor instead,
"   try this one (even more distracting than previous *_echo_cursor):
"
"     let g:lsp_diagnostics_float_cursor = 1

" ***

" By default, if you put the cursor over a known symbol,
" a moment later, the whole word is highlighted.
" - How distracting!

let g:lsp_highlight_references_enabled = 0

" ***

" Do not show autocomplete popup by default.
"
"   :h asyncomplete.vim
let g:asyncomplete_auto_popup = 0

" ***

" CXREF:
"   https://github.com/neoclide/coc.nvim#example-vim-configuration

function! s:lang_client_config_lsp()
  " Always show the signcolumn, otherwise it would shift the text each time
  " diagnostics appear/become resolved.
  if has("patch-8.1.1564")
    " Recently vim can merge signcolumn and number column into one
    set signcolumn=number
  else
    set signcolumn=yes
  endif

  " Use `[g` and `]g` to navigate diagnostics
  " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
  nmap <silent> [g <Plug>(coc-diagnostic-prev)
  nmap <silent> ]g <Plug>(coc-diagnostic-next)

  " GoTo code navigation.
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)

  " Use K to show documentation in preview window.
  nnoremap <silent> K :call <SID>show_documentation()<CR>

  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocActionAsync('doHover')
    endif
  endfunction
endfunction

call <SID>lang_client_config_lsp()

" ***

inoremap <silent><expr> <c-space> coc#refresh()


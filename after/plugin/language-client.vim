" Author: Landon Bouma <https://tallybark.com/>
" Project: https://github.com/DepoXy/vim-depoxy-coc-defaults#🥥
" License: CC0 1.0 <https://creativecommons.org/publicdomain/zero/1.0/>

if exists("g:plugin_vim_depoxy_coc_defaults_language_client") || &cp
  finish
endif
let g:plugin_vim_depoxy_coc_defaults_language_client = 1

" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

" USAGE: Enable `finish` and reopen Vim to test if any of the below
" conflicts with your other plugins.
"
"  finish

" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

function! s:wire_coc_nvim_config()
  " Seems like this should be noted on the CoC README, but don't
  " load any of these if the CoC extension is not loaded — especially
  " the <CR> imap, which breaks Vim if CoC not loaded (when you hit
  " <Enter> in Insert mode you get an error and not a newline).
  " - SAVVY: See `:h exists` — Use ':exists(*funcname)' to check if
  "   function defined.
  if !exists("*CocAction")

    return
  endif

  " ***

  " REFER: Circa 2024 config:
  "   https://raw.githubusercontent.com/neoclide/coc.nvim/master/doc/coc-example-config.vim
  " CXREF: Found locally within DepoXy environment at:
  "   ~/.vim/pack/neoclide/start/coc.nvim/doc/coc-example-config.vim

  " ***

  " May need for Vim (not Neovim) since coc.nvim calculates byte offset by count
  " utf-8 byte sequence
  "
  " SAVVY: Already set
  "   set encoding=utf-8

  " ***

  " Some servers have issues with backup files, see #649
  " REFER: https://github.com/neoclide/coc.nvim/issues/649
  "
  " SAVVY: Already set
  "   set nobackup
  "   set nowritebackup

  " ***

  " Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
  " delays and poor user experience
  set updatetime=300

  " ***

  " Always show the signcolumn, otherwise it would shift the text each time
  " diagnostics appear/become resolved
  "
  " REFER: See below
  "   set signcolumn=yes

  " ***

  " Use tab for trigger completion with characters ahead and navigate
  " NOTE: There's always complete item selected by default, you may want to enable
  "   no select by `"suggest.noselect": true` in your configuration file
  " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
  "   other plugin before putting this into your config
  " - SAVVY: DepoXy sets Insert mode <Tab> map:
  "
  "     :verbose imap <tab>
  "     i  <Tab>         <SNR>97_InsertSmartTab()
  "     Last set from ~/.vim/pack/landonb/start/dubs_edit_juice/plugin/smart-tabs.vim line 90
  "
  "   And the suggested mapping inhibits <Tab> after non-whitespace on a line:
  "
  "     " If menu visible, pick next suggestion.
  "     " If previous character is whitespace, insert <Tab>.
  "     " If previous character is not whitespace, show menu.
  "     inoremap <silent><expr> <TAB>
  "           \ coc#pum#visible() ? coc#pum#next(1) :
  "           \ CheckBackspace() ? "\<Tab>" :
  "           \ coc#refresh()
  "
  "     function! CheckBackspace() abort
  "       let col = col('.') - 1
  "       return !col || getline('.')[col - 1]  =~# '\s'
  "     endfunction
  "
  "   Also I cannot suss what coc#refresh() does, so we'll drop it,
  "   so that tabbing after non-whitespace isn't broken.
  " WORDS: pum → *popup menu*
  inoremap <expr> <TAB> coc#pum#visible() ? coc#pum#next(1) : InsertSmartTab()
  " If menu showing, select previous suggestion.
  " - Otherwise, <Shift-Tab> will now backspace
  "   (in stock Vim, <Shift-Tab> inserts <Tab>).
  "   - MAYBE: Find an alternative <Shift-Tab> behavior.
  inoremap <expr><S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

  " ***

  " SAVVY: coc.nvim wires a number of bindings to help navigate the pum,
  " so long as those bindings are not already mapped.
  "
  " - CXREF: See 'Default key-mappings for completion':
  "     ~/.vim/pack/neoclide/start/coc.nvim/plugin/coc.vim @ 709
  "
  " For DepoXy (which runs *Dubs Vim*, as author calls it, just a collection
  " of dozens of plugins), that means the CoC wires <PageUp> and <PageDown>
  " to help navigate the pum. But CoC skips <Up> and <Down>, because Dubs
  " maps those (to change how the cursor interacts with &wrap'ped lines).
  "
  " CoC skips <Up> and <Down> because Dubs already defines those.
  " - Specifically, CoC doesn't enter these branches:
  "     if empty(mapcheck('<down>', 'i'))
  "       inoremap <silent><expr> <down> coc#pum#visible() ? coc#pum#next(0) : "\<down>"
  "     endif
  "     if empty(mapcheck('<up>', 'i'))
  "       inoremap <silent><expr> <up> coc#pum#visible() ? coc#pum#prev(0) : "\<up>"
  "     endif
  " - To see the Dubs maps, run `:verbose imap <Up>` and `:verbose imap <Down>`
  "   and you'll find them defined by dubs_toggle_textwrap (see CXREF below):
  "       inoremap <silent> <Up>   <C-o>gk
  "       inoremap <silent> <Down> <C-o>gj
  "   - These mappings ensure <Up> and <Down> traverse visual boundaries,
  "     not logical ones, i.e., when &wrap is on, so the cursor is moved
  "     by a single visible line, and not by the logical line.
  "
  " So map <Up>/<Down> to work like <Tab>/<Shift-Tab>, to help naviage the
  " pum, but also ensure that dubs_toggle_textwrap also works as expected.
  "
  " - CXREF:
  "   ~/.vim/pack/landonb/start/dubs_toggle_textwrap/plugin/dubs_toggle_textwrap.vim
  "   ~/.vim/pack/landonb/start/dubs_toggle_textwrap/autoload/toggle_textwrap/wrapnav.vim
  function! s:SetupWrapping()
    function! s:EnableWrapNav()
      call g:toggle_textwrap#wrapnav#EnableWrapNav()
      inoremap <silent><expr> <Up> coc#pum#visible() ? coc#pum#prev(0) : "\<C-o>gk"
      inoremap <silent><expr> <Down> coc#pum#visible() ? coc#pum#next(0) : "\<C-o>gj"
    endfunction

    function! s:DisableWrapNav()
      call g:toggle_textwrap#wrapnav#DisableWrapNav()
      inoremap <silent><expr> <Up> coc#pum#visible() ? coc#pum#prev(0) : "\<C-o>k"
      inoremap <silent><expr> <Down> coc#pum#visible() ? coc#pum#next(0) : "\<C-o>j"
    endfunction

    " MIMIC: The ToggleWrap function, <Leader>w map, and the if-&wrap
    " block each reproduce what dubs_toggle_textwrap does.
    function! s:ToggleWrap()
      if &wrap
        echo "Wrap OFF"
        call s:DisableWrapNav()
      else
        echo "Wrap ON"
        call s:EnableWrapNav()
      endif
    endfunction

    " Toggle wrapping with \w
    " -------------------------
    " CALSO/2020-05-10: vim-surround also toggles wrap: `[ow`, `]ow`, and `yow`.
    silent! unmap <Leader>w
    noremap <silent> <Leader>w :call <SID>ToggleWrap()<CR>

    if &wrap
      call s:EnableWrapNav()
    else
      call s:DisableWrapNav()
    endif
  endfunction

  " If dubs_toggle_textwrap not active, coc.nvim will map <Up> and <Down>.
  " But if dubs_toggle_textwrap is active, we have to setup the maps.
  if exists("*g:toggle_textwrap#wrapnav#EnableWrapNav")
    call s:SetupWrapping()
  endif

  " ***

  " SAVVY: As mentioned in previous block, coc.nvim skips its default
  " bindings if those bindings are already mapped.
  "
  " This includes two other bindings, <C-e> and <C-y>.
  "
  " coc.nvim would otherwise set them thusly:
  "
  "   inoremap <silent><expr> <C-e> coc#pum#visible() ? coc#pum#cancel() : "\<C-e>"
  "   inoremap <silent><expr> <C-y> coc#pum#visible() ? coc#pum#confirm() : "\<C-y>"
  "
  " But Dubs Vim got to <C-e> first:
  "
  "   inoremap <C-e> <C-o><C-e>
  "
  "	- CXREF: ~/.vim/pack/landonb/start/dubs_appearance/plugin/scroll_window_fix.vim @ 46
  "
  "	And Vim itself assigns <C-y> if mswin is enabled:
  "
  "   inoremap <C-Y> <C-O><C-R>
  "
  "	- CXREF: ~/.local/share/vim/vim91/mswin.vim @ 79
  "	  /Applications/MacVim.app/Contents/Resources/vim/runtime/mswin.vim @ 99
  "
  " SAVVY: When mswin is not enabled, in normal mode, C-e scrolls the
  "        window down, and C-y scrolls it up. And in insert mode, C-e
  "        mirrors the characters from the line below, one character at
  "        a time; and C-y similarly mirrors the line above.
  "        - But when using mswin mappings, C-y is mapped to redo in both
  "          modes. And C-e is left alone.
  "         - But redo is also found at <C-y>, which is the more conventional
  "           mapping (that other apps tend to use, if not <Shift-Ctrl-Z>
  "           or <Shift-Cmd-Z>).
  "         - For parity with normal mode, Dubs Vim restores the <C-e>
  "           binding, so it scrolls the window up one line.
  "           - And Dubs Vim uses <M-e> for scroll up one line.
  "           - I.e., <Ctrl-E> down, <Alt-E> up.
  "
  " Note that <Esc> also cancels the pum, but it also leaves Insert mode.
  inoremap <silent><expr> <C-e> coc#pum#visible() ? coc#pum#cancel() : "\<C-o><C-e>"
  " Note that <CR> also confirms the pum selection (mapped below).
  inoremap <silent><expr> <C-y> coc#pum#visible() ? coc#pum#confirm() : "\<C-O><C-R>"

  " ***

  " Make <CR> to accept selected completion item or notify coc.nvim to format
  " <C-g>u breaks current undo, please make your own choice
  " - The suggestion from coc.nvim/README inhibits <CR> from completing
  "   abbreviations (:iabbrev) — e.g., `myabbrev<CR>` won't work, but
  "   `myabbrev<Ctrl-CR>` and `myabbrev<Ctrl-Space>` both still work.
  " - DUNNO: I'm unsure what the `\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>`
  "   does. My testing reveals similar behavior with or without it.
  "   - The coc.nvim/README says 'to format', so maybe it has to do
  "     with... formatting the adjacent code?
  "   - Anyway, here's the snippet from the README:
  "
  "       inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
  "         \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
  "
  " - And here's our approach. Use <CR> to accept the selected drop-down
  "   suggestion, otherwise <CR> behaves normally.
  inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

  " ***

  " Use <C-Space> to trigger completion.
  " SAVVY: Circa 2020, coc-nvim README suggested <Ctrl-Space> for both
  " Neovim and Vim. But circa 2024, its README now suggests <Ctrl-Space>
  " for Neovim, and <Ctrl-@> if not Neovim.
  " - E.g.,
  "     if has('nvim')
  "       inoremap <silent><expr> <C-Space> coc#refresh()
  "     else
  "       inoremap <silent><expr> <C-@> coc#refresh()
  "     endif
  " - But author not sure why the difference between Vims, because
  "   <Ctrl-Space> is generally not otherwise wired in Vim.
  " - Also, <Ctrl-@> is awkward to press. If your pinky finger is on
  "   the Control key, it requires scrunching it down at a weird angle
  "   to reach the '@' key with either your middle or pointer finger.
  " So let's use <Ctrl-Space> no matter the Vim.
  " - Another option could be <Shift-Space>, which is also pretty easy to
  "   press, and easy to remember (though not as comfortable to press as
  "   <Ctrl-Space>, IMO).
  inoremap <silent><expr> <C-Space> coc#refresh()

  " ***

  " CXREF: Circa 2019 config:
  "   https://github.com/neoclide/coc.nvim#example-vim-configuration

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
  nnoremap <silent> K :call <SID>ShowDocumentation()<CR>

  " 2024-11-27: Previous impl:
  "
  " function! s:ShowDocumentation()
  "   if (index(['vim','help'], &filetype) >= 0)
  "     execute 'h '.expand('<cword>')
  "   else
  "     call CocActionAsync('doHover')
  "   endif
  " endfunction
  function! ShowDocumentation()
    if CocAction('hasProvider', 'hover')
      call CocActionAsync('doHover')
    else
      call feedkeys('K', 'in')
    endif
  endfunction

  " ***

  " CXREF: Circa 2024 config:
  " https://raw.githubusercontent.com/neoclide/coc.nvim/master/doc/coc-example-config.vim

  " Highlight the symbol and its references when holding the cursor
  autocmd CursorHold * silent call CocActionAsync('highlight')

  " Symbol renaming
  " SAVVY: Conflicts with \r long-line enforcement toggle.
  " nmap <leader>rn <Plug>(coc-rename)

  " Formatting selected code
  " SAVVY: Conflicts with \f FZF popup.
  " xmap <leader>f  <Plug>(coc-format-selected)
  " nmap <leader>f  <Plug>(coc-format-selected)

  augroup mygroup
    autocmd!
    " Setup formatexpr specified filetype(s)
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  augroup end

  " Applying code actions to the selected code block
  " Example: `<leader>aap` for current paragraph
  xmap <leader>a  <Plug>(coc-codeaction-selected)
  nmap <leader>a  <Plug>(coc-codeaction-selected)

  " Remap keys for applying code actions at the cursor position
  nmap <leader>ac  <Plug>(coc-codeaction-cursor)
  " Remap keys for apply code actions affect whole buffer
  nmap <leader>as  <Plug>(coc-codeaction-source)
  " Apply the most preferred quickfix action to fix diagnostic on the current line
  " SAVVY: Conflicts with DepoXy \q :netrw popup.
  " nmap <leader>qf  <Plug>(coc-fix-current)

  " Remap keys for applying refactor code actions
  " SAVVY: Conflicts with \r long-line enforcement toggle.
  " nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
  " xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
  " nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

  " Run the Code Lens action on the current line
  nmap <leader>cl  <Plug>(coc-codelens-action)

  " Map function and class text objects
  " NOTE: Requires 'textDocument.documentSymbol' support from the language server
  " xmap if <Plug>(coc-funcobj-i)
  " omap if <Plug>(coc-funcobj-i)
  " xmap af <Plug>(coc-funcobj-a)
  " omap af <Plug>(coc-funcobj-a)
  " xmap ic <Plug>(coc-classobj-i)
  " omap ic <Plug>(coc-classobj-i)
  " xmap ac <Plug>(coc-classobj-a)
  " omap ac <Plug>(coc-classobj-a)

  " Remap <C-f> and <C-b> to scroll float windows/popups
  if has('nvim-0.4.0') || has('patch-8.2.0750')
    nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
    inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
    vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  endif

  " Use CTRL-S for selections ranges
  " Requires 'textDocument/selectionRange' support of language server
  " SAVVY: Conflicts with Dubs Vim <Ctrl-S> save
  " nmap <silent> <C-s> <Plug>(coc-range-select)
  " xmap <silent> <C-s> <Plug>(coc-range-select)

  " Add `:Format` command to format current buffer
  command! -nargs=0 Format :call CocActionAsync('format')

  " Add `:Fold` command to fold current buffer
  command! -nargs=? Fold :call CocAction('fold', <f-args>)

  " Add `:OR` command for organize imports of the current buffer
  command! -nargs=0 OR :call CocActionAsync('runCommand', 'editor.action.organizeImport')

  " Add (Neo)Vim's native statusline support
  " NOTE: Please see `:h coc-status` for integrations with external plugins
  "   that provide custom statusline: lightline.vim, vim-airline
  " SAVVY: Help says might need to ensure statusline automatically refreshed:
  "   autocmd User CocStatusChange redrawstatus
  " SAVVY: The ^= prepends this line to the existing statusline,
  "   e.g., to dubs_mescaline.
  " ISOFF: If I disable dubs_mescaline, when I use a completion, I just
  "   see 'SNIP' printed to the status line. Meh.
  "
  "  set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

  " Mappings for CoCList
  " Show all diagnostics
  nnoremap <silent><nowait> <space>a :<C-u>CocList diagnostics<cr>
  " Manage extensions
  nnoremap <silent><nowait> <space>e :<C-u>CocList extensions<cr>
  " Show commands
  nnoremap <silent><nowait> <space>c :<C-u>CocList commands<cr>
  " Find symbol of current document
  nnoremap <silent><nowait> <space>o :<C-u>CocList outline<cr>
  " Search workspace symbols
  nnoremap <silent><nowait> <space>s :<C-u>CocList -I symbols<cr>
  " Do default action for next item
  nnoremap <silent><nowait> <space>j :<C-u>CocNext<CR>
  " Do default action for previous item
  nnoremap <silent><nowait> <space>k :<C-u>CocPrev<CR>
  " Resume latest coc list
  nnoremap <silent><nowait> <space>p :<C-u>CocListResume<CR>

  " ***

  " REFER: https://github.com/fannheyward/coc-pyright/issues/521#issuecomment-858530052
  "   https://github.com/neoclide/coc.nvim/wiki/Using-workspaceFolders#resolve-workspace-folder
  "   :CocList folders
  " Look up from current file for one of these file/directories to identyify workspace root.
  autocmd FileType python let b:coc_root_patterns 
    \ = ['.git', '.env', 'venv', '.venv', 'setup.cfg', 'setup.py', 'pyproject.toml', 'pyrightconfig.json']
endfunction

call <SID>wire_coc_nvim_config()


# vim-depoxy-coc-defaults

Opinionated [`coc`](https://github.com/neoclide/coc.nvim) defaults.

## Introduction

Sets opinionated [`coc`](https://github.com/neoclide/coc.nvim) defaults.

- Disables highlighting symbol on hover.

      let g:lsp_highlight_references_enabled = 0

- Disables autocomplete popup by default.

      let g:asyncomplete_auto_popup = 0

- Always show `signcolumn` to avoid jittery UX.

      set signcolumn=number

- Adds a handful of useful commands (see below).

### Requirements

This plug-in requires `coc` and whatever else it requires.

  https://github.com/neoclide/coc.nvim

You'll also need LSPes for your languages, e.g.,

  https://github.com/neoclide/coc-tsserver

  https://github.com/neoclide/coc-json

## Commands

Use `[g` and `]g` to navigate diagnostics:

- `[g` — Calls `coc-diagnostic-prev`

- `]g` — Calls `coc-diagnostic-next`

Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.

Find definition and usages, etc.:

- `gd` — Calls `coc-definition`

- `gy` — Calls `coc-type-definition`

- `gi` — Calls `coc-implementation`

- `gr` — Calls `coc-references`

Other:

- `K` — Shows documentation for keyword under cursor

## INSTALL

Installation is easy using Vim's packages feature (see ``:help packages``).

If you want the plugin to load automatically on Vim startup,
use a ``start/`` directory, e.g.,

  ```shell
  mkdir -p ~/.vim/pack/landonb/start
  ```

And then clone the project to that path:

  ```shell
  cd ~/.vim/pack/landonb/start
  git clone https://github.com/landonb/vim-depoxy-coc-defaults.git
  ```

If you want to test the package first, make it optional instead
(see ``:help pack-add``):

  ```shell
  mkdir -p ~/.vim/pack/landonb/opt
  cd ~/.vim/pack/landonb/opt
  git clone https://github.com/landonb/vim-depoxy-coc-defaults.git

  " When ready, load the [opt]ional plugin (or is it [opt]-in?).
  :packadd! vim-depoxy-coc-defaults
  ```

To build the help, ensure the plugin is loaded, and then
run the following command just one time from within Vim:

  ```shell
  :Helptags
  ```

Or, you can build the help from the terminal instead. Run:

  ```shell
  vim -u NONE -c "helptags vim-depoxy-coc-defaults/doc" -c q
  ```

And then to view the help from within Vim, run:

  ```shell
  :help vim-depoxy-coc-defaults
  ```

## SEE ALSO

  DepoXy Development Environment Orchestrator

  https://github.com/DepoXy/depoxy#🍯

## AUTHOR

**vim-depoxy-coc-defaults** is Copyright (c) 2020-2023 Landon Bouma &lt;depoxy@tallybark.com&gt;

This software is released under the MIT license (see `LICENSE` file for more)

## REPORTING BUGS

&lt;https://github.com/DepoXy/vim-depoxy-coc-defaults/issues&gt;


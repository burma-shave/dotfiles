# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal dotfiles: a Neovim config (`nvim/`) and a tmux config (`.tmux.conf`). There is no build or test suite.

`./install.sh` symlinks everything into `$HOME` with plain `ln -sT` lines; add one per new dotfile. It never overwrites anything: each `ln` whose target already exists (including a link from a previous run) prints an "Already exists" error and the rest still run, so re-running just links whatever is new. To replace a target, remove or move it aside by hand. Test it against a throwaway home with `HOME=/some/tmp/dir ./install.sh`.

## Neovim config (`nvim/`)

Targets **Neovim 0.12+** and relies on built-in APIs instead of third-party equivalents. Don't add lazy.nvim, nvim-treesitter, or `require('lspconfig').X.setup()`-style code.

- **Plugins**: managed by the built-in `vim.pack` (`vim.pack.add { ... }` in `init.lua`). Revisions are pinned in `nvim-pack-lock.json`, which `vim.pack` writes; don't hand-edit it. Update with `:lua vim.pack.update()`. blink.cmp is held to `1.*` on purpose, and it uses the Lua fuzzy matcher so no Rust binary is needed.
- **Single-file layout**: almost everything is in `init.lua`, in kickstart-style `-- [[ Section ]]` blocks. Pickers, the file explorer, textobjects, and surround all come from `mini.nvim` (mini.pick/extra/files/ai/surround/visits), not telescope or snacks.
- **LSP wiring is spread over three places**:
  1. `init.lua`: mason installs servers, `mason-lspconfig` auto-enables every Mason-installed server, and `mason-tool-installer` ensures `jdtls` is installed.
  2. `after/lsp/<server>.lua`: per-server overrides that return a `vim.lsp.Config`, merged over the configs shipped by nvim-lspconfig and nvim-jdtls (`:help lsp-config-merge`). Add new server settings here.
  3. `ftplugin/<ft>.lua`: buffer-local, filetype-specific keymaps (e.g. jdtls refactors in `ftplugin/java.lua`).
- **Keymap conventions**: LSP actions use Neovim's default `gr*` prefix (`grn`, `gra`, `grd`, ...) and are redefined only to give them readable `desc`s. Java extras continue that prefix (`gro`, `grs`, `grv`, ...). Leader is `<space>`; `<leader>s*` is search and `<leader>t*` is toggles, and both groups are registered with which-key. Descriptions use the `[X]` mnemonic style, e.g. `'[S]earch [F]iles'`.
- **jdtls** (`after/lsp/jdtls.lua`): `cmd` is a function so it can build a per-project workspace dir under `stdpath('cache')/jdtls/workspace/<name>-<hash>`. It also keeps Eclipse metadata out of project roots and sets `-Xmx8G`.
- **Style**: Lua uses 2-space indentation (see the modeline). The editor defaults are real tabs at width 4. `.luarc.json` is gitignored.

## Testing changes

There are no automated tests. To check that the config loads without errors:

```sh
NVIM_APPNAME=<name> nvim --headless +qa   # with the config at ~/.config/<name>
```

Or run `:checkhealth` inside Neovim.

## tmux (`.tmux.conf`)

This is a minimal config tuned for the Kitty terminal: vi keys, extended keys, and OSC 52 clipboard passthrough through `terminal-features`. Neovim's `vim.o.clipboard = 'unnamedplus'` and the `focus-events` setting both depend on these terminal-features lines.

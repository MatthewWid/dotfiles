# Dotfiles

This repository contains my personal dotfiles. I am an experienced software engineer who mostly works on web-based application development.

I primary work in TypeScript (JavaScript), Python and .NET.

## Development Environment

I have an entirely terminal-based setup.

- Windows 11 with WSL 2 running Linux/Ubuntu
- tmux
- zsh + Oh My Zsh
- NeoVim
- fzf + ripgrep
- ranger

I prefer using Neovim for development, but I also use VS Code for some projects.

I prefer using pnpm for JS/TS package management, but npm for global packages.

I prefer using fnm for Node.js version management, but some projects I work on use nvm.

Dropbox is running in the background of the Windows host which continually syncs my dotfiles to the cloud, though you may not see Dropbox appear in the WSL process list. Be prepared that you may be momentarily unable to modify files again just after they have been modified, as Dropbox holds a handle on the file while it is syncing.

### NeoVim

Config lives in `dotfiles/nvim/`, split into one file per concern rather than a single `init.lua`:

- `init.lua` bootstraps `lazy.nvim` and auto-discovers plugins by scanning `plugins/*/` (no manual
  registration needed for a new plugin).
- `options.lua`, `keymaps.lua`, `commands.lua`, `autocmds.lua` hold everything not specific to a
  single plugin.
- `plugins/<name>/` holds one plugin's `init.lua` (spec + config), plus `keymaps.lua` and
  `autocmds.lua` where relevant — so any plugin's full config is fuzzy-findable by name.
- No `lua/` subdirectory — `init.lua` extends `package.path` manually instead.

LSP/completion stack: `mason.nvim` (installs LSP server binaries) + `nvim-lspconfig` (wires them
into Neovim's built-in LSP client) + `nvim-cmp` (completion popup UI, sources from LSP/buffer/
path/snippets). Fuzzy finding via `telescope.nvim`.

Deployed to the live system via `dotfiles/sync link`, which must be run from inside the Dropbox
copy of this the source files (not the git directory) for the symlinks to point at the right place.

#### Caveats

Plugins are lazy-loaded. A custom `vim.api.nvim_create_user_command(...)` defined inside a
plugin's `config` function doesn't exist until that plugin has already loaded — it also needs to
be listed in that plugin's `cmd = {...}` table, or calling it raises `E492: Not an editor
command`.

To test a change to `nvim/`: `nvim -u dotfiles/nvim/init.lua` does not work, since `init.lua` now
does `require()` calls that depend on `stdpath("config")`, which does not follow `-u`. Instead:
`ln -sfn <path-to-nvim-dir> ~/.config/nvim-test && NVIM_APPNAME=nvim-test nvim` for an isolated
live test.

## Commits

My `dotfiles-sync` project runs a job once every day to pull the latest changes from Dropbox and commit them to this repository.

Its commits are formatted as follows:

```
chore: automated backup - Day, DD Mon YYYY HH:MM:SS GMT
```

If you ever write a commit to this repository, please use the following format:

```
chore: manual backup - Day, DD Mon YYYY HH:MM:SS GMT
```

NEVER push changes to the remote without asking. NEVER copy to Dropbox without asking. If you do get confirmation that you may push, that confirmation is only for that one instance you are requesting. If you would like to push again, you MUST ask for permission again.

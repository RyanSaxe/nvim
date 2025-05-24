# 💤 LazyVim Anywhere I Go

This repo is setup to ensure I can have the exact same setup on any server or computer. It contains my neovim configuration and automation to ensure I can install all the things I normally depend on with a script so I don't have to worry about it. Eventually this may grow beyond just neovim and also contain a variety of other utilities and tools as well.

## Installation Instructions

```bash
git clone https://github.com/RyanSaxe/lazy.nvim ~/.config/nvim
cd ~/.config/nvim
./scripts/install.sh
nvim
```

## LazyVim Links

This repo is a fork of the starter template for [LazyVim](https://github.com/LazyVim/LazyVim). Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

--- below is a comment from GPT, should inspect it and make sure it makes sense and actually update things

### Tips & gotchas

| Situation | Fix |
|-----------|-----|
| **Plugins with `lazy=true` don’t appear in `:checkhealth`** | They’re loaded on demand. CI already calls `Lazy! sync`, which forces installation but not runtime load. For health coverage, add `require("lazy").load({plugins={"which-key.nvim","noice.nvim"}, wait=true})` *before* `:checkhealth`, or simply leave them `lazy=false` during CI. |
| **Treesitter parsers missing** | Add a post-step: `nvim --headless "+TSUpdateSync" +qa` (wrap in `|| true` if some langs optional). |
| **Windows support** | Use `choco install neovim ripgrep` and add a PowerShell bootstrap, or leverage a Docker image. |

---

### Why this works everywhere

* **Package detection** instead of `$OSTYPE` heuristics keeps the script tiny.
* `nvim --headless "+Lazy! sync" +qa` blocks until every plugin is installed / updated / compiled :contentReference[oaicite:2]{index=2}.
* `:checkhealth` is the source-of-truth the Neovim team recommends after any update :contentReference[oaicite:3]{index=3}.
* By grepping for **ERROR/FAIL**, you fail fast without parsing ANSI colours.

Drop these two files into your repo and every new machine (or GitHub runner) gets a reproducible Neovim in one command—and you’ll know immediately if any future change breaks the setup.
::contentReference[oaicite:4]{index=4}

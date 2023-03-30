# .nvim.nvim

Put project-specific Neovim configuration in a `.nvim` directory and load it
automatically when starting Neovim. It will call `dofile` on every _lua_ file
in `opts.dir`, granted:

- the file exists (obviously)
- and it is owned by the current user

## Install

However you like, along with [luafilesystem].

## Usage

```lua
-- these are the defaults
local opts = {
  dir = ".nvim"
}

require("dot-nvim").load(opts)
```

[luafilesystem]: https://github.com/lunarmodules/luafilesystem

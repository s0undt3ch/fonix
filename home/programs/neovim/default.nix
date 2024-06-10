{
  inputs,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:
let
  treesitterWithGrammars = pkgs-unstable.vimPlugins.nvim-treesitter.withPlugins (p: [
    p.bash
    p.comment
    p.css
    p.dockerfile
    p.fish
    p.gitattributes
    p.gitignore
    p.go
    p.gomod
    p.gowork
    p.hcl
    p.javascript
    p.jq
    p.json5
    p.json
    p.lua
    p.make
    p.markdown
    p.nix
    p.python
    p.rust
    p.toml
    p.typescript
    p.vue
    p.yaml
  ]);

  treesitter-parsers = pkgs-unstable.symlinkJoin {
    name = "treesitter-parsers";
    paths = treesitterWithGrammars.dependencies;
  };
in
{
  programs.lazygit = {
    enable = true;
  };
  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs-unstable.system}.default;
    viAlias = true;
    vimAlias = true;
    coc.enable = false;
    withNodeJs = true;

    extraPackages = with pkgs; [
      ripgrep
      fd
      lua-language-server
      rust-analyzer-unwrapped
      black
      xclip
      stylua
      marksman
      markdownlint-cli
      python3
    ];

    plugins = with pkgs-unstable.vimPlugins; [
      lazy-nvim
      treesitterWithGrammars
    ];

    extraLuaConfig =
      let
        plugins = with pkgs-unstable.vimPlugins; [
          # LazyVim
          LazyVim
          treesitterWithGrammars
          bufferline-nvim
          cmp-buffer
          cmp-nvim-lsp
          cmp-path
          conform-nvim
          crates-nvim
          dressing-nvim
          flash-nvim
          friendly-snippets
          gitsigns-nvim
          headlines-nvim
          indent-blankline-nvim
          lazygit-nvim
          lualine-nvim
          markdown-preview-nvim
          neo-tree-nvim
          noice-nvim
          nui-nvim
          nvim-cmp
          nvim-config-local
          nvim-lint
          nvim-lspconfig
          nvim-notify
          nvim-spectre
          nvim-web-devicons
          persistence-nvim
          plenary-nvim
          rustaceanvim
          SchemaStore-nvim
          semshi
          telescope-fzf-native-nvim
          telescope-nvim
          #telescope-terraform
          #telescope-terraform-doc
          todo-comments-nvim
          tokyonight-nvim
          trim-nvim
          trouble-nvim
          vim-startuptime
          vim-tmux-navigator
          which-key-nvim
          {
            name = "mini.bufremove";
            path = mini-nvim;
          }
          {
            name = "mini.pairs";
            path = mini-nvim;
          }
          {
            name = "catppuccin";
            path = catppuccin-nvim;
          }
        ];
        mkEntryFromDrv =
          drv:
          if lib.isDerivation drv then
            {
              name = "${lib.getName drv}";
              path = drv;
            }
          else
            drv;
        lazyPath = pkgs-unstable.linkFarm "lazy-plugins" (builtins.map mkEntryFromDrv plugins);
      in
      ''
        -- bootstrap lazy.nvim, LazyVim and your plugins

        -- Set <space> as the leader key
        -- See `:help mapleader`
        --  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
        vim.g.mapleader = " "
        vim.g.maplocalleader = " "

        local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
        if not vim.loop.fs_stat(lazypath) then
          -- bootstrap lazy.nvim
          -- stylua: ignore
        vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
        end
        vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

        -- Add the nix treesitter-parsers to the runtime path
        vim.opt.runtimepath:append("${treesitter-parsers}")

        require("lazy").setup({
          spec = {
            -- add LazyVim and import its plugins
            { "LazyVim/LazyVim", import = "lazyvim.plugins" },
            -- The following configs are needed for fixing lazyvim on nix
            -- force enable telescope-fzf-native.nvim
            { "nvim-telescope/telescope-fzf-native.nvim", enabled = true },
            -- disable mason.nvim, use programs.neovim.extraPackages
            { "williamboman/mason-lspconfig.nvim", enabled = false },
            { "williamboman/mason.nvim", enabled = false },
            {
              -- treesitter is handled by nix
              "nvim-treesitter/nvim-treesitter",
              opts = { ensure_installed = {} },
              pin = true -- don't include in updates
            },
            -- import any extras modules here
            -- import/override with your plugins
            { import = "plugins" },
          },
          defaults = {
            -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
            -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
            lazy = false,
            -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
            -- have outdated releases, which may break your Neovim install.
            version = false, -- always use the latest git commit
            -- version = "*", -- try installing the latest stable version for plugins that support semver
          },
          dev = {
            -- reuse files from pkgs.vimPlugins.*
            path = "${lazyPath}",
            patterns = { "." },
            -- fallback to download
            fallback = true,
          },
          -- install = { colorscheme = { "tokyonight", "habamax" } },
          checker = { enabled = true }, -- automatically check for plugin updates
          performance = {
            rtp = {
              -- disable some rtp plugins
              disabled_plugins = {
                "gzip",
                -- "matchit",
                -- "matchparen",
                -- "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
              },
            },
          },
        })

        vim.g.autoformat = false
        vim.g.python3_host_prog = "${pkgs.python3}/bin/python"
      '';
  };

  home.file."./.config/nvim/" = {
    source = ./nvim;
    recursive = true;
  };

  # Treesitter is configured as a locally developed module in lazy.nvim
  # we hardcode a symlink here so that we can refer to it in our lazy config
  home.file."./.local/share/nvim/nix/nvim-treesitter/" = {
    recursive = true;
    source = treesitterWithGrammars;
  };
}

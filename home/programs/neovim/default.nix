{
  inputs,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:
let
  treesitterPath = pkgs-unstable.symlinkJoin {
    name = "lazyvim-nix-treesitter-parsers";
    paths = pkgs-unstable.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
  };

  pluginPath = import ./plugins.nix { inherit pkgs-unstable lib inputs; };
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
    withPython3 = true;
    extraPython3Packages = ps: [ ];

    extraPackages = with pkgs-unstable; [
      fd
      python3
      ripgrep
      xclip

      # Formatters
      black
      stylua
      nixfmt-rfc-style

      # Language Servers
      basedpyright
      lua-language-server
      marksman # Markdown
      nil # Nix
      nodePackages.typescript-language-server
      ruff-lsp
      rust-analyzer
      taplo # TOML
      vscode-langservers-extracted # css-lsp
      yaml-language-server

      # Linters
      markdownlint-cli
    ];

    extraLuaConfig =
      # lua
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
            -- import any extras modules here
            { import = "lazyvim.plugins.extras.lang.python" },
            { import = "lazyvim.plugins.extras.lang.typescript" },
            -- import/override with your plugins
            { import = "plugins" },
            -- put this line at the end of spec to clear ensure_installed
            {
              "nvim-treesitter/nvim-treesitter",
              init = function()
                -- Put treesitter path as first entry in rtp
                vim.opt.rtp:prepend("${treesitterPath}")
              end,
              opts = {
                auto_install = false,
                ensure_installed = {},
              },
              pin = true -- don't include in updates
            },
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
            path = "${pluginPath}",
            patterns = { "." },
            -- fallback to download
            fallback = true,
          },
          -- install = { colorscheme = { "tokyonight", "habamax" } },
          checker = { enabled = true }, -- automatically check for plugin updates
          performance = {
            paths = {
              "${./nvim/lua/config}",
            },
            rtp = {
              -- disable some rtp plugins
              disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
              },
            },
          },
        })

        vim.g.autoformat = false
      '';
  };

  home.file."./.config/nvim/" = {
    source = ./nvim;
    recursive = true;
  };
}

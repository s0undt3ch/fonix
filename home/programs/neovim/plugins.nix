{
  pkgs-unstable,
  inputs,
  lib,
  ...
}:
let
  venv-selector-nvim = pkgs-unstable.vimUtils.buildVimPlugin {
    name = "venv-selector.nvim";
    src = inputs.venv-selector-nvim;
  };

  ansible-nvim = pkgs-unstable.vimUtils.buildVimPlugin {
    name = "ansible-nvim";
    src = inputs.ansible-nvim;
  };

  mkEntryFromDrv =
    drv:
    if lib.isDerivation drv then
      {
        name = "${lib.getName drv}";
        path = drv;
      }
    else
      drv;

  plugins = with pkgs-unstable.vimPlugins; [
    ansible-nvim
    bufferline-nvim
    cmp-buffer
    cmp-nvim-lsp
    cmp-path
    conform-nvim
    crates-nvim
    dashboard-nvim
    dressing-nvim
    flash-nvim
    friendly-snippets
    gitsigns-nvim
    headlines-nvim
    indent-blankline-nvim
    lazy-nvim
    lazygit-nvim
    LazyVim
    lualine-nvim
    markdown-preview-nvim
    neo-tree-nvim
    neoconf-nvim
    neodev-nvim
    noice-nvim
    nui-nvim
    nvim-cmp
    nvim-config-local
    nvim-lint
    nvim-lspconfig
    nvim-notify
    nvim-snippets
    nvim-spectre
    nvim-treesitter
    nvim-treesitter-context
    nvim-treesitter-textobjects
    nvim-ts-autotag
    nvim-ts-context-commentstring
    nvim-web-devicons
    persistence-nvim
    plenary-nvim
    rustaceanvim
    SchemaStore-nvim
    telescope-fzf-native-nvim
    telescope-nvim
    todo-comments-nvim
    tokyonight-nvim
    trim-nvim
    trouble-nvim
    ts-comments-nvim
    vim-startuptime
    vim-tmux-navigator
    which-key-nvim
    {
      name = "mini.ai";
      path = mini-nvim;
    }
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
    {
      name = "yanky.nvim";
      path = yanky-nvim;
    }
    {
      name = "venv-selector.nvim";
      path = venv-selector-nvim;
    }
  ];
in
# Link together all plugins into a single derivation
pkgs-unstable.linkFarm "lazyvim-nix-plugins" (builtins.map mkEntryFromDrv plugins)

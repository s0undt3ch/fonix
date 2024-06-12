{ pkgs, ... }:
let
  username = "vampas";
in
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    sessionVariables = {
      EDITOR = "nvim";
      NIX_PATH = "nixpkgs=flake:nixpkgs\${NIX_PATH:+:$NIX_PATH}";
    };
    packages = with pkgs; [
      actionlint # GitHub Actions Linter, used by pre-commit hooks
      jq
      pre-commit
      git-doc
      python3
      ripgrep
      ruff
      black
    ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  imports = [
    ../../programs/git.nix
    ../../programs/tmux.nix
    ../../programs/neovim
    ../../programs/gpg.nix
    ../../programs/kitty.nix
    ../../programs/plasma.nix
    ../../programs/spotify.nix
    ../../programs/github.nix
    ../../programs/starship.nix
    ../../programs/catppuccin.nix
  ];
}

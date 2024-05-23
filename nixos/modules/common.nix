{ pkgs, ... }:
{

  # Vim should be the default editor
  programs.vim.defaultEditor = true;

  environment.systemPackages = with pkgs; [
    git
    just
    home-manager
  ];

  # Enable 'locate foo' service
  services.locate = {
    enable = true;
    package = pkgs.mlocate;
    interval = "hourly";
    localuser = null;
  };

  imports = [
    ./user.nix
    ./nix-options.nix
    ./locale.nix
  ];

}
{ pkgs, ... }:
{
  # Vim should be the default editor
  programs.vim.defaultEditor = true;

  # So that GTK apps look properly under KDE
  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    git
    just
    home-manager
    killall
    nfs-utils
  ];

  environment.shells = with pkgs; [
    bash
    zsh
  ];

  # To lock NFS share mounts
  boot.supportedFilesystems = [ "nfs" ];
  services.rpcbind.enable = true;

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
    ./zsh.nix
  ];
}

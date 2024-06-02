{
  inputs,
  outputs,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./hardware/fonix-vm.nix
    ./modules/common.nix
    ./modules/fonts.nix
    ./modules/locale.nix
    ./modules/vm.nix
  ];

  networking.hostName = "fonix";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.defaultSession = "plasma";
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  environment.plasma6.excludePackages = with pkgs.kdePackages; [ kate ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Install firefox.
  programs.firefox.enable = true;

  # Vim should be the default editor
  programs.vim.defaultEditor = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    git
    just
    skanpage
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}

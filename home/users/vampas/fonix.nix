{ pkgs, ... }:
{
  imports = [
    ./common.nix
    ../../programs/vlc.nix
    ../../programs/user-scripts.nix
  ];

  home = {
    packages = with pkgs; [ ];

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "24.05";
  };
}

{ ... }:
{

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
  imports = [
    ./common.nix
    ../../programs/fish
  ];
}

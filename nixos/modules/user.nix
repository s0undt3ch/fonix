{ pkgs, ... }:
{
  users.users = {
    vampas = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # Add your SSH public key(s) here, if you plan on using SSH to connect
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICMmO8zkmuBXHRLg4OOWUiImpgqwEQqt5JGiKB09XO+q"
      ];
      # Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = [
        "wheel"
        "audio"
        "docker"
        "networkmanager"
        "mlocate"
      ];
      packages = [
      ];
    };
  };
}

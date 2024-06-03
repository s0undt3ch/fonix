{ pkgs, ... }:
{
  home.packages = with pkgs; [ pinentry-qt ];

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableZshIntegration = true;
    defaultCacheTtlSsh = 36000;
    maxCacheTtlSsh = 36000;
    pinentryPackage = pkgs.pinentry-qt;
  };

  programs.gpg.enable = true;
}

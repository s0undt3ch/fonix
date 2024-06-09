{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
    };
    histSize = 10000;

    ohMyZsh = {
      enable = true;
      plugins = [ "starship" ];
    };
  };

  environment.systemPackages = with pkgs; [ starship ];
}

{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    # https://nixos.wiki/wiki/Fish#Setting_fish_as_your_shell
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && set LOGIN_OPTION '--login' || set LOGIN_OPTION ""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
    plugins = [
      { name = "grc"; src = pkgs.fishPlugins.grc.src; }
    ];
  };
  home.packages = with pkgs; [
    fishPlugins.grc
  ];
}

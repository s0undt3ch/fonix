{libs, pkgs, ...}:
{
  home = {
    packages = with pkgs; [
      cowsay
    ];

    username = "vampas";
    homeDirectory = "/home/vampas";

    # You do not need to change this if you're reading this in the future.
    # Don't ever change this after the first build.  Don't ask questions.
    stateVersion = "23.11";
  };
}

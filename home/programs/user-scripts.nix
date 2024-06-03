{ pkgs, ... }:
let
  ff-script = pkgs.writeShellScriptBin ".ff" ''
    firefox --profile ~/.mozilla/firefox/FF --new-instance
  '';
  kill-ff-script = pkgs.writeShellScriptBin "kill-ff" ''
    kill -KILL $(ps aux | grep firefox-w | grep -v grep | grep FF | awk '{ print $2 }')
  '';
in
{
  home.packages = [
    ff-script
    kill-ff-script
  ];
}

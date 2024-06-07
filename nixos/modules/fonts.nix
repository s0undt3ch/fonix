{ pkgs, ... }:
{
  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    font-awesome
    (nerdfonts.override {
      fonts = [
        "JetBrainsMono"
        "CascadiaMono"
        "EnvyCodeR"
        "FiraMono"
        "Hack"
        "ProFont"
        "SourceCodePro"
      ];
    })
  ];
}

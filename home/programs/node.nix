{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nodejs
    typescript
    postman
  ];
}

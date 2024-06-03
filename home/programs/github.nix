{ ... }:
{
  programs.gh = {
    enable = true;
    settings = {
      editor = "vim";
      git_protocol = "ssh";
    };
    gitCredentialHelper = {
      enable = true;
    };
  };
}

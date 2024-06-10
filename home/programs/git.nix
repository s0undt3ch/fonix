{ pkgs, ... }:
{
  home.packages = with pkgs; [
    git-doc
    gitg
  ];
  programs.git = {
    enable = true;
    userName = "Pedro Algarvio";
    userEmail = "pedro@algarvio.me";
    signing = {
      key = "84A298FF";
      signByDefault = true;
    };
    ignores = [
      ".config*/"
      ".project"
      ".pydevproject"
      ".settings/"
      ".ropeproject/"
      "*.pyc"
      "*.pyo"
      "*.egg-info/"
      # Vim Swap Files
      ".*.sw*"
    ];
    aliases = {
      l = "log --oneline --decorate";
      ll = "log --stat --decorate --abbrev-commit --date=relative";
      lll = "log -p --stat --decorate --abbrev-commit --date=relative";
      sbranch = ''
        for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'
      '';
    };
    extraConfig = {
      color.ui = true;
      github.user = "s0undt3ch";
      grep = {
        linenumber = true;
      };
      init = {
        defaultBranch = "main";
      };
    };
    difftastic.enable = true;
  };

  programs.gitui = {
    enable = true;
    catppuccin = {
      enable = true;
      flavor = "mocha";
    };
  };
}

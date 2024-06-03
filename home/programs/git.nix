{ ... }:
{
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
      #core = {
      #  pager = "cat";
      #  diff = "less -FX";
      #};
      grep = {
        linenumber = true;
      };
      init = {
        defaultBranch = "main";
      };
    };
  };

  programs.gitui.enable = true;
}

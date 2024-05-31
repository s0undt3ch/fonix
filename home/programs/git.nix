{...}: {
  programs.git = {
    enable = true;
    userName = "Pedro Algarvio";
    userEmail = "pedro@algarvio.me";
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
    extraConfig = {
      init = {defaultBranch = "main";};
    };
  };
}

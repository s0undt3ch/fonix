{pkgs, ...}: {
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
      plugins = [
        "starship"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    starship
  ];

  programs.starship = {
    enable = true;
    #    settings = {
    #      add_newline = true;
    #      character.success_symbol = "[➜](bold green)";
    #      package.disabled = true;
    #      nix_shell = {
    #        format = "[$symbol]($style)";
    #      };
    #      rust = { };
    #      golang = { format = "[$symbol($version )]($style)"; };
    #      format = "$username$directory$git_branch$golang$rust$nix_shell$character";
    #    };
    presets = [
      "gruvbox-rainbow"
    ];
  };
}

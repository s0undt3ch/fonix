{ pkgs, ... }:
{

  programs.nushell = {
    enable = true;
    shellAliases = {
      k = "kubectl";
    };
    envFile = {
      text = /* nu */''
        $env.PATH = ($env.PATH | split row (char esep) | append '$env.HOME/.nix-profile/bin')
        $env.PATH = ($env.PATH | split row (char esep) | append '/etc/profiles/per-user/$env.USER/bin')
        $env.PATH = ($env.PATH | split row (char esep) | append '/run/current-system/sw/bin')
        $env.PATH = ($env.PATH | split row (char esep) | append '/nix/var/nix/profiles/default/bin')
        let carapace_completer = {|spans|
          carapace $spans.0 nushell $spans | from json
        }
        $env.config = {
          show_banner: false,
          completions: {
            case_sensitive: false # case-sensitive completions
            quick: true    # set to false to prevent auto-selecting completions
            partial: true    # set to false to prevent partial filling of the prompt
            algorithm: "fuzzy"    # prefix or fuzzy
            external: {
              # set to false to prevent nushell looking into $env.PATH to find more suggestions
              enable: true
              # set to lower can improve completion performance at the cost of omitting some options
              max_results: 100
              completer: $carapace_completer # check 'carapace_completer'
            }
          },
          #cursor_shape: {
          #  emacs: inherit # block, underscore, line (line is the default)
          #  vi_insert: inherit # block, underscore, line (block is the default)
          #  vi_normal: inherit # block, underscore, line  (underscore is the default)
          #}
        };
        def dockill [] {
          docker ps -aq | str trim |  split row "\n" | each { |it| docker rm -f $it }
        }
        $env.NIXPKGS_ALLOW_UNFREE = 1
      '';
    };
    loginFile = {
      text = /* nu */''
        $env.EDITOR = "nvim"
        $env.NIX_PATH = "nixpkgs=flake:nixpkgs"
        if $env.XDG_VTNR? == "1" and (which sway | length) > 0 {
            sway
        }
      '';
    };
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = false;
    enableNushellIntegration = true;
    settings = {
      add_newline = true;
      character.success_symbol = "[➜](bold green)";
      package.disabled = true;
      nix_shell = {
        format = "[$symbol]($style)";
      };
      rust = { };
      golang = { format = "[$symbol($version )]($style)"; };
      format = "$username$directory$git_branch$golang$rust$nix_shell$character";
    };
  };
}

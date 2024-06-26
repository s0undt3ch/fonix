{ pkgs, ... }:
let
  tmux-shared-windows = pkgs.writeShellScriptBin "tmux-shared-windows" ''
    tmux start-server 2> /dev/null
    sleep 1
    tmux has-session -t $(whoami) && tmux new-session -t $(whoami) -s "$(whoami)-$(tmux list-sessions | wc -l)" || tmux new-session -s $(whoami) -d 2> /dev/null
    tmux selectp -t 1
    tmux split-window -v -d -l 25%
    tmux attach-session -t $(whoami)
  '';
in
{
  programs.tmux = {
    enable = true;
    # Start numbering windows and panes at 1 not 0
    baseIndex = 1;
    escapeTime = 0;
    aggressiveResize = true;
    clock24 = true;
    historyLimit = 150000;
    keyMode = "vi";
    # Bind the CTRL-A key instead of CTRL-B
    #  unbind C-b
    #  set -g prefix C-a
    #  bind a send-prefix
    #
    # prefix = "C-a";
    shortcut = "a";

    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
      # tmuxPlugins.sensible
      tmuxPlugins.copycat
      tmuxPlugins.resurrect
    ];

    extraConfig = ''
      # Automatically set window title
      set-window-option -g automatic-rename on
      set-option -g set-titles on

      # CTRL-A + t - start a new window with a split pane
      unbind t
      bind t new-window\; split-window -v -d -l 30%

      # CTRL-A + k - clear scroll history
      bind -n C-k clear-history

      #   Reload config
      bind-key r source-file ~/.tmux.conf \; display-message "Config reloaded!"

      # Set default terminal
      # set -g default-terminal "screen-256color"
      set -g terminal-overrides ',xterm-256color:Tc'
      set -g default-terminal "tmux-256color"
      set -as terminal-overrides ',xterm*:sitm=\E[3m'

      # Undercurl
      set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
      set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colours - needs tmux-3.0

      # Pass XTerm keys
      set-option -g xterm-keys on

      # Bell
      # Set action on window bell. any means a bell in any window linked to a
      # session causes a bell in the current window of that session, none means
      # all bells are ignored and current means only bell in windows other than
      # the current window are ignored.
      set-option -g bell-action any
      # If on, ring the terminal bell when an activity, content or silence alert occurs.
      #set-option -g bell-on-alert on

      # SHIFT LEFT/RIGHT for Previous/Next Window
      bind -n S-Left previous-window
      bind -n S-Right next-window

      # Restore Vim and NeoVim Sessions with tmux-resurrect
      set -g @resurrect-strategy-vim 'session'
      set -g @resurrect-strategy-nvim 'session'

      # Tmux Plugin Manager
      #set -g @plugin 'tmux-plugins/tmux-sensible'
      #set -g @plugin 'tmux-plugins/tmux-copycat'
      #set -g @plugin 'tmux-plugins/tmux-resurrect'
      #set -g @plugin 'seebi/tmux-colors-solarized'
      #set -g @colors-solarized '256'

      #set -g @plugin 'egel/tmux-gruvbox'
      #set -g @tmux-gruvbox 'dark' # or 'light'

      # Install TPM if not installed already
      if "test ! -d ~/.tmux/plugins/tpm" \
        "run 'git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm'"

      # Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
      run -b '~/.tmux/plugins/tpm/tpm'
    '';

    catppuccin = {
      enable = true;
      flavor = "mocha";
    };
  };

  home.packages = [ tmux-shared-windows ];
}

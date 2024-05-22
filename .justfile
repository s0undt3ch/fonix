update username="vampas":
  cd $(dirname {{justfile()}})
  home-manager switch --flake .#{{username}}

update-system hostname="fonix":
  #!/usr/bin/env sh
  cd $(dirname {{justfile()}})
  if [ $(id -u) -eq 0 ]; then
    nixos-rebuild --flake .#{{hostname}} switch
  else
    sudo nixos-rebuild --flake .#{{hostname}} switch
  fi

clean:
  nix-collect-garbage -d

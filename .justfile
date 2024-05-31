update username=`id -un` hostname=`hostname`:
  #!/usr/bin/env sh
  cd {{justfile_directory()}}
  home-manager switch --flake .#{{username}}@{{hostname}}

update-system hostname=`hostname`:
  #!/usr/bin/env sh
  cd {{justfile_directory()}}
  if [ $(id -u) -eq 0 ]; then
    nixos-rebuild --flake .#{{hostname}} switch
  else
    sudo nixos-rebuild --flake .#{{hostname}} switch
  fi

clean:
  nix-collect-garbage -d

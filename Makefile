mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))

# Careful about copy/pasting, Makefiles want tabs!
.PHONY: update
update:
	username?=vampas
	home-manager switch --flake "$(current_dir)#$(username)"

update-system:
	hostname?=fonix
	nixos-rebuild --flake "$(current_dir)#$(hostname)"

.PHONY: clean
clean:
	nix-collect-garbage -d

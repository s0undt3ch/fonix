# Careful about copy/pasting, Makefiles want tabs!
.PHONY: update
update:
    home-manager switch --flake ~/.fonix#vampas

.PHONY: clean
clean:
    nix-collect-garbage -d

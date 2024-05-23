{
  description = "My NixOS & Home Manager configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-24.05";
    nixos.url = "github:nixos/nixpkgs/release-24.05";

    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/master";
    };

    neovim-nightly-overlay = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.neovim-flake.url = "github:neovim/neovim?dir=contrib&rev=8744ee8783a8597f9fce4a573ae05aca2f412120";
    };

    agenix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:ryantm/agenix";
    };

    impermanence = {
      url = "github:nix-community/impermanence/master";
    };

    disko = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/disko/master";
    };

    #secrets = {
    #  inputs.nixpkgs.follows = "nixpkgs";
    #  url = "git+ssh://git@github.com/s0undt3ch/agenix-secrets.git?ref=main";
    #};
  };

  outputs = { self, nixpkgs, nixos, home-manager, agenix, impermanence, disko, ... } @ inputs:
    let
      overlays = [
        inputs.neovim-nightly-overlay.overlays.default
        # (import ./overlays/weechat.nix)
      ];

      config = {
        allowUnfree = true;
        permittedInsecurePackages = [
        ];
      };

      nixosPackages = import nixos {
        system = "x86_64-linux";
        inherit config overlays;
      };

      x86Pkgs = import nixpkgs {
        system = "x86_64-linux";
        inherit config overlays;
      };

    in
    {
      homeConfigurations = {
        "vampas@fonix" = home-manager.lib.homeManagerConfiguration {
          pkgs = x86Pkgs;
          modules = [
            ./home/users/vampas/fonix.nix
          ];
        };
      };

      nixosConfigurations = {
        fonix = nixos.lib.nixosSystem {
          system = "x86_64-linux";
          pkgs = nixosPackages;
          modules =
            [
              ./nixos/fonix-vm.nix
              disko.nixosModules.disko
              impermanence.nixosModule
              agenix.nixosModules.default
              {
                nix.nixPath = [ "nixpkgs=flake:nixpkgs" ];
              }
              #secrets.nixosModules.desktop or { }
              home-manager.nixosModules.home-manager
              {
                home-manager.extraSpecialArgs = {
                  pkgs = x86Pkgs;
                };
                home-manager.users.vampas = import ./home/users/vampas/fonix.nix;
              }
            ];
        };

        devShell.x86_64-linux = x86Pkgs.mkShell {
          nativeBuildInputs = [ x86Pkgs.bashInteractive ];
          buildInputs = with x86Pkgs; [
            nil
            nixpkgs-fmt
          ];
        };
      };
    };
}

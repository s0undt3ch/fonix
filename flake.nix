{
  description = "My NixOS & Home Manager configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos.url = "github:nixos/nixpkgs/release-24.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    spicetify-nix.url = "github:the-argus/spicetify-nix";
    catppuccin.url = "github:catppuccin/nix";

    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/release-24.05";
    };

    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.neovim-src.url = "github:neovim/neovim?dir=contrib&branch=release-0.10";
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

    # NVim plugins from GitHub which are not yet packaged
    venv-selector-nvim = {
      url = "github:linux-cultist/venv-selector.nvim/regexp";
      flake = false;
    };
    ansible-nvim = {
      url = "github:mfussenegger/nvim-ansible";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      nixos,
      nixos-hardware,
      home-manager,
      plasma-manager,
      agenix,
      impermanence,
      disko,
      spicetify-nix,
      catppuccin,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      # Supported systems for your flake packages, shell, etc.
      systems = [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      # This is a function that generates an attribute by calling a function you
      # pass to it, with each system as an argument
      forAllSystems = nixpkgs.lib.genAttrs systems;

      system = "x86_64-linux";

      overlays = [
        # inputs.neovim-nightly-overlay.overlays.default
        # (import ./overlays/weechat.nix)
      ];

      config = {
        allowUnfree = true;
        permittedInsecurePackages = [ ];
      };

      nixosPackages = import nixos {
        system = "x86_64-linux";
        inherit config overlays;
      };

      x86Pkgs = import nixpkgs {
        system = "x86_64-linux";
        inherit config overlays;
      };

      pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
    in
    {
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);

      nixosConfigurations = {
        lenny = nixos.lib.nixosSystem {
          inherit system;

          pkgs = nixosPackages;
          modules = [
            nixos-hardware.nixosModules.lenovo-thinkpad-p50
            ./nixos/lenny.nix
            disko.nixosModules.disko
            impermanence.nixosModule
            agenix.nixosModules.default
            { nix.nixPath = [ "nixpkgs=flake:nixpkgs" ]; }
            #secrets.nixosModules.desktop or { }
            catppuccin.nixosModules.catppuccin
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.sharedModules = [
                catppuccin.homeManagerModules.catppuccin
                plasma-manager.homeManagerModules.plasma-manager
              ];
              home-manager.extraSpecialArgs = {
                inherit inputs;
                pkgs = x86Pkgs;
                inherit pkgs-unstable;
              };
              home-manager.users.vampas = import ./home/users/vampas/fonix.nix;
            }
          ];
          specialArgs = {
            inherit pkgs-unstable;
          };
        };

        fonix = nixos.lib.nixosSystem {
          inherit system;

          pkgs = nixosPackages;
          modules = [
            ./nixos/fonix-vm.nix
            disko.nixosModules.disko
            impermanence.nixosModule
            agenix.nixosModules.default
            { nix.nixPath = [ "nixpkgs=flake:nixpkgs" ]; }
            #secrets.nixosModules.desktop or { }
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ];
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

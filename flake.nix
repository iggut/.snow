{
  description = "Hyprland+waybar";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    hyprland.url = "github:hyprwm/Hyprland";

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    alejandra = {
      url = "github:kamadorueda/alejandra/3.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # The Chaotic toolbox
    #src-chaotic-toolbox = {
    #  flake = false;
    #  url = "github:chaotic-aur/toolbox";
    #};
  };

  outputs = {
    alejandra,
    self,
    nixpkgs,
    hyprland,
    home-manager,
    disko,
    nix-index-database,
    chaotic,
    ...
  }: let
    user = "iggut";
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      gaminix = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit user;};
        modules = [
          chaotic.nixosModules.default
          nix-index-database.nixosModules.nix-index
          {
            environment.systemPackages = [alejandra.defaultPackage.${system}];
          }
          disko.nixosModules.disko
          ./hosts/gaminix/disko-config.nix
          {
            _module.args.disks = ["/dev/nvme1n1"];
          }
          ./hosts/gaminix/configuration.nix
          hyprland.nixosModules.default
          {
            programs.hyprland.enable = true;
            programs.hyprland.nvidiaPatches = true;
            programs.hyprland.xwayland.enable = true;
          }
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit user;};
            home-manager.users.iggut = import ./home/home.nix;
          }
        ];
      };
    };

    nixosConfigurations = {
      gs66 = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit user;};
        modules = [
          chaotic.nixosModules.default
          nix-index-database.nixosModules.nix-index
          {
            environment.systemPackages = [alejandra.defaultPackage.${system}];
          }
          disko.nixosModules.disko
          ./hosts/gs66/disko-config.nix
          {
            _module.args.disks = ["/dev/nvme0n1"];
          }
          ./hosts/gs66/configuration.nix
          hyprland.nixosModules.default
          {
            programs.hyprland.enable = true;
            programs.hyprland.nvidiaPatches = true;
            programs.hyprland.xwayland.enable = true;
          }
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit user;};
            home-manager.users.iggut = import ./home/home.nix;
          }
        ];
      };
    };
  };
}
#nixos-23.05


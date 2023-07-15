{
  description = "Hyprland+waybar";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    hyprland.url = "github:hyprwm/Hyprland";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    hyprland,
    home-manager,
    disko,
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
      ${user} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit user;};
        modules = [
          disko.nixosModules.disko
          ./disko-config.nix
          {
            _module.args.disks = ["/dev/nvme1n1"];
          }
          ./configuration.nix
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
            home-manager.users.${user} = import ./modules/home.nix;
          }
        ];
      };
    };
  };
}
#nixos-23.05


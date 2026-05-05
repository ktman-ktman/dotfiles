{
  description = "dk's home-manager flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager }:
  let
    system = "x86_64-linux";
    username = "dk";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { inherit username; };
      modules = [ ./home.nix ];
    };
  };
}
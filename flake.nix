{
  description = "dk's home-manager flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    llm-agents.url = "github:numtide/llm-agents.nix";  # 追加
  };
  outputs = { self, nixpkgs, home-manager, llm-agents }:  # llm-agents追加
  let
    system = "x86_64-linux";
    username = "dk";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { inherit username llm-agents; };  # llm-agents追加
      modules = [ ./home.nix ];
    };
  };
}
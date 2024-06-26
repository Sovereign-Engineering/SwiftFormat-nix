{
  inputs = {
     nixpkgs.url = "nixpkgs/nixos-23.11";
     flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in
      {
        packages.default = pkgs.callPackage ./package.nix { };
      }
    );
}

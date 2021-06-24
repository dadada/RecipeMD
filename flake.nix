{
  description = "recipemd";
  inputs = {
    flake-utils.url = github:numtide/flake-utils;
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
  };
  outputs = { flake-utils, nixpkgs, ... }: (flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      pythonPackages = { callPackage }: {
        recipemd = callPackage nix/default.nix { };
      };
      python3Packages = pythonPackages {
        callPackage = pkgs.python3Packages.callPackage;
      };
    in
    {
      defaultApp = {
        type = "app";
        program = "${python3Packages.recipemd}/bin/recipemd";
      };
      defaultPackage = pkgs.python3Packages.toPythonApplication python3Packages.recipemd;
      pythonPackages = pythonPackages;
    }
  ));
}

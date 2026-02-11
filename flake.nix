{
  description ="nix flake for my personal site, jerromeyong.com";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            zola
          ];

          shellHook = ''
            echo "------------------------------"
            echo "loaded zola env"
            echo "'zola serve' to preview on wsl"
            echo "------------------------------"
          '';
        };

        packages.default = pkgs.stdenv.mkDerivation {
          name = "my-zola-site";
          src = ./.;

          buildInputs = [ pkgs.zola ];

          buildPhase = ''
            zola build
          '';

          # nix store output
          installPhase = ''
            mkdir -p $out
            cp -r public/* $out/
          '';
        };
      }
    );
}

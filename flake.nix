{
  description = "3d-preview-terminal: preview your 3D objects within the terminal";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      # Darwin specifig package.
      darwinPackages = if system == "aarch64-darwin" then [
        pkgs.darwin.apple_sdk.frameworks.AppKit
      ] else [];
    in {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [ 
          rustc
          cargo
          rustfmt
          rust-analyzer
          clippy
          libiconv # https://stackoverflow.com/questions/68679040/error-linking-with-cc-failed-exit-code-1-for-cargo-run
        ] ++ darwinPackages;
      };
      
    });
}

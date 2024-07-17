{
  description = "Wolf's Resume";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    latex-utils.url = "github:404Wolf/nixlatexdocument";
  };

  outputs =
    {
      self,
      nixpkgs,
      latex-utils,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        name = "resume";
        pkgs = import nixpkgs { inherit system; };
        # buildLatexDocument = latex-utils.lib.${system}.buildLatexDocument;
        buildLatexDocument = pkgs.callPackage ./package.nix;
      in
      {
        packages = {
          default = buildLatexDocument {
            inherit name;
            src = self;
            document = "src/resume.tex";
            lastModified = self.lastModified;
            texPkgs = {
              inherit (pkgs.texlive) etoolbox;
            };
          };
        };
        devShells = { };
      }
    );
}

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
      flake-utils,
      latex-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        name = "resume";
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages = {
          default = latex-utils.lib.${system}.buildLatexDocument {
            inherit name;
            src = ./.;
            document = "resume.tex";
            lastModified = self.lastModified;
            texpkgs = {
              inherit (pkgs.texlive)
                etoolbox
                hvfloat
                marvosym
                enumitem
                amsmath
                spverbatim
                fancyhdr
                soulpos
                preprint
                ;
            };
          };
        };
        devShells.default = latex-utils.devShells.${system}.default;
      }
    );
}

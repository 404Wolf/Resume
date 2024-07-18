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
        buildLatexDocument = pkgs.callPackage ./package.nix;
      in
      {
        packages = rec {
          default = buildLatexDocument {
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
          develop = pkgs.writeShellScriptBin "develop" ''
            function build {
              nix build --out-link tmp
              cp tmp/share/resume.pdf resume.pdf
              rm -r tmp
            }
            export -f build
            ENTR=${pkgs.entr}/bin/entr
            find . -type f -name '*.tex' | $ENTR sh -c build
          '';
        };
      }
    );
}

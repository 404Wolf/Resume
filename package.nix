{
  pkgs,
  src,
  name,
  document ? "document.tex",
  texlive ? pkgs.texlive,
  texpkgs ? { },
  lastModified ? 0,
  ...
}:
let
  tex = texlive.combine ({ inherit (pkgs.texlive) scheme-basic latex-bin latexmk; } // texpkgs);
in
pkgs.stdenvNoCC.mkDerivation {
  inherit name src;
  dontUnpack = true;
  buildPhase = ''
    mkdir -p .cache/texmf-var
    export TEXMFHOME=.cache TEXMFVAR=.cache/texmf-var
    export SOURCE_DATE_EPOCH=${toString lastModified} # Ensure date is pure
    ${tex}/bin/latexmk \
      -pretex='\pdfvariable suppressoptionalinfo 512\relax' \
      -interaction=nonstopmode \
      -usepretex \
      -jobname=${name} \
      -pdflua \
      ${document}
  '';
  installPhase = ''
    mkdir -p $out
    cp document.pdf $out/${name}.pdf
  '';
}

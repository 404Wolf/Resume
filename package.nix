{
  pkgs,
  src,
  name,
  suppressErrors ? true,
  document ? "document.tex",
  texlive ? pkgs.texlive,
  texpkgs ? { },
  lastModified ? 0,
}:
let
  tex = texlive.combine ({ inherit (pkgs.texlive) scheme-basic latex-bin latexmk; } // texpkgs);
in
pkgs.stdenvNoCC.mkDerivation {
  inherit name src;
  phases = [
    "unpackPhase"
    "buildPhase"
    "installPhase"
  ];
  buildPhase = ''
    mkdir -p .cache/texmf-var
    export TEXINPUTS=$TEXINPUTS:$(pwd)/stys:
    export TEXMFHOME=.cache TEXMFVAR=.cache/texmf-var
    export SOURCE_DATE_EPOCH=${toString lastModified} # Ensure date is pure
    ${tex}/bin/latexmk \
      -pretex='\pdfvariable suppressoptionalinfo 512\relax' \
      -interaction=nonstopmode \
      -usepretex \
      -jobname=${name} \
      -pdflua \
      -cd "src/${document}" ${if suppressErrors then "|| true" else ""}
  '';
  installPhase = ''
    mkdir -p $out/share
    mkdir -p $out/logs
    cp src/*.pdf $out/share
    cp src/* $out/logs
  '';
}

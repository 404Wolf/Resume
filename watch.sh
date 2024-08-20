evince resume.pdf > /dev/null & disown
while true; do
    find . -name '*.tex' | entr -d bash -c 'nix build && cp --no-preserve=mode ./result/share/resume.pdf ./resume.pdf'
    sleep 1
done


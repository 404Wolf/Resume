# Resume
My current resume

My current resume, which is a greatly customized template based off of [Jake's Template](https://github.com/jakegut/resume) and [sb2nov's Template](https://github.com/sb2nov/resume/), built with `nix`, incorporating [a pure flake latex build](https://flyx.org/nix-flakes-latex/) through a [nix-latex utility I wrote](https://github.com/404Wolf/nixLatexDocument).

To build the resume, run `nix build github:404wolf/resume`, and the resume will live in `./result/share/resume.pdf`.

There is an automated workflow that runs as a GitHub action, such that when I push my resume it automatically updates the resume [on my website](https://404wolf.com/resume).

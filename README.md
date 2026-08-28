# LaTeX Resume

A component-based LaTeX resume built with LuaLaTeX. Each section of the resume
(education, experience, projects, skills, awards) lives in its own `.tex` file
under `components/`, and a main file under `resume/` pulls together whichever
components it needs. This makes it easy to maintain multiple tailored versions
of the resume from a single source of truth.

## Requirements

- A LaTeX distribution with LuaLaTeX. On Arch Linux:

  ```
  sudo pacman -S texlive-basic texlive-bin texlive-latex texlive-latexrecommended texlive-fontsrecommended texlive-fontsextra texlive-luatex
  ```

  The `emoji` package also needs the `TwemojiMozilla` font (`ttf-mozilla-twemoji` on some distros).

## Build

`make` compiles the resume (installing any missing TeX Live packages on Arch
first) and produces `resume/Koushik_Sahu_Resume.pdf`:

```
make build
```

`make run` additionally opens the generated PDF with the default viewer.

`make clean` removes build artifacts (`aux`, `log`, `out` files).

## Structure

- `resume/` — main `.tex` files; each compiles to a full resume.
- `components/` — reusable sections: `background`, `skills`, `links`, and
  subfolders for education, experience, projects, publications, and awards.

To add a new version of the resume, create a main file in `resume/` that
imports the components you want and run `make` on it.
# Modular LaTeX Resume

A component-based LaTeX resume built with LuaLaTeX. Each section of the resume
(education, experience, projects, skills, awards) lives in its own `.tex` file
under `components/`, and a main file under `resume/` pulls together whichever
components it needs. This makes it easy to maintain multiple tailored versions
of the resume from a single source of truth.

## Requirements

- A LaTeX distribution with LuaLaTeX, plus the TeX packages and fonts used by
  the project. If anything is missing, `make build` fails with an error
  identifying it — install it using your platform's package manager.

## Build

`make build` compiles the resume, producing `resume/Koushik_Sahu_Resume.pdf`:

```
make build
```

`make run` additionally opens the generated PDF with the default viewer.

`make clean` removes build artifacts (`aux`, `log`, `out` files).

## Releases

Every git tag triggers a GitHub Actions workflow (`.github/workflows/release.yml`)
that builds the PDF on a clean runner and publishes it to
[GitHub Releases](../../releases):

```
git tag <major_version>.<minor_version> && git push origin <major_version>.<minor_version>
```

Tags follow the `v<major_version>.<minor_version>` convention, e.g. `v1.0`.

The release asset is named `Koushik_Sahu_Resume_<tag>.pdf`.

## Structure

- `resume/` — main `.tex` files; each compiles to a full resume.
- `components/` — reusable sections: `background`, `Skills/programmingskills`,
  `Links/competitiveprogramminglinks`, and subfolders for education, experience,
  projects, publications, and awards.

To add a new version of the resume, create a main file in `resume/` that
imports the components you want and run `make` on it.
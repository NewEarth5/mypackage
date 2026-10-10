# mypackage / myreport

`mypackage.sty` is a LaTeX package for reports (numbered figures, tables,
programs and equations with automatic labels, typed cross-references,
localised words). `myreport.cls` is a report class built on it (title
pages, adaptive sectioning, annexes, table of contents and lists,
bibliography by category).

Current version: **0.6.5** (2026-10-10). See [CHANGELOG.md](CHANGELOG.md)
and the roadmap in [TODO.txt](TODO.txt).

## Requirements

- LaTeX 2022-06-01 or newer (TeX Live 2023 is used for the reference test
  results).
- Compile with `-shell-escape` (minted, and the svg package when `.svg`
  images are used), with Pygments (`pygmentize`, or `latexminted` from
  TeX Live 2024 on) and Inkscape for `.svg` images.
- biber for the bibliography.

```
pdflatex -shell-escape report
biber report
pdflatex -shell-escape report
pdflatex -shell-escape report
```

## Using it

Copy `mypackage.sty` and `myreport.cls` next to your document, or install
them once for all documents with `l3build install` (copies them into your
personal TEXMF tree). Then:

```latex
\documentclass[text={lang=french}]{myreport}
```

Every command has a demo in `demo/` (`l3build doc` typesets them into
`build/doc/`), and `documentation.txt` describes the interface.

## Repository layout

| Path | Content |
|---|---|
| `mypackage.sty`, `myreport.cls` | the sources |
| `*.cwl` | TeXstudio completion files |
| `build.lua`, `config-*.lua` | l3build configuration (tests, demos) |
| `testfiles*/` | tests: `.lvt` = test input, `.tlg` = expected log |
| `support/` | files copied next to every test (images, code, bibliography, helper macros) |
| `demo/` | one demo document per command (`mydemo.sty` formats them) |
| `perf/` | compile-time / number-of-runs benchmark |
| `scripts/save-all.sh` | regenerate all expected logs of a configuration |
| `.github/workflows/` | continuous integration |

## Testing

See [DEVELOPMENT.md](DEVELOPMENT.md) for how l3build works. In short:

```
l3build check                  # all 106 tests (about 15 minutes)
l3build check -c build         # only the quick single-run tests
l3build check cls-annex-long   # one test
l3build doc                    # build the demos
python3 perf/perf.py .         # benchmark (needs perf/report.tex)
```

### Updating TeX Live

The expected logs (`.tlg`) contain messages from other packages, which
change between TeX Live releases. After installing a new TeX Live, run

```
scripts/save-all.sh build
scripts/save-all.sh config-multirun
scripts/save-all.sh config-bib
scripts/save-all.sh config-compat
scripts/save-all.sh config-engines
scripts/save-all.sh config-engines -e xetex
git diff --stat testfiles*/
```

read the differences (they should only be messages of other packages),
commit them, and set `texlive_version` in `.github/workflows/*.yml` to the
same year.

## Licence

Not chosen yet (planned for 1.0: the LaTeX Project Public License is the
usual choice on CTAN).

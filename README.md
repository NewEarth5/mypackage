# mypackage / myreport

`mypackage.sty` is a LaTeX package for reports (numbered figures, tables,
programs and equations with automatic labels, typed cross-references,
localised words). `myreport.cls` is a report class built on it (title
pages, adaptive sectioning, annexes, table of contents and lists,
bibliography by category).

Current version: **0.6.5** (2026-10-10). See [CHANGELOG.md](CHANGELOG.md)
and the roadmap in [TODO.txt](TODO.txt).

## Requirements

- LaTeX 2022-06-01 or newer, with TeX Live or MiKTeX. The reference test
  results are generated with the latest TeX Live (see "Testing").
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
| `l3build-normalise.lua` | makes the test logs independent of TeX Live/MiKTeX, the OS and minted's version |
| `.github/workflows/` | continuous integration |

## Testing

See [DEVELOPMENT.md](DEVELOPMENT.md) for how l3build works. In short:

```
l3build check                  # all 106 tests (about 6 minutes)
l3build check -c build         # only the quick single-run tests
l3build check -c config-multirun cls-annex-long   # one test (give its configuration)
l3build saveall                # regenerate every expected result
l3build doc                    # build the demos
python3 perf/perf.py .         # benchmark (needs perf/report.tex)
```

### Where the reference results come from

The expected logs (`.tlg`) contain messages of other packages, which change
from one TeX Live release to the next. There is therefore one reference:
**the latest TeX Live, on GitHub Actions**. When the tests fail there for a
reason that is not a bug (a package update), run the *Save expected
results* workflow (Actions tab → Run workflow): it regenerates every `.tlg`
and opens a pull request; read its diff and merge it.

Locally, `l3build saveall` does the same on your machine (all
configurations, or `-c <config>` for one). With MiKTeX, local results can
still differ slightly from the TeX Live reference when a package version
differs; see DEVELOPMENT.md, "Windows and MiKTeX".

## Licence

Not chosen yet (planned for 1.0: the LaTeX Project Public License is the
usual choice on CTAN).

# Development guide

This file explains how the test suite works (l3build), how to add a test,
and how the GitHub repository is organised.

## 1. What l3build is

l3build is the build and test tool written by the LaTeX Project for the
LaTeX kernel itself, and used by most packages on CTAN. It is a Lua script
(`l3build`, run by `texlua`) shipped with TeX Live. It does four jobs:

| Command | Job |
|---|---|
| `l3build check` | run the regression tests |
| `l3build doc` | typeset the documentation (here: the demos) |
| `l3build install` | copy the package into your personal TEXMF tree |
| `l3build ctan` | build the zip file to upload to CTAN (for 1.0) |

Its settings are Lua variables in `build.lua`, at the root of the
repository. Every variable has a default; `build.lua` only sets the ones
that differ.

## 2. How a regression test works

A test is a small LaTeX document, `testfiles/<name>.lvt`, that writes
*text into its log file*. The expected log is stored next to it in
`<name>.tlg` ("test log"). `l3build check` compiles every `.lvt` and
compares its log with the `.tlg`:

```
             .lvt ──pdflatex──► .log ──normalise──► compare with .tlg
                                                       │
                                     same: PASS ◄──────┴──► different: FAIL + .diff
```

Only what is between `\START` and the end of the document is compared,
and l3build *normalises* the log first: file paths, line numbers (`l. ...`),
dates and other details that change from one machine to another are
removed, so the comparison is about behaviour only.

A minimal test:

```latex
\input{regression-test}      % l3build's macros: \START, \TEST, \TYPE ...
\documentclass{myreport}
\input{mytest-helpers}       % our helpers (support/mytest-helpers.tex)
\begin{document}
\START                       % comparison starts here
\TEST{Numbering of chapters}{%
  \mychapter{One}
  \TYPE{\themychapter}       % writes "1" to the log
}
\end{document}
```

Its `.tlg` then contains:

```
============================================================
TEST 1: Numbering of chapters
============================================================
1
============================================================
```

The macros of `regression-test.tex`:

| Macro | Effect |
|---|---|
| `\START` | starts the part of the log that is compared |
| `\TEST{title}{code}` | runs `code` in a group between two separator lines |
| `\TYPE{text}` | writes the (expanded) text to the log |
| `\SEPARATOR` | a line of `=` |
| `\SHOWFILE{file}` | writes the content of a file to the log |
| `\showbox`, `\showoutput` | TeX primitives: write a box / every page in full (fonts, glue, positions) |

Our helpers (`support/mytest-helpers.tex`) add one-line summaries:
`\SHOWREF{label}` (number, page and anchor of a label), `\SHOWCOUNTERS`,
`\SHOWTHE`, `\SHOWFLAGS`, `\SHOWNAMES` (localised words), `\SHOWOPT\macro`
(value of an option), `\SHOWLIST{ext}` (content of a TOC/LoF... file),
`\SHOWTEXT{text}` (the typeset box).

Errors are part of the log too: a test that suddenly raises
`! Undefined control sequence` fails, even if nothing else changed.

### Where do the .tlg files come from?

From a run you have checked: `l3build save <name>` compiles the test and
*stores* its log as the `.tlg`. The workflow is therefore:

1. write the `.lvt`;
2. `l3build save -c <config> <name>`;
3. **read the .tlg** and check that every value is right (this is the
   moment where bugs are found: the first .tlg files of 0.6.5 revealed
   the bugs listed in the changelog);
4. commit both files.

From then on, `l3build check` fails as soon as the behaviour changes. If
the change is intended, run `l3build save` again and commit the new
`.tlg` together with the code change: the `.tlg` diff in the commit shows
exactly what changed for users.

### Several runs

Some behaviour only appears after several LaTeX runs (the .aux file, the
TOC, references). `checkruns = 3` in `config-multirun.lua` runs each test
three times and compares the log of the last run. `config-bib.lua` also
defines `runtest_tasks`, a Lua function called after each run: it returns
`biber <name>` after the first run.

### Configurations

`checkconfigs` in `build.lua` lists the configurations run by a bare
`l3build check`. Each `config-x.lua` is read *after* `build.lua` and
overrides a few variables (test folder, number of runs, engines):

| Configuration | Folder | Runs | Content |
|---|---|---|---|
| `build` | `testfiles/` | 1 | options, words, fonts, macros |
| `config-multirun` | `testfiles-multirun/` | 3 | structure, TOC, floats, references, title pages |
| `config-bib` | `testfiles-bib/` | 3 + biber | bibliography |
| `config-compat` | `testfiles-compat/` | 2 | other packages loaded with ours |
| `config-engines` | `testfiles-engines/` | 2 | LuaLaTeX and XeLaTeX (one `.tlg` per engine: `name.tlg` for LuaTeX, `name.xetex.tlg`) |

### Everyday commands

```
l3build check                        all configurations
l3build check -c build               one configuration
l3build check -c config-multirun pkg-figure     one test
l3build check -H --show-log-on-error stop at the first failure, show its log
l3build check -S                     print the "save" command for each failure
l3build save -c config-multirun pkg-figure      accept the new result
l3build saveall -c config-multirun  save every test of a configuration
l3build saveall                      save every test of every configuration
l3build clean                        delete build/
```

When a test fails, `build/test-<config>/<name>.<engine>.diff` shows the
difference (lines starting with `-` are expected, `+` obtained), and the
full log is `build/test-<config>/<name>.log`.

### Normalisation

Before comparing, l3build *normalises* the log: it removes what changes from
one computer to another (file paths, line numbers, dates). Our
`l3build-normalise.lua` (loaded by `build.lua`) adds three rules:

- with MiKTeX, the engines are asked not to wrap the log (see below);
- Windows paths (`C:\...\umsa.fd`) are converted to `/` so that l3build
  recognises them;
- lines written by external programs (`runsystem(...)`: minted, Inkscape),
  minted's cache files, register allocations and every *information*
  message (`Package x Info: ...`, `LaTeX Font Info: ...`) are removed: they
  depend on the OS and on package versions, not on our code. Warnings and
  errors are kept;
- details that differ between engine versions are normalised: the
  character code in `Missing character` messages, the source text after
  `l.<n>`, version numbers on dated lines, the last decimals of
  `glue set`.

What remains can still differ when *your* TeX installation has another
version of a package than the reference: a package may change the layout
(e.g. a page break moves) or its words (babel-portuges now calls the
table of contents "Índice"). Those differences are real, but they are not
bugs of ours: the reference is updated with the "Save expected results"
workflow (see section 6).

### Fixed date

`epoch` in `build.lua` sets the date seen by TeX (`\today`, `\year`,
`\currentacyear`) to 2026-10-10, so that the logs do not change every day.

### Windows and MiKTeX

l3build was written for TeX Live; two things differ with MiKTeX:

1. **Line wrapping.** l3build asks the engine not to wrap the log through
   the environment variable `max_print_line`. TeX Live reads it, MiKTeX
   does not: its logs are wrapped at 79 characters, l3build cannot rejoin
   the lines, and its normalisation (line numbers, paths) fails, so almost
   every test fails. `l3build-normalise.lua` detects MiKTeX and passes
   `--max-print-line=9999` to pdfTeX and XeTeX instead. MiKTeX's LuaTeX has
   no such option; its lines (79 bytes, or a little less before a
   multi-byte character) are rejoined before comparing.
2. **Differences.** On Windows l3build compares with `fc` and writes `.fc`
   files. If Git is installed, `l3build-normalise.lua` uses
   `git diff --no-index` instead and writes `.diff` files (lines starting
   with `-` are expected, `+` obtained). Set the environment variables
   `diffexe` and `diffext` to choose another program.

Even then, MiKTeX and TeX Live do not always ship the same version of
every package, and a package that changes its log messages makes a test
differ. Such differences are not bugs. Options, from most to least
convenient:

- **Let GitHub Actions decide** (the reference): push, look at the result.
- **Install TeX Live on Windows** (https://tug.org/texlive/windows.html,
  or `winget install TeXLive.TeXLive`) next to MiKTeX. Make it first in
  `PATH` in the terminal where you run l3build, or for everything (LaTeX
  Workshop works the same with both). Update it with `tlmgr update --all`.
- **Use WSL** (Ubuntu on Windows) with TeX Live installed there, and run
  l3build from the WSL terminal (VS Code's "WSL" extension opens the folder
  there).

## 3. Adding a test

1. Choose the configuration (one run is enough? → `testfiles/`; needs the
   .aux/TOC? → `testfiles-multirun/`).
2. Copy a similar `.lvt`, keep the comment at the top describing *what* is
   tested and *why*.
3. Print values, not pages, when you can (`\SHOWREF`, `\TYPE`): such logs
   are short and survive TeX Live updates. Use `\showoutput` only for
   layout tests.
4. `l3build save`, read the `.tlg`, commit.

When you fix a bug, first write the test that shows it, save it (the .tlg
records the bug), fix the code, save again: the .tlg diff documents the
fix.

## 4. Demos

`l3build doc` typesets every `demo/demo-*.tex` into `build/doc/` (three
runs, biber when needed). The `demo` environment of `demo/mydemo.sty`
prints its content as code and then executes it, so the code shown is
always the code that produced the result.

## 5. Benchmark

`perf/perf.py <folder with the .sty/.cls>` copies `perf/report.tex` (not in
the repository: put a copy of your report there) into a clean folder,
creates placeholder images and a bibliography, and compiles until every
auxiliary file is stable. It reports the number of LaTeX and biber runs,
the time of the first (cold) and of a warm run, errors and warnings.

## 6. GitHub

### Creating the repository

```
cd mypackage                         # this folder (it is already a git repository)
git remote add origin git@github.com:<you>/mypackage.git
git push -u origin main --tags
```

### Continuous integration

`.github/workflows/tests.yml` runs every configuration of the test suite
in the latest full TeX Live on GitHub's servers, on every push and every
pull request. The result appears as a green tick or a red cross next to the
commit; on failure, the `.diff` files can be downloaded from the run's
summary page ("Artifacts").

`.github/workflows/save.yml` ("Save expected results", started by hand
from the Actions tab) regenerates every `.tlg` in the same TeX Live and
opens a pull request with the changes. Use it after a TeX Live update, and
whenever tests were added or changed. It needs Settings → Actions →
General → "Allow GitHub Actions to create and approve pull requests".

`.github/workflows/release.yml` runs when you push a tag `v...`: it builds
the demos and creates a GitHub release with the `.sty`, `.cls`, `.cwl`,
the changelog and a zip of the demo PDFs.

### Suggested workflow

- `main` always passes the tests. Work on a branch per roadmap item
  (`git switch -c v0.7.0-refactoring`), push it, open a pull request: the
  tests run on it, and you merge only when they pass.
- Protect `main` (Settings → Branches → Add rule → "Require status checks
  to pass before merging", select the `l3build check` jobs).
- One commit per logical change, with the code, its tests and the
  `.tlg` changes together; mention the change under "Unreleased" in
  `CHANGELOG.md`.
- To release: move "Unreleased" to a version heading, update the version
  in both files (`\ProvidesPackage`, `\ProvidesClass`), commit, then
  `git tag -a v0.7.0 -m "Version 0.7.0"` and `git push --tags`.
- Use GitHub Issues for the "Known issues" of the changelog and a
  milestone per version (0.7.0, 0.7.5, ...) to follow the roadmap.

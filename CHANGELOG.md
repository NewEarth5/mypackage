# Changelog

All notable changes to `mypackage.sty` and `myreport.cls` are recorded here.
The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/);
versions follow the roadmap in `TODO.txt`. Both files always carry the same
version number.

Sections: **Added** (new features), **Changed** (different behaviour on
purpose), **Fixed** (bugs), **Removed**, **Known issues** (found, not fixed
yet, with the version that should address them).

## [Unreleased]

### Repository

- `l3build-normalise.lua`: test logs independent of the TeX distribution,
  the OS and external programs. With MiKTeX, `--max-print-line=9999` is
  passed to pdfTeX/XeTeX (MiKTeX ignores the `max_print_line` variable set
  by l3build, so its logs were wrapped at 79 characters and almost every
  test failed); Windows paths are normalised; `runsystem(...)` lines,
  minted cache files, register allocations and `LaTeX Font Info` messages
  are removed (they differ between minted 2 and 3, Windows and Linux, and
  even between a first and a second run of minted).
- On Windows, differences are written by `git diff` (`.diff`) instead of
  `fc` (`.fc`) when Git is available.
- New target `l3build saveall [-c <config>]` (replaces
  `scripts/save-all.sh`, which did not run on Windows).
- Expected results regenerated with l3build 2026-09-09 (its `\SHOWFILE`
  output changed) and the new normalisation.
- CI uses the latest TeX Live; new workflow "Save expected results"
  regenerates the `.tlg` files there and opens a pull request.
- MiKTeX's LuaTeX (no `--max-print-line` option): its lines, wrapped at 79
  bytes, are rejoined before comparing.
- Also removed from the logs before comparing: every information message
  (`Package x Info`, `LaTeX Info`, with their continuation lines), the
  character code in `Missing character` messages, the source text after
  `l.<n>`; version numbers on dated lines (`1.11b`) and the last decimals
  of `glue set` values are normalised. These changed with package or
  engine versions only.
- `l3build saveall` fails if a test produced an empty `.tlg` (a test that
  stops before `\START`, e.g. because a package is missing). The empty
  `compat-glossaries.tlg` of 0.6.5 is fixed.
- `eng-lang-russian` loads a font with Cyrillic letters (CMU Serif) and
  `eng-fontspec` runs with LuaLaTeX again; `pkg-subfigure` ignores box
  warnings that depend on hyphenation patterns.

## [0.6.5] - 2026-10-11

Test-suite release (first published 2026-10-10; the fix below, found by the
engine tests on MiKTeX, was added on 2026-10-11 before any public release). No user-facing command was added or renamed; the
existing `report.tex` produces a pixel-identical PDF, without the 28
LaTeX errors that every build used to log. Run against version 0.6, 53 of
the 106 new tests fail (one of them never ends).

### Added (repository)

- **l3build test suite**: 106 regression tests in five configurations
  (`build.lua` + `config-*.lua`), covering every public command, every
  option value, every supported language and font family:
  - `testfiles/` (48 tests, 1 run): options, word lists, fonts, counters,
    page-numbering tests, `\myinclude`, `\myincludeprogram`, utilities;
  - `testfiles-multirun/` (33 tests, 3 runs): sectioning at every
    hierarchy level, front matter, annexes, TOC depth, lists of
    figures/tables/programs/equations, floats, references, title pages,
    page layout of headings, TOC and floats;
  - `testfiles-bib/` (6 tests, 3 runs + biber): bibliography;
  - `testfiles-compat/` (16 tests): compatibility with other packages;
  - `testfiles-engines/` (3 tests): LuaLaTeX and XeLaTeX.
- `support/`: small images, code files, `sources.bib` and
  `mytest-helpers.tex` (helper macros used by the tests).
- `demo/`: 24 demo documents (`l3build doc`), one per command or command
  family, each showing the syntax, the code and its result.
- `perf/`: benchmark of compile time and number of runs (`perf.py`).
- GitHub Actions: `tests.yml` (all configurations on every push / pull
  request) and `release.yml` (demo PDFs and files attached to a release
  when a `v*` tag is pushed).
- `scripts/save-all.sh`, `CHANGELOG.md`, `README.md`, `.gitignore`,
  `.gitattributes`.

### mypackage.sty

#### Added
- Dutch word list (`lang=dutch` was listed as supported but had none).
- The word lists are also registered for babel's other names of each
  language: `american`, `USenglish`, `UKenglish`, `canadian`,
  `australian`, `newzealand`; `german`, `austrian`, `naustrian`,
  `swissgerman`, `nswissgerman`; `acadian`; `portuges`, `brazilian`,
  `brazil`.
- Page-numbering style `myalph` (a, ..., z, aa, ab, ...) that never
  overflows; used by the class for annexes.

#### Changed
- The words that babel translates (`\myfigurename`, `\mytablename`,
  `\mypartname`, `\mycontentsname`, `\mylistfigurename`,
  `\mylisttablename`, `\mybibname`, `\myabstractname`, `\mychaptername`)
  are now *defined as* babel's word (`\def\myfigurename{\figurename}`)
  instead of being copied once. They follow `\selectlanguage` and
  `otherlanguage`; the package's own words are reset by every language,
  so switching language mid-document gives the right words everywhere.
- Each language's words live in one macro (`\mypackage@words@<language>`)
  registered for every babel name of that language.
- `fontenc` is loaded after the options, with `[T2A,T1]` when `lang`
  contains `russian` (only `T1` otherwise).
- `\IfIsRomanTF`, `\IfIsromanTF`, `\IfIsarabicTF`, `\IfIsAlphTF`,
  `\IfIsalphTF` (and their `T`/`F` forms) compare the name of the current
  page-numbering style, recorded by `\pagenumbering`, instead of looking
  for characters in `\thepage`. `\IfIsalphTF` is also true for `myalph`.
- expl3 `x`-type functions replaced by `e`-type ones (`\use:e`,
  `\clist_put_right:Ne`, `\tl_set:Ne`).

#### Fixed
- `\myfigurename` and `\mytablename` were always English: they were copied
  before babel had set the language (German gave "Figure" instead of
  "Abbildung", Spanish "Table" instead of "Cuadro", Russian ...).
- German words: annex "Anhang" (was "Annektieren", the verb "to annex"),
  female plural assistants "Assistentinnen", theses "Abschlussarbeiten".
- `\myincludeprogram`: with the default `numwidth=auto` the line count read
  the file from the current folder instead of the `code` folder, so every
  listing whose file was only in `code/` raised `File 'x' not found`.
- `\myincludeprogram`: options and the computed number width leaked into
  later calls (a 300-line listing after a 5-line one got a 1-digit column).
- `\IfIs...TF` gave wrong answers whenever a page number used letters
  shared by two styles: page "i", "v", "x" in roman were "not roman",
  page "c", "d", "i", ... in alph could be taken for roman numerals.
- `\myprogram`: for a long listing (not floated, may span pages) the
  list-of-programs entry pointed to the *last* page; it now points to the
  first.
- `myequation` without a label was listed in the list of equations with
  the number of the previous equation; it is now listed without a number.
- `\ProvidesPackage` information: the version and the description were
  glued together ("V0.6Custom Package ...").
- `lang=russian` with pdfLaTeX: "No Cyrillic font encoding has been
  loaded" warning (T2A is now loaded explicitly).
- With LuaLaTeX and XeLaTeX the package loaded the 8-bit font encodings
  (`T1`, and `T2A` for Russian) meant for pdfLaTeX. Text was then set in
  pdfLaTeX's Type 1 fonts instead of OpenType fonts: characters outside
  those fonts disappeared (all Cyrillic letters, `œ`, ...). `fontenc` is
  now loaded with pdfLaTeX only.

### myreport.cls

#### Changed
- `text={fontfamily=...}` sets `\familydefault`; the default `cmr` leaves
  LaTeX's default untouched.

#### Fixed
- Every part- and chapter-level line of the table of contents and of the
  lists raised `LaTeX Error: Something's wrong--perhaps a missing \item`
  (28 errors in `report.tex`): `\addvspace` was called after `\noindent`.
  That call never had any effect, so it was removed and the output is
  unchanged.
- `text={fontfamily=...}` only changed the font at `\begin{document}`:
  with the sans-serif and monospaced families (`cmss`, `lmss`, `qag`,
  `qhv`, `phv`, `cmtt`, `lmtt`, `qcr`, `pcr`) and `lmdh`, every
  `\normalfont` (captions, footnotes, tables, title page ...) fell back to
  the serif font. It also overrode a font chosen with `fontspec`'s
  `\setmainfont` (the text was set in cmr).
- `\mymaketitle[2]` could not be used twice (`Control sequence
  \l_auth_seq already defined`); it now uses its own variables instead of
  `\l_tmpc_seq` / `\l_tmpd_seq`.
- `\myaddprofessor`, `\myaddassistant`, `\myaddauthor`: the first value
  was stored locally and the next ones globally, so names were lost or
  duplicated when the commands were used inside a group.
- An annex longer than 26 pages crashed (`Counter too large`, followed by
  an endless error loop that produced log files of several gigabytes).
  Annex pages are now numbered with `myalph`.
- `\mybibliography[<label>]`: the label pointed to the anchor of the
  previous heading; the bibliography now has its own anchor.
- `\ProvidesClass` information: version and description glued together.

### Known issues (found by the test suite, planned)

- 0.7.0: `\RegisterStructureUsage` writes one line to the `.aux` file per
  heading (hundreds of duplicates) and the flags are never reset; the
  numbering is only right from the second run.
- 0.7.0: `\myprogram` typesets every listing three times (Pygments runs
  three times).
- 0.7.5: `\myfigure` builds its label from the file name: the same image
  used twice gives a duplicate label.
- 0.7.5: `\myinclude` with both `height=` and `width=` distorts the image.
- 0.7.5: `\myintroduction` without `number=` shows the current counter
  value (0 at the start of the document).
- 0.7.5: references to equations point to amsmath's anchor (`AMS.n`) and
  the number is stored in braces (`{1.1}`); harmless in the output.
- 0.7.5: `mypseudocode` needs the user to load `clrscode3e` (no error
  message if it is missing); `clrscode3e` cannot be combined with
  `algpseudocode`.
- 0.7.5: `cleveref`'s `\cref` does not know the type of the package's
  labels ("reference format for label type `' undefined").
- 0.7.5: after an annex, a heading of the main matter restarts the arabic
  page numbering at 1.
- 0.7.5: title-page style 1 does not show the assistants; `\mycourse`
  without star uses the course ID as a `\cite` key.
- 0.8.0: categories without entries make biblatex warn "Empty
  bibliography".
- 0.8.0: the class headings do not set marks (`\leftmark` empty with
  fancyhdr).
- Question: the bibliography restarts the page numbering in lower-case
  roman numerals (i, ii, ...), while the front matter uses upper-case
  ones. Intended?

## [0.6.0] - 2026-09-25

Initial version under version control (imported as is).

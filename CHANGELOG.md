# Changelog

All notable changes to `mypackage.sty` and `myreport.cls` are recorded here.
The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/);
versions follow the roadmap in `TODO.txt`. Both files always carry the same
version number.

Sections: **Added** (new features), **Changed** (different behaviour on
purpose), **Fixed** (bugs), **Removed**, **Known issues** (found, not fixed
yet, with the version that should address them).

## [0.7.0] - unreleased (branch `v0.7.0`)

Refactoring release (roadmap 0.7.0). The commands, their arguments and the
output are unchanged: the demo report gives a pixel-identical PDF and every
test of 0.6.5 gives the same result, except for the internal names that the
tests print and the fixes below. What changed is underneath: the code is
organised in reusable functions, every name follows one convention, the
document is final after fewer LaTeX runs and `\myprogram` typesets each
listing once.

### Naming conventions (both files)

- **Document interface** (public, stable): the commands and environments
  `\my...`, the words `\my<word>name`, the counters `my<level>` /
  `my<object>` and their `\themy...`, the page style `myalph`, the
  utilities `\mycleantext`, `\mycleanline`, `\mycleanfirstline`,
  `\mylenmax`, `\mylenmin`, `\myhighestsec`, `\mycurrentacyear`.
- **Programmer interface** (public, used by the class and usable by other
  packages): expl3 functions `\mypackage_<name>:<args>` and variables
  `\l_mypackage_...` (see "Added").
- **Private**: `\__mypackage_...`, `\__myreport_...` and their variables,
  the keys `mypackage/...`, `myreport/...`; a few LaTeX2e-level internals
  `\mypackage@...`. Private names may change at any version.
- Names written to auxiliary files keep a LaTeX2e form and are stable
  (`\mypackage@structure`, `\my<level>box`, `\mycleanfirstline`), so that
  the files left by an older version still compile.

### mypackage.sty

#### Added
- `\mycurrentacyear`: new name of `\currentacyear`, now **expandable**
  (usable in `\edef`, `\typeout`, PDF metadata).
- First run: when the `.aux` file has no information on the sectioning
  levels (first compilation, deleted `.aux`), the source of the document
  (`\jobname.tex` and the files it `\input`s, `\include`s or `\subfile`s)
  is read at `\begin{document}`; every `\mypart`, `\mychapter`, ... found
  outside comments counts as used. The numbering, the TOC, the lists and
  the labels are right from the first run: the demo report (with and
  without bibliography) is final after **2 LaTeX runs** (+ biber) instead
  of 3. Reading a 5000-line document takes about 0.2 s, on the first run
  only.
- Warning "The sectioning levels used by the document have changed. Rerun
  to get the numbering right." when the levels registered during a run
  differ from the ones used for the numbering (the word "Rerun" lets
  latexmk and LaTeX Workshop recompile).
- Programmer interface: `\mypackage_register_level:n`,
  `\mypackage_level_set_used:n`, `\mypackage_if_level_used:n(TF)`,
  `\mypackage_if_above_used:n(TF)`, `\mypackage_highest_level:`,
  `\mypackage_level_index:n`, `\c_mypackage_levels_clist`,
  `\mypackage_add_to_toc:nn`, `\mypackage_anchor:n`,
  `\mypackage_anchor_name:n`, `\mypackage_label:nn`,
  `\mypackage_label_name:nn`, `\mypackage_if_pagenumbering:n(TF)`,
  `\mypackage_dotfill:`, `\mypackage_bib_category_name:n`,
  `\g_mypackage_bib_categories_seq`, `\mypackage_deprecated:nn`,
  `\l_mypackage_annex_bool`, `\l_mypackage_bibliography_bool`.
- Words are defined as tables (`\mypackage@definewords{<table>}{<word> =
  <text>, ...}`) registered for babel's language names
  (`\mypackage@registerwords`); bibliography categories likewise
  (`\mypackage@bibcategory{<name>}{<word>}{<entry types>}`): one line per
  word or category instead of three, a basis for 0.8.0.

#### Changed
- Options are processed with l3keys (`\ProcessKeyOptions`, kernel
  2022-06-01) instead of kvoptions/kvsetkeys/xstring, which are **no longer
  loaded** (load them yourself if your document uses them). Same keys, same
  values; an unknown option gives l3keys' error message.
- Sectioning levels: each level is written **once** to the `.aux` file (per
  `.aux` file: an `\include`d file has its own), as
  `\mypackage@structure{<level>}`, instead of one line per heading. When the
  `.aux` file has this information, the levels it gives are used for the
  whole run, so a level that is no longer used is **reset**. The lines
  written by 0.6.5 are ignored.
- `\myprogram` typesets each listing **once** (0.6.5: twice for a floated
  listing, three times for one in the text flow): the box made to measure
  the listing is the one put in the float. A listing whose non-empty lines
  alone are taller than `\textheight - 1cm` is typeset in the text flow
  without being measured; only a measured listing that does not fit is
  typeset twice. The test is now "listing and caption shorter than
  `\textheight - 1cm`" (0.6.5 compared the height above the centre of a
  centred box with half of that, which is about the same).
- Bibliography numbering without biblatex's `defernumbers` (which needed one
  more LaTeX run): a source map gives every entry a `presort` value from its
  category (`mp00` for the entries of no category, `mp01`, `mp02`, ... in
  printing order), the first sort key of biblatex's schemes, so biber
  already numbers the entries in printed order. A `presort` field of the
  `.bib` file is kept. biber's type aliases (`phdthesis`, `techreport`,
  `www`, ...) are mapped too.
- The biblatex filters are named `mypackage/<category>` and
  `mypackage/none` (were `articles`, `books`, ..., `not`: generic names
  that a document or another package may define too). The unused filter
  `other` was removed.
- The default colours of `\myincludeprogram` are named
  `mypackage-program-bg`, `mypackage-program-numbg` and
  `mypackage-program-num` (were `bg`, `linebg`, `linecol`).
- Depth of a TOC line: counted from the highest level used also when that
  level is the subsection or the subsubsection (0.6.5 counted from the
  section level then, which the documentation did not say).
- `\myincludeprogram` (automatic number width) and the measurement of
  `\myprogram` read the code file as strings: braces in the code no longer
  make TeX merge several lines into one when counting them.
- The top-level option `annexdepth` (accepted but without effect) now sets
  `toc={annexdepth}` and is reported as deprecated.
- `\currentacyear` is deprecated (one warning; use `\mycurrentacyear`).
- Internal names (all private now): `\RegisterStructureUsage`,
  `\ifGlobalMy<level>Used`, `\ifMyannexUsed`, `\ifMybibUsed`,
  `\mybeginfloat`, `\myaddtotoc`, `\mydotfill`, `\myhyperanchor`,
  `\mylabel`, `\mytcbincludeprogram`, `\mysubfigurelabel`,
  `\mypackage@IfPagenumbering(TF|T|F)` and the option macros
  `\mypackage@<option>` were replaced by the functions above; `\temp`,
  `\strpos`, `\strtype`, `\iffits` and `\themyFancyVerbLine` are no longer
  defined in the document's name space.

#### Removed
- Counters `pos`, `my<level>temp`, `mytocdepth`, `myannexdepth`,
  `mybibdepth`, `my<level>depth`, `mycurrentdepth` (15 counters).
- Packages xstring, kvoptions, kvsetkeys.

### myreport.cls

#### Changed
- Options with l3keys (same keys and values).
- One function per kind of code instead of one copy per level: headings
  (`\__myreport_heading:nnn`), sectioning commands, page breaks, TOC lines,
  lists, bibliography headings, title-page parts. `\mybibliography` loops
  over the categories of the package (6 blocks of 10 `\printbibliography`
  became one loop).
- `\myintroduction*` is unnumbered at every level, as documented (0.6.5:
  only when parts were the highest level; otherwise it showed the counter).
- Title page: an item given an empty value is not shown
  (`\mydate{}`, `\myacademicyear{}`); `\mycourse`, `\mytitle`,
  `\mysubtitle`, `\myimage`, `\mylogo`, `\mydate`, `\myacademicyear` store
  their value globally (they were local, unlike `\myadd...`).
- The anchor of the list of programs is `mylistprogram` (was
  `mylistprogramname`, unlike the other lists).
- biblatex headings `myreport/<level>` and `myreport/<level>/toc` (were
  `my<level>bib` and `my<level>bibintoc`).
- Internal commands made private: `\myclearpage`, `\mysavedtext`,
  `\myheadingname`, `\my<level>heading`, `\my<level>bibheading`, the
  title-page values `\my<item>val`.

### Repository

- 8 new tests (114 in total): `pkg-structure-aux` (levels read from the
  `.aux` file, old lines ignored, reset, rerun warning),
  `pkg-structure-scan` (first-run source reading),
  `cls-structure-aux` (one line per level and per `.aux` file, with
  `\include`), `pkg-program-typeset` (number of typesettings of a listing),
  `pkg-table-rows` (no extra row at the end of a table), `cls-bib-aliases`
  (aliased entry types, numbering in printed order), `cls-toc-depth-low`,
  `pkg-options-annexdepth`.
- Test helpers: `\SHOWVAR{<variable>}`, `\SETUSED{<levels>}`, `\SETANNEX`,
  `\IFPAGENUMBERING`; `\SHOWFLAGS` uses the programmer interface. The tests
  that printed internal names print the new ones; the `\currentacyear`
  test of `pkg-utils` printed the command's name instead of its value, it
  now checks the value for every month.
- Demos use the new names.

### Known issues (unchanged, planned)

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
- 0.7.5: unnumbered headings (`\mychapter*`, ...) reuse the anchor of the
  previous numbered heading ("destination with the same identifier").
- 0.8.0: categories without entries make biblatex warn "Empty
  bibliography".
- 0.8.0: the class headings do not set marks (`\leftmark` empty with
  fancyhdr).
- Question: the bibliography restarts the page numbering in lower-case
  roman numerals (i, ii, ...), while the front matter uses upper-case
  ones. Intended?

## [0.6.5] - 2026-10-12

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
- MiKTeX's LuaTeX: lines are rejoined when the next character would bring
  them to 79 bytes (the rule was off by one byte for Cyrillic text).
- `(a.fd) (b.fd) [1`, `) [9` and `] [9` are split into one marker per line
  before comparing: TeX breaks such lines differently depending on the
  length of file paths, and l3build's removal of `.fd` files swallowed a
  page marker that followed `)` on the same line.
- `pkg-subfigure`: the narrow sub-caption is a word that fits (`caption`
  calls `\sloppy`, so box warnings in captions cannot be silenced with
  `\hfuzz`); `pkg-program`: each group of listings starts on a new page, so
  page numbers do not depend on the minted version.
- `eng-lang-russian` loads a font with Cyrillic letters (CMU Serif) and
  `eng-fontspec` runs with LuaLaTeX again; `pkg-subfigure` ignores box
  warnings that depend on hyphenation patterns.
- `support/`: small images, code files, `sources.bib` and
  `mytest-helpers.tex` (helper macros used by the tests).
- `demo/`: 24 demo documents (`l3build doc`), one per command or command
  family, each showing the syntax, the code and its result.
- `perf/`: benchmark of compile time and number of runs (`perf.py`).
- GitHub Actions: `tests.yml` (all configurations on every push / pull
  request) and `release.yml` (demo PDFs and files attached to a release
  when a `v*` tag is pushed).
- `CHANGELOG.md`, `README.md`, `.gitignore`,
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
- `\myprogram`: a listing was put in a float when it was shorter than half
  of `\pagegoal`, which is `\maxdimen` at the top of a page, so a listing
  starting a page always became a float, even one longer than the page
  ("Float too large for page"). It is now compared with `\textheight`.
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

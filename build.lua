--[[
  build.lua -- l3build configuration for mypackage.sty / myreport.cls

  Main commands (run from the repository root):
    l3build check                 run every test configuration below
    l3build check -c build        only the single-run unit tests
    l3build check pkg-figure      one test (searched in every config)
    l3build save  -c <cfg> <name> (re)create the expected .tlg of a test
    l3build doc                   typeset every demo document (demo/*.tex)
    l3build install               copy the .sty/.cls into your TEXMFHOME
    l3build clean                 remove the build/ directory

  This file is the *main* configuration ("build").  The other configurations
  (config-*.lua) start from these settings and override a few of them.
--]]

module = "mypackage"

-- --------------------------------------------------------------- sources
-- There is no .dtx/.ins yet (planned for v0.8.5): the .sty and .cls are
-- the sources themselves, so "unpacking" is a plain copy.
sourcefiles  = {"mypackage.sty", "myreport.cls"}
installfiles = {"mypackage.sty", "myreport.cls"}
unpackfiles  = {}
textfiles    = {"README.md", "CHANGELOG.md", "DEVELOPMENT.md", "TODO.txt",
                "documentation.txt"}

-- --------------------------------------------------------------- checking
-- Every configuration listed here is run by a bare "l3build check".
checkconfigs = {
  "build",            -- testfiles/            single run: options, words, macros
  "config-multirun",  -- testfiles-multirun/   3 runs: numbering, TOC, references
  "config-bib",       -- testfiles-bib/        3 runs + biber: bibliography
  "config-compat",    -- testfiles-compat/     other packages loaded with ours
  "config-engines",   -- testfiles-engines/    LuaLaTeX and XeLaTeX
}

testfiledir    = "testfiles"
supportdir     = "support"        -- copied into the test directory
checksuppfiles = {"images", "code", "sources", "mytest-helpers.tex"}

checkengines = {"pdftex"}
stdengine    = "pdftex"
-- minted (loaded by mypackage) refuses to load without -shell-escape.
checkopts    = "-interaction=nonstopmode -shell-escape"
checkruns    = 1

-- A fixed date: \today, \year, \month (and therefore \currentacyear)
-- are reproducible.  1791633600 is 2026-10-10 12:00 UTC: noon, so the
-- date is the same in every time zone of the CI machines.  October is
-- after August, so the academic year is 2026-2027.
epoch           = 1791633600
forcecheckepoch = true

-- --------------------------------------------------------------- demos
-- "l3build doc" typesets the demo documents (one per command).
docfiledir       = "demo"
typesetfiles     = {"demo-*.tex"}
docfiles         = {"mydemo.sty"}     -- copied, not typeset
typesetsuppfiles = {"images", "code", "sources"}
typesetexe       = "pdflatex"
typesetopts      = "-interaction=nonstopmode -shell-escape"
typesetruns      = 3
-- l3build runs biber by itself when a .bcf file is produced.
biberexe         = "biber"
forcedocepoch    = false

-- --------------------------------------------------------------- packaging
-- (used by "l3build ctan"; CTAN upload is planned for v1.0)
packtdszip = false

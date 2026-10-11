--[[
  build.lua -- l3build configuration for mypackage.sty / myreport.cls

  Main commands (run from the repository root):
    l3build check                 run every test configuration below
    l3build check -c build        only the single-run unit tests
    l3build check -c config-multirun pkg-figure     one test
    l3build save  -c <cfg> <name> (re)create the expected .tlg of a test
    l3build saveall [-c <cfg>]    (re)create the .tlg of every test
    l3build doc                   typeset every demo document (demo/*.tex)
    l3build install               copy the .sty/.cls into your TEXMFHOME
    l3build clean                 remove the build/ directory

  This file is the *main* configuration ("build").  The other configurations
  (config-*.lua) start from these settings and override a few of them.
--]]

module = "mypackage"

-- Normalisation of the logs for MiKTeX, Windows and external programs
-- (see the comments in that file).
dofile("l3build-normalise.lua")

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

-- --------------------------------------------------------------- saveall
-- Custom target "l3build saveall": runs "l3build save" for every test of
-- every configuration (or only of the configurations given with -c).
-- Works the same on Windows, macOS and Linux.  Always review the result
-- (git diff testfiles*/) before committing it.
local test_folders = {
  ["build"]           = {dir = "testfiles"},
  ["config-multirun"] = {dir = "testfiles-multirun"},
  ["config-bib"]      = {dir = "testfiles-bib"},
  ["config-compat"]   = {dir = "testfiles-compat"},
  ["config-engines"]  = {dir = "testfiles-engines",
                         engines = {"luatex", "xetex"}},
}
target_list.saveall = {
  desc = "Saves the expected result (.tlg) of every test",
  func = function()
    for _, config in ipairs(options["config"] or checkconfigs) do
      local info = test_folders[config]
      if not info then
        print("Unknown configuration: " .. config)
        return 1
      end
      local names = {}
      for _, file in ipairs(filelist(info.dir, "*.lvt")) do
        names[#names + 1] = (file:gsub("%.lvt$", ""))
      end
      table.sort(names)
      local errorlevel = call({"."}, "save",
        {config = {config}, names = names, engine = info.engines})
      if errorlevel ~= 0 then return errorlevel end
    end
    return 0
  end,
}

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

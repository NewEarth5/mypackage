-- config-bib.lua -- bibliography tests (biblatex + biber).
--
-- l3build calls runtest_tasks() after every LaTeX run of a test; whatever
-- command it returns is executed in the test directory.  Running biber
-- after the first run mirrors a normal "pdflatex, biber, pdflatex,
-- pdflatex" build.
testfiledir = "testfiles-bib"
checkruns   = 3

function runtest_tasks(name, run)
  if run == 1 then
    return "biber --quiet " .. name
  end
  return ""
end

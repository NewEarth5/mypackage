-- config-engines.lua -- Unicode engines.
--
-- The same tests are run with LuaLaTeX and XeLaTeX.  Font and glue
-- details differ between engines, so each engine has its own .tlg
-- (name.luatex.tlg, name.xetex.tlg).
testfiledir  = "testfiles-engines"
checkengines = {"luatex", "xetex"}
stdengine    = "luatex"
checkruns    = 2

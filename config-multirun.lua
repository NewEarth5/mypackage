-- config-multirun.lua -- tests that need several LaTeX runs.
--
-- The package records which sectioning levels a document uses in the .aux
-- file (\RegisterStructureUsage), the TOC/LoF/LoT files are written at the
-- end of one run and read at the start of the next, and references need a
-- second run.  Three runs give the final state of a document from a clean
-- directory; only the log of the *last* run is compared with the .tlg.
testfiledir = "testfiles-multirun"
checkruns   = 3

-- config-compat.lua -- compatibility with other packages.
--
-- Each test loads mypackage/myreport together with one family of widely
-- used packages (in the order a user would) and exercises the commands
-- that interact with it.  The tests mostly guard against errors, so the
-- .tlg files are short.
testfiledir = "testfiles-compat"
checkruns   = 2

#!/bin/sh
# save-all.sh <config> [l3build options]
#
# (Re)generate the expected output (.tlg) of every test of one l3build
# configuration, e.g.
#     scripts/save-all.sh build
#     scripts/save-all.sh config-multirun
#     scripts/save-all.sh config-engines -e xetex
# "l3build save" needs test names; this script passes all of them.
# ALWAYS review the result with "git diff testfiles*/" before committing:
# a .tlg is only correct if the behaviour it records is correct.
cfg=${1:-build}
case $cfg in
  build)           dir=testfiles ;;
  config-multirun) dir=testfiles-multirun ;;
  config-bib)      dir=testfiles-bib ;;
  config-compat)   dir=testfiles-compat ;;
  config-engines)  dir=testfiles-engines ;;
  *) echo "unknown configuration: $cfg" >&2; exit 1 ;;
esac
[ $# -gt 0 ] && shift
names=$(ls $dir/*.lvt | xargs -n1 basename | sed 's/\.lvt$//')
l3build save -c "$cfg" "$@" $names

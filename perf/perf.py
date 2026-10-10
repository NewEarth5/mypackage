#!/usr/bin/env python3
"""Compile-time / run-count benchmark for report.tex.

Usage: perf.py <version-dir> [--engine pdflatex] [--reps 3]

For each repetition a *clean* build directory is created (assets + the
.sty/.cls of the version + report.tex) and the document is compiled the way
a user (or latexmk) would: run LaTeX, run biber when the .bcf changed, and
repeat until every auxiliary file (.aux, TOC/LoF/LoT files, .bbl) is stable
and LaTeX no longer asks for a rerun.

Reported per version:
  * number of LaTeX runs + biber runs until fixed point
  * wall time of the first run (cold: includes Inkscape SVG conversion)
  * wall time of a single warm run (everything cached)
  * total wall time to a finished PDF
  * LaTeX errors / warnings in the final log, undefined refs, pages
"""
import argparse, hashlib, os, re, shutil, subprocess, sys, time, json

HERE = os.path.dirname(os.path.abspath(__file__))
AUX_EXT = [".aux", ".mytoc", ".mylof", ".mylot", ".mylop", ".myloe", ".bbl", ".toc"]


def digest(base):
    h = hashlib.sha1()
    for ext in AUX_EXT:
        p = base + ext
        if os.path.exists(p):
            with open(p, "rb") as f:
                h.update(ext.encode() + f.read())
    return h.hexdigest()


def bcf_digest(base):
    p = base + ".bcf"
    return hashlib.sha1(open(p, "rb").read()).hexdigest() if os.path.exists(p) else None


def run(cmd, cwd):
    t = time.perf_counter()
    p = subprocess.run(cmd, cwd=cwd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    return time.perf_counter() - t, p.returncode, p.stdout.decode("utf8", "replace")


def build(version_dir, engine, workdir, maxruns=10):
    if os.path.exists(workdir):
        shutil.rmtree(workdir)
    os.makedirs(workdir)
    subprocess.run([sys.executable, os.path.join(HERE, "make_assets.py"), workdir],
                   check=True, stdout=subprocess.DEVNULL)
    for f in ("mypackage.sty", "myreport.cls"):
        shutil.copy(os.path.join(version_dir, f), workdir)
    shutil.copy(os.path.join(HERE, "report.tex"), workdir)
    base = os.path.join(workdir, "report")
    latex = [engine, "-interaction=nonstopmode", "-shell-escape", "report.tex"]
    times, biber_times, runs, biber_runs = [], [], 0, 0
    prev, prev_bcf = None, None
    while runs < maxruns:
        t, rc, out = run(latex, workdir)
        times.append(t)
        runs += 1
        log = open(base + ".log", encoding="utf8", errors="replace").read()
        bcf = bcf_digest(base)
        did_biber = False
        if bcf is not None and bcf != prev_bcf:
            bt, _, _ = run(["biber", "--quiet", "report"], workdir)
            biber_times.append(bt)
            biber_runs += 1
            prev_bcf = bcf
            did_biber = True
        cur = digest(base)
        rerun = re.search(r"Rerun to get|Please rerun|rerun LaTeX|Please \(re\)run", log)
        if cur == prev and not rerun and not did_biber:
            break
        prev = cur
    log = open(base + ".log", encoding="utf8", errors="replace").read()
    errors = re.findall(r"^! .*", log, re.M)
    warnings = re.findall(r"^(?:LaTeX|Package|Class) \S* ?Warning: .*", log, re.M)
    undef = len(re.findall(r"undefined", " ".join(warnings)))
    pages = re.search(r"Output written on .*?\((\d+) pages", log)
    # one extra warm run, timed on its own
    warm, _, _ = run(latex, workdir)
    return {
        "runs": runs, "biber_runs": biber_runs,
        "first_run_s": round(times[0], 2),
        "warm_run_s": round(warm, 2),
        "total_s": round(sum(times) + sum(biber_times), 2),
        "errors": len(errors), "error_samples": sorted(set(errors))[:8],
        "warnings": len(warnings), "undefined_refs": undef,
        "pages": int(pages.group(1)) if pages else None,
        "run_times": [round(x, 2) for x in times],
    }


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("version_dir")
    ap.add_argument("--engine", default="pdflatex")
    ap.add_argument("--reps", type=int, default=3)
    ap.add_argument("--keep", action="store_true")
    a = ap.parse_args()
    vd = os.path.abspath(a.version_dir)
    results = []
    for i in range(a.reps):
        wd = os.path.join(HERE, "build", os.path.basename(vd) + f"-{a.engine}-{i}")
        results.append(build(vd, a.engine, wd))
    r = results[0]
    summary = dict(r)
    for k in ("first_run_s", "warm_run_s", "total_s"):
        vals = sorted(x[k] for x in results)
        summary[k] = vals[len(vals) // 2]          # median
    print(json.dumps(summary, indent=2, ensure_ascii=False))

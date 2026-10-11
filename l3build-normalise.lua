--[[
  l3build-normalise.lua -- make the test logs independent of the TeX
  distribution (TeX Live / MiKTeX), the operating system and the version of
  the external programs (Pygments/minted, Inkscape).  Loaded by build.lua.

  1. Line length (MiKTeX).
     l3build asks the engine not to wrap the log by setting the environment
     variable max_print_line=9999.  TeX Live reads it; MiKTeX ignores it and
     wraps every line at 79 characters.  l3build then cannot rejoin wrapped
     lines, so all its normalisations that work on whole lines ("on input
     line 12" -> "on input line ...", file paths, .fd files ...) fail and
     nearly every test differs.  MiKTeX's pdfTeX and XeTeX accept the value
     as a command-line option instead, so it is added when MiKTeX is found.
     MiKTeX's LuaTeX has no such option: its wrapped lines are rejoined.

  2. Windows paths.
     l3build shortens file paths ("(/usr/share/.../umsa.fd" -> "(../umsa.fd")
     and drops the lines of .fd files, but only recognises "/" separators.
     MiKTeX writes "C:\Users\...\tex/latex/amsfonts\umsa.fd".  Backslashes
     in absolute paths are turned into "/" before l3build normalises.

  3. External programs.
     With -shell-escape the log records every system command (runsystem(...)),
     which depends on the OS (mkdir -p / if not exist mkdir, mv / move), on
     the minted version (minted 2 calls pygmentize, minted 3 latexminted) and
     on the program versions.  These lines, the cache files read by minted
     ((_minted-... and (_<hash>.config.minted), the registers allocated by
     packages after \START and every *information* message of LaTeX and
     of packages ("Package x Info: ...", "LaTeX Font Info: ...") are removed:
     they change with the versions of other packages and say nothing about
     the behaviour of mypackage/myreport.  Warnings and errors are kept.

  5. Errors raised before \START (while the class and the packages are
     loaded) are copied after it: l3build would not compare them otherwise.

  6. Engine-version details: the character code in "Missing character"
     messages, the source line after "l.<n>" and the last decimals of
     "glue set" (which differ between MiKTeX and TeX Live builds).

  4. Differences are written as .diff files with git (if available) instead
     of Windows' "fc", whose output is harder to read.  Set the environment
     variables diffexe/diffext to choose another program.

  The .tlg files must be generated with this file active (they are: it is
  loaded by build.lua), so that both sides of the comparison are treated the
  same way.
--]]

maxprintline = 9999

------------------------------------------------------------------------ 1
local function read_command(cmd)
  local p = io.popen(cmd)
  if not p then return "" end
  local out = p:read("*a") or ""
  p:close()
  return out
end

miktex = string.find(read_command("pdftex --version"), "MiKTeX", 1, true) ~= nil

if miktex then
  local opt = "--max-print-line=" .. maxprintline
  specialformats = specialformats or {}
  specialformats.latex = specialformats.latex or {}
  specialformats.latex.pdftex = { options = opt }
  specialformats.latex.xetex  = { options = opt }
end

------------------------------------------------------------------------ 4
if os.type == "windows" and not os.getenv("diffexe") then
  if os.execute("git --version >NUL 2>&1") then
    os_diffexe = "git diff --no-index --no-color --text"
    os_diffext = ".diff"
  end
end

------------------------------------------------------------------------ 2, 3
-- Paths containing spaces cannot be delimited reliably in a log; the usual
-- Windows installation folders are shortened first.
local function windows_paths(line)
  line = line:gsub("%a:\\Program Files %(x86%)\\", "C:\\ProgramFilesx86\\")
  line = line:gsub("%a:\\Program Files\\", "C:\\ProgramFiles\\")
  -- An absolute path: drive letter, colon, backslash, then anything up to
  -- a space or a delimiter used by TeX in the log.
  return (line:gsub("%a:\\[^%s%(%)<>{}\"']*",
                    function(path) return (path:gsub("\\", "/")) end))
end

-- MiKTeX's LuaTeX has no --max-print-line option: it wraps its log at 79
-- bytes, or slightly earlier when the next character is a multi-byte UTF-8
-- character (LuaTeX does not split characters).  Such lines are rejoined.
local luatex_wrap = 79
local function utf8_length(byte)
  if not byte or byte < 0xC0 then return 1 end
  if byte < 0xE0 then return 2 elseif byte < 0xF0 then return 3 end
  return 4
end
local function is_wrapped(line, nextline)
  if #line == luatex_wrap then return true end
  if #line < luatex_wrap - 3 or not nextline then return false end
  local first = nextline:byte(1)
  return first ~= nil and first >= 0xC0
    and #line + utf8_length(first) > luatex_wrap
end
local function unwrap(lines)
  local out, buffer = {}, nil
  for i, line in ipairs(lines) do
    buffer = (buffer or "") .. line
    if not is_wrapped(line, lines[i + 1]) then
      out[#out + 1] = buffer
      buffer = nil
    end
  end
  if buffer then out[#out + 1] = buffer end
  return out
end

-- Messages that only inform ("Package x Info: ...", "LaTeX Font Info: ..."
-- and their continuation lines "(x)   ...") change with every version of
-- the packages that write them; warnings and errors are kept.
local function info_name(line)
  local name = line:match("^Package (%S+) Info:")
            or line:match("^Class (%S+) Info:")
            or line:match("^Module (%S+) Info:")
  if name then return name end
  if line:match("^LaTeX Font Info:") then return "Font" end
  if line:match("^LaTeX Info:") then return "LaTeX" end
  return nil
end

-- "glue set 525.56442fil": the last digits depend on how the engine was
-- compiled (MiKTeX and TeX Live differ in the 5th decimal).
local function round_glue(line)
  return (line:gsub("glue set (%-?) ?(%d+%.%d+)", function(sign, value)
    return "glue set " .. sign .. string.format("%.2f", tonumber(value))
  end))
end

-- Raw log -> raw log, before l3build's own normalisation.
function mytests_prepare_log(content, engine)
  local lines = {}
  for line in (content .. "\n"):gmatch("([^\n]*)\n") do
    lines[#lines + 1] = line:gsub("\r$", "")
  end
  if miktex and engine and engine:match("^lua") then
    lines = unwrap(lines)
  end
  local out = {}
  local started = false       -- after START-TEST-LOG
  local in_runsystem = false  -- inside a (possibly wrapped) runsystem line
  local pending_close = 0     -- ")" still to drop for removed "(file" opens
  local info = nil            -- name of the info message being dropped
  local preamble_errors = {}  -- "! ..." lines logged before START-TEST-LOG
  for _, line in ipairs(lines) do
    line = windows_paths(line)
    local keep = true
    if info and not line:match("^%(" .. info:gsub("%p", "%%%0") .. "%)") then
      info = nil
    end
    if not started and line:match("^! ") then
      preamble_errors[#preamble_errors + 1] = line
    end
    if line == "START-TEST-LOG" then
      -- l3build compares only what follows this line.  Errors raised while
      -- the class and packages were loaded would go unnoticed: report them
      -- here.
      started = true
      out[#out + 1] = line
      for _, err in ipairs(preamble_errors) do
        out[#out + 1] = "PREAMBLE ERROR " .. err
      end
      keep = false
    end
    if started then
      if in_runsystem or line:match("^runsystem%(") then
        -- runsystem(<command>)...executed. / ...disabled. / ...failed.
        in_runsystem = not line:match("%)%.%.%.%a+%.?$")
        keep = false
      elseif line:match("^\\[^%s=]+=\\%a+%d*$") then
        -- register allocation, e.g. "\pydata@fh@0=\write4"
        keep = false
      elseif info or info_name(line) then
        info = info or info_name(line)
        keep = false
      else
        -- "Missing character: There is no x (U+0153) in font ...": the code
        -- is written as (U+0153), ("153) or not at all, depending on the
        -- engine version.
        if line:match("^Missing character:") then
          line = line:gsub(" %(U%+%x+%)", ""):gsub(' %("%x+%)', "")
        end
        -- "l.12 <source line>": how much of the source line is shown
        -- depends on the engine's error_line setting.
        line = line:gsub("^l%.%d+ .*", "l. ...")
        line = round_glue(line)
        -- minted cache files: "(_minted-x/style.pygstyle)" (closed on the
        -- same line) or "(_minted-x/<hash>.pygtex" (closed later)
        local n1, n2, opened
        line, n1 = line:gsub("%s?%(%.?/?_minted[^%s%(%)]*%)", "")
        line, n2 = line:gsub("%s?%(%.?/?_%x+%.config%.minted%)", "")
        line, opened = line:gsub("%s?%(%.?/?_minted[^%s%(%)]*$", "")
        if n1 + n2 + opened > 0 then line = line:gsub("%s+$", "") end
        pending_close = pending_close + opened
        if pending_close > 0 and opened == 0 then
          local closed
          line, closed = line:gsub("^%)", "", 1)
          pending_close = pending_close - closed
        end
        if opened > 0 and line:match("^%s*$") then keep = false end
      end
    end
    if keep then
      -- "] (./job.aux)": the end of the last page and the .aux file read at
      -- \end{document} are on one line, unless a system command was logged
      -- in between (minted 3).  Always use two lines.
      local page_end, aux = line:match("^(.*%]) (%(%.?/?[^%s%(%)]+%.aux%))$")
      if started and page_end then
        out[#out + 1] = page_end
        out[#out + 1] = aux
      else
        out[#out + 1] = line
      end
    end
  end
  return table.concat(out, "\n")
end

-- Version numbers on lines that carry a date ("File: x.sty 2024/01/01
-- 1.11b ...") are replaced by "v..." (l3build only knows "v1.2" forms).
versionpatterns = {"%f[%w]%d+%.%d+[%w%.]*"}

-- Wrap l3build's rewrite_log so that the raw log is prepared first (only
-- once, even if this file is read again for another configuration).
l3build_rewrite_log = l3build_rewrite_log or rewrite_log
function rewrite_log(source, result, engine, errlevels)
  local file = io.open(source, "rb")
  if file then
    local content = file:read("a")
    file:close()
    file = assert(io.open(source, "wb"))
    file:write(mytests_prepare_log(content, engine))
    file:close()
  end
  return l3build_rewrite_log(source, result, engine, errlevels)
end

% LTeX: enabled=false %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% CLASS INFORMATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%% DESCRIPTION %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NeedsTeXFormat{%                                  % TeX format need                %
  LaTeX2e%                                         % - Name                         %
}[%                                                %                                %
  2022-06-01%                                      % - Minimum version              %
]                                                  %                                %
\ProvidesClass{%                                   % Class information              %
  myreport%                                        % - Name                         %
}[%                                                %                                %
  2026/10/12 V0.7.0 %                              % - Version (the space before %  %
  Custom Report Class by Alexandre Lindsey%        %   ends the version number)     %
]                                                  %                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% NAMING CONVENTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Document interface (public, stable).  Commands and environments starting       %
%    with "my" (\myfigure, \myref, mytable, ...), the words \my<word>name, the      %
%    counters my<level> / my<object> with their \themy<...>, the page-numbering     %
%    style myalph, the utilities \mycleantext, \mycleanline, \mycleanfirstline,     %
%    \mylenmax, \mylenmin, \myhighestsec and \mycurrentacyear.                      %
% 2. Programmer interface (public, for myreport.cls and other packages).            %
%    expl3 functions and variables of the "mypackage" module without a double       %
%    underscore: \mypackage_<name>:<arguments>, \l_mypackage_<name>_<type>.         %
% 3. Private code (may change at any version).  \__mypackage_<name>:<args>,         %
%    \l__mypackage_..., \g__mypackage_..., \c__mypackage_..., the keys under        %
%    mypackage/..., and the few LaTeX2e-level internals \mypackage@<name>.          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% CLASS OPTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DESCRIPTION %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% text={                                           % defaults:                      %
%   fontsize=<size>,                               % - 10pt                         %
%   fontfamily=<family>,                           % - cmr                          %
%   lang=<babel language(s)>                       % - british                      %
% }                                                %                                %
% paths={                                          % defaults:                      %
%   images=<dir/>,                                 % - code/                        %
%   code=<dir/>,                                   % - images/                      %
%   sources=<file.bib>                             % - sources/sources.bib          %
% }                                                %                                %
% position=<placement>                             % placement for every float type %
% position={                                       % per float type; defaults:      %
%   figure=<placement>,                            % - h                            %
%   table=<placement>,                             % - h                            %
%   program=<placement>,                           % - h                            %
%   pseudocode=<placement>                         % - h                            %
% }                                                %                                %
% toc={                                            % defaults:                      %
%   depth=<n>,                                     % - 2                            %
%   annexdepth=<n>,                                % - 0                            %
%   bibdepth=<n>                                   % - 1                            %
% }                                                %                                %
% sectioning=<break|nobreak>                       % page break for every level     %
% sectioning={                                     % per level; defaults:           %
%   part=<break|nobreak>,                          % - break                        %
%   chapter=<break|nobreak>,                       % - break                        %
%   section=<break|nobreak>,                       % - nobreak                      %
%   subsection=<break|nobreak>,                    % - nobreak                      %
%   subsubsection=<break|nobreak>,                 % - nobreak                      %
%   annex=<break|nobreak>,                         % - break                        %
%   bib=<break|nobreak>                            % - break                        %
% }                                                %                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\ExplSyntaxOn
\tl_new:N \l__myreport_text_fontsize_tl
\tl_new:N \l__myreport_text_fontfamily_tl
\tl_new:N \l__myreport_text_lang_tl
\tl_new:N \l__myreport_paths_tl
\tl_new:N \l__myreport_position_tl
\tl_new:N \l__myreport_toc_tl
\clist_const:Nn \c__myreport_sectioning_clist {
  part,
  chapter,
  section,
  subsection,
  subsubsection,
  annex,
  bib
}
\clist_map_inline:Nn \c__myreport_sectioning_clist {
  \tl_new:c { l__myreport_sectioning_ #1 _tl }
}
\keys_define:nn { myreport } {
  text.code:n = { \keys_set:no { myreport / text } {#1} },
  paths.tl_set:N = \l__myreport_paths_tl,
  position.tl_set:N = \l__myreport_position_tl,
  toc.tl_set:N = \l__myreport_toc_tl ,
  sectioning.code:n = { \__myreport_sectioning_set:o {#1} },
}
\keys_define:nn { myreport / text } {
  fontsize.tl_set:N = \l__myreport_text_fontsize_tl,
  fontsize.initial:n = 10pt,
  fontfamily.tl_set:N = \l__myreport_text_fontfamily_tl,
  fontfamily.initial:n = cmr,
  lang.tl_set:N = \l__myreport_text_lang_tl,
  lang.initial:n = british,
}
\keys_define:nn { myreport / sectioning } {
  part.tl_set:N = \l__myreport_sectioning_part_tl,
  part.initial:n = break,
  chapter.tl_set:N = \l__myreport_sectioning_chapter_tl,
  chapter.initial:n = break,
  section.tl_set:N = \l__myreport_sectioning_section_tl,
  section.initial:n = nobreak,
  subsection.tl_set:N = \l__myreport_sectioning_subsection_tl,
  subsection.initial:n = nobreak,
  subsubsection.tl_set:N = \l__myreport_sectioning_subsubsection_tl,
  subsubsection.initial:n = nobreak,
  annex.tl_set:N = \l__myreport_sectioning_annex_tl,
  annex.initial:n = break,
  bib.tl_set:N = \l__myreport_sectioning_bib_tl,
  bib.initial:n = break,
}
\cs_new_protected:Npn \__myreport_sectioning_set:n #1 {
  \tl_if_blank:nF {#1} {
    \tl_if_in:nnTF {#1} { = } {
      \keys_set:nn { myreport / sectioning } {#1}
    } {
      \clist_map_inline:Nn \c__myreport_sectioning_clist {
        \tl_set:cn { l__myreport_sectioning_ ##1 _tl } {#1}
      }
    }
  }
}
\cs_generate_variant:Nn \__myreport_sectioning_set:n { o }
\ProcessKeyOptions [ myreport ]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% LOAD CLASS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DESCRIPTION %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\use:e {                                           %                                %
  \exp_not:N \LoadClass [                          % Base class                     %
    a4paper,                                       % - Page size                    %
    \l__myreport_text_fontsize_tl                  % - Font size                    %
  ] { report }                                     %                                %
}                                                  %                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% REQUIRED PACKAGES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DESCRIPTION %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\use:e {                                           %                                %
  \exp_not:N \RequirePackage [                     % My custom package              %
    lang = { \exp_not:V \l__myreport_text_lang_tl },    % - Language option              %
    paths = { \exp_not:V \l__myreport_paths_tl },       % - Folder paths                 %
    position = { \exp_not:V \l__myreport_position_tl }, % - Float placement              %
    toc = { \exp_not:V \l__myreport_toc_tl },      % - TOC options                  %
  ] { mypackage }                                  %                                %
}                                                  %                                %
\ExplSyntaxOff                                     %                                %
\RequirePackage{amsmath}                           % Advanced math formulas         %
\RequirePackage{amsfonts}                          % Extra math fonts and symbols   %
\RequirePackage{amssymb}                           % More math symbols and fonts    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% FONTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DESCRIPTION %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% text={fontfamily=<family>} loads the package of the family and makes it the       %
% default family of the document (\familydefault, used by \normalfont, so also      %
% in captions, footnotes, ...). The default cmr leaves LaTeX's default alone,       %
% so that a main font chosen with fontspec still works.                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\ExplSyntaxOn
\prop_const_from_keyval:Nn \c__myreport_font_packages_prop {
  cmr = ,
  lmr = lmodern,
  lmdh = lmodern,
  qtm = tgtermes,
  qpl = tgpagella,
  qbk = tgbonum,
  qcs = tgschola,
  ptm = mathptmx,
  put = utopia,
  ppl = palatino,
  pbk = bookman,
  bch = charter,
  cmss = ,
  lmss = lmodern,
  qag = tgadventor,
  qhv = tgheros,
  phv = helvet,
  cmtt = ,
  lmtt = lmodern,
  qcr = tgcursor,
  pcr = courier,
}
\tl_new:N \l__myreport_font_package_tl
\exp_args:NNV \prop_get:NnNT \c__myreport_font_packages_prop \l__myreport_text_fontfamily_tl \l__myreport_font_package_tl {
  \tl_if_empty:NF \l__myreport_font_package_tl {
    \exp_args:NV \RequirePackage \l__myreport_font_package_tl
  }
}
\str_if_eq:VnF \l__myreport_text_fontfamily_tl { cmr } {
  \cs_set:Npe \familydefault { \l__myreport_text_fontfamily_tl }
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% PAGE BREAKS AND HEADINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \__myreport_clearpage:nn {<level>} {<break|nobreak>}: what comes before a         %
% heading. nobreak: a new paragraph (in an annex the highest level still starts     %
% a new page). break: a new page; a right-hand page (\cleardoublepage) for the      %
% highest level used. In an annex or in the bibliography, sectioning={annex=        %
% nobreak} or {bib=nobreak} turns every break into nobreak.                         %
%                                                                                   %
% \__myreport_heading:nnn {<level>} {<number>} {<title>} typesets the heading       %
% (<number> empty: unnumbered); \__myreport_part_heading:nn {<label>} {<title>}     %
% the part heading ("Part 1" above the title, nothing if <label> is empty).         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\tl_new:N \l__myreport_break_tl
% \begingroup Improve
% Remove #2 by find it's value from #1
\cs_new_protected:Npn \__myreport_clearpage:nn #1#2 {
  \tl_set:Nn \l__myreport_break_tl {#2}
  \bool_if:NT \l_mypackage_annex_bool {
    \str_if_eq:VnT \l__myreport_sectioning_annex_tl { nobreak } {
      \tl_set:Nn \l__myreport_break_tl { nobreak }
    }
  }
  \bool_if:NT \l_mypackage_bibliography_bool {
    \str_if_eq:VnT \l__myreport_sectioning_bib_tl { nobreak } {
      \tl_set:Nn \l__myreport_break_tl { nobreak }
    }
  }
  \str_if_eq:VnTF \l__myreport_break_tl { nobreak } {
    \bool_lazy_and:nnTF {
      \l_mypackage_annex_bool
    } {
      \str_if_eq_p:ee {#1} { \mypackage_highest_level: }
    } {
      \clearpage
    } {
      \par
    }
  } {
    \clist_if_in:NnTF \c_mypackage_levels_clist {#1} {
      \mypackage_if_above_used:nTF {#1} {
        \clearpage
      } { 
        \cleardoublepage
      }
    } {
      \pagebreak
    }
  }
}
\prop_const_from_keyval:Nn \c__myreport_heading_font_prop {
  part = \centering \bfseries \itshape \Huge,
  chapter = \bfseries \LARGE,
  section = \bfseries \Large,
  subsection = \bfseries \large,
  subsubsection = \bfseries \normalsize,
}
\prop_const_from_keyval:Nn \c__myreport_heading_after_prop {
  part = 0em,
  chapter = -0.5em,
  section = -1em,
  subsection = -1em,
  subsubsection = -1em,
}
\cs_new_protected:Npn \__myreport_heading:nnn #1#2#3 {
  \group_begin:
    \vspace { 4em }
    \__myreport_clearpage:nv {#1} { l__myreport_sectioning_ #1 _tl }
    \setlength { \parindent } { 0cm }
    \vspace { -3em }
    \prop_item:Nn \c__myreport_heading_font_prop {#1}
    \tl_if_empty:nF {#2} { #2 \hspace { 1em } }
    #3 \\
    \vspace { \prop_item:Nn \c__myreport_heading_after_prop {#1} }
    \par
  \group_end:
}
\cs_new_protected:Npn \__myreport_part_heading:nn #1#2 {
  \group_begin:
    \vspace { 3em }
    \__myreport_clearpage:nV { part } \l__myreport_sectioning_part_tl
    \setlength { \parindent } { 0cm }
    \vspace { -2em }
    \prop_item:Nn \c__myreport_heading_font_prop { part }
    \tl_if_empty:nF {#1} { #1 \\ }
    \vspace { -0.5em }
    \rule { \textwidth } { 1pt } \\
    #2 \\
    \vspace { -0.5em }
    \rule { \textwidth } { 0.3pt }
    \vspace { \prop_item:Nn \c__myreport_heading_after_prop { part } }
    \par
  \group_end:
}
\cs_generate_variant:Nn \__myreport_clearpage:nn { nV , nv }
\cs_new_protected:Npn \__myreport_heading_any:nnn #1#2#3 {
  \str_if_eq:nnTF {#1} { part } {
    \__myreport_part_heading:nn {#2} {#3}
  } {
    \__myreport_heading:nnn {#1} {#2} {#3}
  }
}
% \begingroup Improve
% Make it work for subsection and subsubsection also if those are the highest used levels
\cs_new:Npn \__myreport_front_level: {
  \mypackage_if_level_used:nTF { part } {
    part
  } {
    \mypackage_if_level_used:nTF { chapter } { chapter } { section }
  }
}
\cs_new_protected:Npn \__myreport_front_heading:n #1 {
  \__myreport_heading_any:enn { \__myreport_front_level: } { } {#1}
}
\cs_generate_variant:Nn \__myreport_heading_any:nnn { e }
\cs_new_protected:Npn \__myreport_set_pagenumbering:n #1 {
  \mypackage_if_pagenumbering:nF {#1} {
    \newpage \pagenumbering {#1}
  }
}
\cs_new_protected:Npn \__myreport_main_pagenumbering: {
  \bool_if:NTF \l_mypackage_annex_bool {
    \__myreport_set_pagenumbering:n { myalph }
  } {
    \__myreport_set_pagenumbering:n { arabic }
  }
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% TITLE PAGE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \mycourse{<name>}[<ID>] course (ID in brackets)                                   %
% \myaddprofessor(*){<last>}{<first>}, \myaddassistant(*){<last>}{<first>}          %
% \myaddauthor(*){<last>}{<first>}[<ID>] (*: female, for the role names)            %
% \mytitle(*){<title>} (*: not underlined), \mysubtitle{<subtitle>}                 %
% \myimage[<options>]{<file>}, \mylogo[<options>]{<file>}                           %
% \mydate{<date>} (default \today), \myacademicyear{<years>} (default: the          %
%     current academic year)                                                        %
% \mymaketitle(*)[<style 1 or 2>]  (*: keeps the page geometry)                     %
% An item left empty is not shown.                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\tl_new:N \g__myreport_course_tl
\tl_new:N \g__myreport_course_id_tl
\tl_new:N \g__myreport_title_tl
\bool_new:N \g__myreport_title_underline_bool
\tl_new:N \g__myreport_subtitle_tl
\tl_new:N \g__myreport_image_tl
\tl_new:N \g__myreport_logo_tl
\tl_new:N \g__myreport_date_tl
\tl_new:N \g__myreport_acyear_tl
\tl_gset:Nn \g__myreport_date_tl { \today }
\tl_gset:Nn \g__myreport_acyear_tl { \mycurrentacyear }
\clist_map_inline:nn { professor , assistant , author } {
  \seq_new:c { g__myreport_ #1 _seq }
  \seq_new:c { g__myreport_ #1 _gender_seq }
}
\seq_new:N \g__myreport_author_id_seq
\seq_new:N \l__myreport_author_seq
\NewDocumentCommand \mycourse { m o } {
  \tl_gset:Nn \g__myreport_course_tl {#1}
  \IfNoValueF {#2} {
    \tl_if_blank:nF {#2} { \tl_gset:Nn \g__myreport_course_id_tl {#2} }
  }
}
\cs_new_protected:Npn \__myreport_add_person:nnnn #1#2#3#4 {
  \seq_gput_right:cn { g__myreport_ #1 _seq } { \textsc {#3} \space #4 }
  \seq_gput_right:ce { g__myreport_ #1 _gender_seq } {
    \IfBooleanTF {#2} {
      f
    } {
      m
    }
  }
}
\NewDocumentCommand \myaddprofessor { s m m } {
  \__myreport_add_person:nnnn { professor } {#1} {#2} {#3}
}
\NewDocumentCommand \myaddassistant { s m m } {
  \__myreport_add_person:nnnn { assistant } {#1} {#2} {#3}
}
\NewDocumentCommand \myaddauthor { s m m O{} } {
  \__myreport_add_person:nnnn { author } {#1} {#2} {#3}
  \seq_gput_right:Nn \g__myreport_author_id_seq {#4}
}
\NewDocumentCommand \myacademicyear { m } {
  \tl_gset:Nn \g__myreport_acyear_tl {#1}
}
\NewDocumentCommand \mytitle { s m } {
  \IfBooleanTF {#1} {
    \bool_gset_false:N \g__myreport_title_underline_bool
  } {
    \bool_gset_true:N \g__myreport_title_underline_bool
  }
  \tl_gset:Nn \g__myreport_title_tl {#2}
}
\NewDocumentCommand \mysubtitle { m } {
  \tl_gset:Nn \g__myreport_subtitle_tl {#1}
}
\NewDocumentCommand \myimage { O{width=1} m } {
  \tl_gset:Nn \g__myreport_image_tl { \myinclude [#1] {#2} }
}
\NewDocumentCommand \mylogo { O{height=0.035} m } {
  \tl_gset:Nn \g__myreport_logo_tl { \myinclude [#1] {#2} }
}
\NewDocumentCommand \mydate { m } {
  \tl_gset:Nn \g__myreport_date_tl {#1}
}
\cs_new:Npn \__myreport_role:n #1 {
  \int_compare:nNnTF { \seq_count:c { g__myreport_ #1 _seq } } = { 1 } {
    \str_if_eq:eeTF { \seq_item:cn { g__myreport_ #1 _gender_seq } { 1 } } { f } {
      \use:c { my #1 fname }
    } {
      \use:c { my #1 mname }
    }
  } {
    \seq_if_in:cnTF { g__myreport_ #1 _gender_seq } { m } {
      \use:c { my #1 mpname }
    } {
      \use:c { my #1 fpname }
    }
  }
}
\prg_new_conditional:Npnn \__myreport_if_people:n #1 { T , F , TF } {
  \seq_if_empty:cTF { g__myreport_ #1 _seq } {
    \prg_return_false:
  } {
    \prg_return_true:
  }
}
\cs_new_protected:Npn \__myreport_title_course: {
  \tl_if_empty:NF \g__myreport_course_tl {
    \textbf { \textsc { \g__myreport_course_tl } }
  }
  \tl_if_empty:NF \g__myreport_course_id_tl {
    \textbf { \textsc { \space [ \g__myreport_course_id_tl ] } }
  }
}
\cs_new_protected:Npn \__myreport_title_text: {
  \begin { center }
    \tl_if_empty:NF \g__myreport_title_tl {
      \bool_if:NTF \g__myreport_title_underline_bool {
        \textbf { \Huge \underline { \g__myreport_title_tl } }
      } {
        \textbf { \Huge \g__myreport_title_tl }
      }
    }
    \tl_if_empty:NF \g__myreport_subtitle_tl {
      \textbf {
        \textsc {
          \\ [ 0.015 \textheight ]
          \LARGE
          \textcolor { darkgray } { \g__myreport_subtitle_tl }
        }
      }
    }
  \end { center }
}
\cs_new_protected:Npn \__myreport_title_image: {
  \tl_if_empty:NF \g__myreport_image_tl {
    \begin { center }
      \vspace { 0.05 \textheight }
      \g__myreport_image_tl
      \vspace { 0.05 \textheight }
    \end { center }
  }
}
\cs_new_protected:Npn \__myreport_title_acyear: {
  \tl_if_empty:NF \g__myreport_acyear_tl {
    \textbf { \textsc { \myacyearname \c_colon_str \space } }
    \textsc { \g__myreport_acyear_tl }
  }
}
\cs_new_protected:Npn \__myreport_title_date: {
  \tl_if_empty:NF \g__myreport_date_tl {
    \textbf { \g__myreport_date_tl }
  }
}
% \begingroup Improve
% Make image be a certain amount of space from the page bottom instead of centered with title
\cs_new_protected:cpn { __myreport_titlepage_1: } {
  \begin { tabularx } { \textwidth } { > { \raggedright \arraybackslash } X > { \raggedleft \arraybackslash } X }
    \__myreport_title_course:
    &
    \__myreport_if_people:nT { professor } {
      \textbf { \__myreport_role:n { professor } }
      \textbf { \c_colon_str \space }
      \seq_use:Nn \g__myreport_professor_seq { \space \& \space }
    }
  \end { tabularx }
  \vspace { 2pt }
  \hrule height 4pt width \hsize
  \vspace { -2pt }
  \begin { tabularx } { \textwidth } { c > { \raggedleft \arraybackslash } X }
    & \__myreport_title_acyear:
  \end { tabularx }
  \vspace { 0.05 \textheight }
  \vspace* { \fill }
  \__myreport_title_text:
  \__myreport_title_image:
  \vspace* { \fill }
  \begin { tabularx } { \textwidth } { c > { \raggedleft \arraybackslash } X }
    \tl_if_empty:NF \g__myreport_logo_tl {
      \adjustbox { valign = b } { \g__myreport_logo_tl }
    }
    &
    \__myreport_title_date:
  \end { tabularx }
  \vspace { 2pt }
  \hrule height 4pt width \hsize
  \vspace { -2pt }
  \begin { center }
    \__myreport_if_people:nT { author } {
      \textbf {
        \begin { tabular } {
          * { \seq_count:N \g__myreport_author_seq }
          { > { \centering \arraybackslash } p { \fp_eval:n { 0.8 / \seq_count:N \g__myreport_author_seq } \textwidth }}
        }
          \seq_use:Nn \g__myreport_author_seq { & } \\
          \seq_use:Nn \g__myreport_author_id_seq { & }
        \end { tabular }
      }
    }
  \end { center }
}
\cs_new_protected:cpn { __myreport_titlepage_2: } {
  \begin { tabularx } { \textwidth } { > { \raggedright \arraybackslash } X r }
    \__myreport_title_course:
    &
    \tl_if_empty:NF \g__myreport_logo_tl {
      \adjustbox { valign = t } { \g__myreport_logo_tl }
    }
  \end { tabularx }
  \vspace* { \fill }
  \hrule height 1.5pt width \hsize
  \vspace { 8pt }
  \__myreport_title_text:
  \vspace { 16pt }
  \hrule height 1.5pt width \hsize
  \__myreport_title_image:
  \vspace* { \fill }
  \par
  \seq_clear:N \l__myreport_author_seq
  \int_step_inline:nn { \seq_count:N \g__myreport_author_seq } {
    \tl_if_blank:eTF { \seq_item:Nn \g__myreport_author_id_seq {##1} } {
      \seq_put_right:Ne \l__myreport_author_seq
        { \seq_item:Nn \g__myreport_author_seq {##1} }
    } {
      \seq_put_right:Ne \l__myreport_author_seq
        {
          \seq_item:Nn \g__myreport_author_seq {##1}
          \exp_not:N \space
          ( \seq_item:Nn \g__myreport_author_id_seq {##1} )
        }
    }
  }
  \hspace { 45pt }
  \bool_lazy_or:nnT {
    ! \seq_if_empty_p:N \g__myreport_professor_seq
  } {
    ! \seq_if_empty_p:N \g__myreport_assistant_seq
  } {
    \begin { tabular } [t] { l | l }
      \__myreport_if_people:nT { professor } {
        \textbf { \__myreport_role:n { professor } }
        & \seq_use:Nn \g__myreport_professor_seq { \\ & } \\
      }
      \__myreport_if_people:nT { assistant } {
        \textbf { \__myreport_role:n { assistant } }
        & \seq_use:Nn \g__myreport_assistant_seq { \\ & } \\
      }
    \end { tabular }
  }
  \hspace { \fill }
  \__myreport_if_people:nT { author } {
    \begin { tabular } [t] { l | l }
      \textbf { \__myreport_role:n { author } }
      & \seq_use:Nn \l__myreport_author_seq { \\ & } \\
    \end { tabular }
  }
  \hspace* { 45pt }
  \\ [ 25pt ]
  \begin { tabularx } { \textwidth } { > { \raggedright \arraybackslash } X r }
    \__myreport_title_acyear:
    &
    \__myreport_title_date:
  \end { tabularx }
}
\NewDocumentCommand \mymaketitle { s O{1} } {
  \hypersetup { pageanchor = false }
  \IfBooleanF {#1} { \newgeometry { margin = 1cm } }
  \cs_if_exist:cT { __myreport_titlepage_ #2 : } {
    \begin { titlepage }
      \setlength { \parindent } { 0cm }
      \use:c { __myreport_titlepage_ #2 : }
    \end { titlepage }
  }
  \IfBooleanF {#1} { \restoregeometry }
  \hypersetup { pageanchor = true }
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% SECTIONING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \mypart(*){<title>}[name=<word>, number=<n>, label=<label>]                       %
% \mychapter(*), \mysection(*), \mysubsection(*), \mysubsubsection(*)               %
%     {<title>}[number=<n>, label=<label>]                                          %
% *: unnumbered and not in the TOC. Labels: part:, chap:, sec:, subsec:,            %
% subsubsec: (ann:<prefix>: in an annex). Inside a myannex environment the          %
% parts are named \myannexname and the pages are numbered a, b, ...                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\tl_new:N \l__myreport_section_number_tl
\tl_new:N \l__myreport_section_label_tl
\tl_new:N \l__myreport_section_name_tl
\tl_new:N \l__myreport_section_givenname_tl
\tl_new:N \l__myreport_section_numtext_tl
\tl_new:N \l__myreport_section_fulllabel_tl
\bool_new:N \l__myreport_section_number_bool
\bool_new:N \l__myreport_section_label_bool
\bool_new:N \l__myreport_section_name_bool
\keys_define:nn { myreport / section } {
  number.code:n = {
    \bool_set_true:N \l__myreport_section_number_bool
    \tl_set:Nn \l__myreport_section_number_tl {#1}
  },
  label.code:n = {
    \bool_set_true:N \l__myreport_section_label_bool
    \tl_set:Nn \l__myreport_section_label_tl {#1}
  },
}
\keys_define:nn { myreport / part } {
  number.meta:nn = { myreport / section } { number = {#1} },
  label.meta:nn = { myreport / section } { label = {#1} },
  name.code:n = {
    \bool_set_true:N \l__myreport_section_name_bool
    \tl_set:Nn \l__myreport_section_givenname_tl {#1}
  },
}
% \begingroup Idea
% Make this a package constant instead (look for other examples)
\prop_const_from_keyval:Nn \c__myreport_label_prefix_prop {
  part = part,
  chapter = chap,
  section = sec,
  subsection = subsec,
  subsubsection = subsubsec,
}
% \__myreport_section:nnnn {<level>} {<star>} {<title>} {<options>}
\cs_new_protected:Npn \__myreport_section:nnnn #1#2#3#4 {
  \bool_set_false:N \l__myreport_section_number_bool
  \bool_set_false:N \l__myreport_section_label_bool
  \bool_set_false:N \l__myreport_section_name_bool
  \str_if_eq:nnTF {#1} { part } {
    \keys_set:nn { myreport / part } {#4}
  } {
    \keys_set:nn { myreport / section } {#4}
  }
  \mypackage_register_level:n {#1}
  \__myreport_main_pagenumbering:
  \bool_if:NTF \l_mypackage_annex_bool {
    \tl_set:Nn \l__myreport_section_name_tl { \myannexname }
  } {
    \tl_set:Nn \l__myreport_section_name_tl { \mypartname }
  }
  \bool_if:NT \l__myreport_section_name_bool {
    \tl_set_eq:NN \l__myreport_section_name_tl \l__myreport_section_givenname_tl
  }
  \IfBooleanTF {#2} {
    \__myreport_heading_any:nnn {#1} { } {#3}
  } {
    \clist_if_in:nnT { section , subsection , subsubsection } {#1} {
      \mypackage_if_above_used:nF {#1} {
        \clist_map_inline:nn { myfigure , myprogram , myequation , mytable } {
          \setcounter {##1} { 0 }
        }
      }
    }
    \bool_if:NTF \l__myreport_section_number_bool {
      \setcounter { my #1 } { \l__myreport_section_number_tl }
    } {
      \stepcounter { my #1 }
    }
    \__myreport_section_numtext:n {#1}
    \__myreport_heading_any:nVn {#1} \l__myreport_section_numtext_tl {#3}
  }
  \mypackage_anchor:n { my #1 }
  \bool_if:NT \l__myreport_section_label_bool {
    \tl_set:Ne \l__myreport_section_fulllabel_tl {
      \bool_if:NT \l_mypackage_annex_bool { ann \c_colon_str }
      \prop_item:Nn \c__myreport_label_prefix_prop {#1}
      \c_colon_str
      \exp_not:V \l__myreport_section_label_tl
    }
    \mypackage_label:nV { my #1 } \l__myreport_section_fulllabel_tl
  }
  \IfBooleanF {#2} {
    \__myreport_section_numtext:n {#1}
    \mypackage_add_to_toc:nn {#1} {
      \use:c { my #1 box } [l] { \l__myreport_section_numtext_tl }
      \hspace { 1em } #3
    }
  }
}
% \begingroup Improve
% Move all of the variants underneath their respective base functions
\cs_generate_variant:Nn \__myreport_heading_any:nnn { nV }
\cs_generate_variant:Nn \mypackage_label:nn { nV }
\cs_new_protected:Npn \__myreport_section_numtext:n #1 {
  \str_if_eq:nnTF {#1} { part } {
    \tl_set:Ne \l__myreport_section_numtext_tl {
      \exp_not:V \l__myreport_section_name_tl \exp_not:N \space \exp_not:N \themypart
    }
  } {
    \tl_set:Nn \l__myreport_section_numtext_tl { \use:c { themy #1 } }
  }
}
\NewDocumentCommand \mypart { s m O{} } {
  \__myreport_section:nnnn { part } {#1} {#2} {#3}
}
\NewDocumentCommand \mychapter { s m O{} } {
  \__myreport_section:nnnn { chapter } {#1} {#2} {#3}
}
\NewDocumentCommand \mysection { s m O{} } {
  \__myreport_section:nnnn { section } {#1} {#2} {#3}
}
\NewDocumentCommand \mysubsection { s m O{} } {
  \__myreport_section:nnnn { subsection } {#1} {#2} {#3}
}
\NewDocumentCommand \mysubsubsection { s m O{} } {
  \__myreport_section:nnnn { subsubsection } {#1} {#2} {#3}
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% FRONT MATTER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \myabstract(*)[<label>] abstract (pages I, II, ...), label abst:                  %
% \myintroduction(*)[number=<n>, label=<label>] introduction, at the highest        %
%     level used, starts the arabic page numbering; label intro:                    %
% \mytableofcontents(*)[<label>] label toc:                                         %
% \mylistoffigures(*)[<label>], \mylistoftables(*), \mylistofprograms(*),           %
% \mylistofequations(*) labels lof:, lot:, lop:, loe:                               %
% *: no line in the table of contents (\myintroduction*: also unnumbered).          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\cs_new_protected:Npn \__myreport_front_pagenumbering: {
  \__myreport_set_pagenumbering:n { Roman }
}
% \__myreport_front_anchor:nnn {<word>} {<label prefix>} {<label or NoValue>}
\cs_generate_variant:Nn \mypackage_label_name:nn { nV }
\cs_new_protected:Npn \__myreport_front_anchor:nnn #1#2#3 {
  \mypackage_anchor_name:n {#1}
  \IfNoValueF {#3} {
    \mypackage_label_name:nn {#1} { #2 \c_colon_str #3 }
  }
}
\NewDocumentCommand \myabstract { s o } {
  \__myreport_front_pagenumbering:
  \__myreport_front_heading:n { \myabstractname }
  \__myreport_front_anchor:nnn { myabstract } { abst } {#2}
  \IfBooleanF {#1} {
    \mypackage_add_to_toc:en { \mypackage_highest_level: } { \myabstractname }
  }
}
\NewDocumentCommand \myintroduction { s O{} } {
  \bool_set_false:N \l__myreport_section_number_bool
  \bool_set_false:N \l__myreport_section_label_bool
  \keys_set:nn { myreport / section } {#2}
  \__myreport_set_pagenumbering:n { arabic }
  \exp_args:Ne \__myreport_introduction:nn { \mypackage_highest_level: } {#1}
}
\cs_new_protected:Npn \__myreport_introduction:nn #1#2 {
  \IfBooleanTF {#2} {
    \__myreport_heading_any:nnn {#1} { } { \myintroductionname }
  } {
    \bool_if:NT \l__myreport_section_number_bool {
      \setcounter { my #1 } { \l__myreport_section_number_tl }
    }
    \tl_set:Nn \l__myreport_section_name_tl { \mypartname }
    \__myreport_section_numtext:n {#1}
    \__myreport_heading_any:nVn {#1} \l__myreport_section_numtext_tl { \myintroductionname }
  }
  \mypackage_anchor_name:n { myintroduction }
  \bool_if:NT \l__myreport_section_label_bool {
    \tl_set:Ne \l__myreport_section_fulllabel_tl {
      intro \c_colon_str \exp_not:V \l__myreport_section_label_tl
    }
    \mypackage_label_name:nV { myintroduction } \l__myreport_section_fulllabel_tl
  }
  \IfBooleanF {#2} {
    \mypackage_add_to_toc:nn {#1} {
      \use:c { my #1 box } [l] { \l__myreport_section_numtext_tl }
      \hspace { 1em } \myintroductionname
    }
  }
}
% \begingroup Improve
% Make page numbering appear after \clearpage
% Make it work with \__myreport_listof
\NewDocumentCommand \mytableofcontents { s o } {
  \__myreport_front_pagenumbering:
  \group_begin:
    \clearpage
    \cs_set_eq:NN \\ \space
    \__myreport_front_heading:n { \mycontentsname }
    \__myreport_front_anchor:nnn { mycontents } { toc } {#2}
    \addvspace { 20pt }
    \@starttoc { mytoc }
    \IfBooleanF {#1} {
      \mypackage_add_to_toc:en { \mypackage_highest_level: } { \mycontentsname }
    }
  \group_end:
  \clearpage
}
% \begingroup Idea
% Make mylof and lof not needed by getting them through a list
\cs_new_protected:Npn \__myreport_listof:nnnnn #1#2#3#4#5 {
  \clearpage
  \__myreport_front_pagenumbering:
  \__myreport_front_heading:n { \use:c { #3 name } }
  \__myreport_front_anchor:nnn {#3} {#5} {#2}
  \addvspace { 20pt }
  \@starttoc {#4}
  \IfBooleanF {#1} {
    \mypackage_add_to_toc:ee { \mypackage_highest_level: } { \exp_not:c { #3 name } }
  }
  \clearpage
}
\cs_generate_variant:Nn \mypackage_add_to_toc:nn { ee }
\NewDocumentCommand \mylistoffigures { s o } {
  \__myreport_listof:nnnnn {#1} {#2} { mylistfigure } { mylof } { lof }
}
\NewDocumentCommand \mylistoftables { s o } {
  \__myreport_listof:nnnnn {#1} {#2} { mylisttable } { mylot } { lot }
}
\NewDocumentCommand \mylistofprograms { s o } {
  \__myreport_listof:nnnnn {#1} {#2} { mylistprogram } { mylop } { lop }
}
\NewDocumentCommand \mylistofequations { s o } {
  \__myreport_listof:nnnnn {#1} {#2} { mylistequation } { myloe } { loe }
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% TABLE OF CONTENTS LINES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \l@my<level>(*){<text>}{<page>}: a line of the TOC, indented by 1em for each      %
% level used above it (* : no indent, no extra space). Lines of the lists           %
% (\l@myfigure, ...) are unindented section lines "<Word> <number> <text>".         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\dim_new:N \l__myreport_toc_indent_dim
\cs_new_protected:Npn \__myreport_toc_line:nnnnnnn #1#2#3#4#5#6#7 {
  \group_begin:
    \dim_zero:N \l__myreport_toc_indent_dim
    \IfBooleanF {#1} {
      \clist_map_inline:Nn \c_mypackage_levels_clist {
        \str_if_eq:nnT {##1} {#4} { \clist_map_break: }
        \mypackage_if_level_used:nT {##1} {
          \dim_add:Nn \l__myreport_toc_indent_dim { 1em }
        }
      }
    }
    \setlength { \parindent } { 0cm }
    #5
    \addvspace { 5pt }
    \tl_if_empty:nF {#6} { \IfBooleanF {#1} { \addvspace {#6} } }
    \noindent
    \setlength { \rightskip } { 2em }
    \setlength { \parfillskip } { -2em }
    \hyperlink { \Hy@tocdestname } {
      \hspace { \l__myreport_toc_indent_dim }
      \hangindent = \l__myreport_toc_indent_dim
      \hangafter = 1
      #2
      \nobreak
      \leavevmode
      \bool_lazy_or:nnTF {
        \str_if_eq_p:nn {#7} { always }
      } {
        \mypackage_if_above_used_p:n {#4}
      } {
        \mypackage_dotfill:
      } {
        \hfill
      }
      \nobreak
      #3
    }
    \par
  \group_end:
}
\NewDocumentCommand \l@mypart { s m m } {
  \__myreport_toc_line:nnnnnnn {#1} {#2} {#3} { part } { \bfseries \large } { 20pt } { above }
}
\NewDocumentCommand \l@mychapter { s m m } {
  \__myreport_toc_line:nnnnnnn {#1} {#2} {#3} { chapter } { \bfseries \normalsize } { 10pt } { above }
}
\NewDocumentCommand \l@mysection { s m m } {
  \__myreport_toc_line:nnnnnnn {#1} {#2} {#3} { section } { \normalsize } { } { above }
}
\NewDocumentCommand \l@mysubsection { s m m } {
  \__myreport_toc_line:nnnnnnn {#1} {#2} {#3} { subsection } { \normalsize } { } { always }
}
\NewDocumentCommand \l@mysubsubsection { s m m } {
  \__myreport_toc_line:nnnnnnn {#1} {#2} {#3} { subsubsection } { \normalsize } { } { always }
}
\NewDocumentCommand \l@myfigure { m m } {
  \l@mysection* { \myfigurename \space #1 } {#2}
}
\NewDocumentCommand \l@mytable { m m } {
  \l@mysection* { \mytablename \space #1 } {#2}
}
\NewDocumentCommand \l@myequation { m m } {
  \l@mysection* { \myequationname \space #1 } {#2}
}
\NewDocumentCommand \l@myprogram { m m } {
  \l@mysection* { \myprogramname \space #1 } {#2}
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% BIBLIOGRAPHY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \mybibliography(*)[<label>]: the bibliography at the front-matter level           %
% (part, chapter or section), the entries of no category first, then one            %
% heading per category of mypackage, one level below. *: no TOC lines.              %
% Biblatex headings myreport/<level> (unnumbered) and myreport/<level>/toc          %
% (unnumbered, with a TOC line).                                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \__myreport_bib_heading:nnn {<level>} {<in TOC: true/false>} {<title>}
\cs_new_protected:Npn \__myreport_bib_heading:nnn #1#2#3 {
  \__myreport_heading_any:nnn {#1} { } {#3}
  \mypackage_anchor_name:n {#3}
  \bool_if:nT {#2} { \mypackage_add_to_toc:nn {#1} {#3} }
  \markboth {#3} {#3}
}
\clist_map_inline:Nn \c_mypackage_levels_clist {
  \defbibheading { myreport / #1 } [ \mybibname ] {
    \__myreport_bib_heading:nnn {#1} { \c_false_bool } {##1}
  }
  \defbibheading { myreport / #1 / toc } [ \mybibname ] {
    \__myreport_bib_heading:nnn {#1} { \c_true_bool } {##1}
  }
}
% \begingroup Idea
% Make it a package list
\prop_const_from_keyval:Nn \c__myreport_level_below_prop {
  part = chapter,
  chapter = section,
  section = subsection
}
\tl_new:N \l__myreport_bib_level_tl
\tl_new:N \l__myreport_bib_toc_tl
\NewDocumentCommand \mybibliography { s o } {
  \bool_set_true:N \l_mypackage_bibliography_bool
  \clearpage
  % \begingroup Why??
  % Use \__myreport_set_pagenumbering ??
  \mypackage_if_pagenumbering:nF { Roman } { \newpage \pagenumbering { roman } }
  \mypackage_anchor_name:n { mybib }
  \IfNoValueF {#2} { \mypackage_label_name:nn { mybib } { bib \c_colon_str #2 } }
  \tl_set:Ne \l__myreport_bib_level_tl { \__myreport_front_level: }
  \IfBooleanTF {#1} {
    \tl_clear:N \l__myreport_bib_toc_tl
    \__myreport_bib_heading:Vnn \l__myreport_bib_level_tl { \c_false_bool } { \mybibname }
  } {
    \tl_set:Nn \l__myreport_bib_toc_tl { / toc }
    \__myreport_bib_heading:Vnn \l__myreport_bib_level_tl { \c_true_bool } { \mybibname }
  }
  \printbibliography [ heading = none , filter = mypackage/none ]
  \seq_map_inline:Nn \g_mypackage_bib_categories_seq {
    \use:e {
      \exp_not:N \printbibliography [
        heading = myreport / \prop_item:NV \c__myreport_level_below_prop \l__myreport_bib_level_tl \l__myreport_bib_toc_tl,
        filter = mypackage / ##1,
        title = { \mypackage_bib_category_name:n {##1} },
      ]
    }
  }
  \bool_set_false:N \l_mypackage_bibliography_bool
}
\cs_generate_variant:Nn \__myreport_bib_heading:nnn { V }
\cs_generate_variant:Nn \prop_item:Nn { NV }
\ExplSyntaxOff
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

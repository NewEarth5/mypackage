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
  2026/10/11 V0.6.5 %                              % - Version (the space before %  %
  Custom Report Class by Alexandre Lindsey%        %   ends the version number)     %
]                                                  %                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% ESSENTIAL PACKAGES %%%%%%%%%%%%%%%%%%%%%%%%%%%% DESCRIPTION %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{xstring}                           % String manipulation tools      %
\RequirePackage{kvoptions}                         % Better package/class options   %
\RequirePackage{kvsetkeys}                         % Better suboptions              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% PACKAGE OPTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DESCRIPTION %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\SetupKeyvalOptions{%                              % Setup for main class options   %
  family=myreport,%                                % - Class family name            %
  prefix=myreport@%                                % - Class prefix name            %
}                                                  %                                %
\DeclareStringOption{%                             % Text formatting options        %
  text%                                            % - Name of the option           %
}                                                  %                                %
\DeclareStringOption{%                             % Paths to folders & files       %
  paths%                                           % - Name of the option           %
}                                                  %                                %
\DeclareStringOption[%                             % Position default options       %
  h%                                               % - Initial value                %
]{%                                                %                                %
  position%                                        % - Name of the option           %
}                                                  %                                %
\DeclareStringOption{%                             % Sectionning options            %
  sectioning%                                      % - Name of the option           %
}                                                  %                                %
\DeclareStringOption{%                             % TOC depth                      %
  toc%                                             % - Name of the option           %
}                                                  %                                %
\ProcessKeyvalOptions*                             % Processes the options          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% PACKAGE SUB-OPTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%% DESCRIPTION %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\SetupKeyvalOptions{%                              % Setup for "text" options       %
  family=myreporttext,%                            % - "text" family name           %
  prefix=myreport@text@%                           % - "text" prefix name           %
}                                                  %                                %
\DeclareStringOption[%                             % Font size                      %
  10pt%                                            % - Initial value                %
]{%                                                %                                %
  fontsize%                                        % - Name of the option           %
}                                                  %                                %
\DeclareStringOption[%                             % Font family                    %
  cmr%                                             % - Initial value                %
]{%                                                %                                %
  fontfamily%                                      % - Name of the option           %
}                                                  %                                %
\DeclareStringOption[%                             % Text language                  %
  british%                                         % - Initial value                %
]{%                                                %                                %
  lang%                                            % - Name of the option           %
}                                                  %                                %
\SetupKeyvalOptions{%                              % Setup for "sectioning" options %
  family=myreportsect,%                            % - "sectioning" family name     %
  prefix=myreport@sect@%                           % - "sectioning" prefix name     %
}                                                  %                                %
\DeclareStringOption[%                             % Part sectioning                %
  break%                                           % - Initial value                %
]{%                                                %                                %
  part%                                            % - Name of the option           %
}                                                  %                                %
\DeclareStringOption[%                             % Chapter sectioning             %
  break%                                           % - Initial value                %
]{%                                                %                                %
  chapter%                                         % - Name of the option           %
}                                                  %                                %
\DeclareStringOption[%                             % Section sectioning             %
  nobreak%                                         % - Initial value                %
]{%                                                %                                %
  section%                                         % - Name of the option           %
}                                                  %                                %
\DeclareStringOption[%                             % Subsection sectioning          %
  nobreak%                                         % - Initial value                %
]{%                                                %                                %
  subsection%                                      % - Name of the option           %
}                                                  %                                %
\DeclareStringOption[%                             % Subsubsection sectioning       %
  nobreak%                                         % - Initial value                %
]{%                                                %                                %
  subsubsection%                                   % - Name of the option           %
}                                                  %                                %
\DeclareStringOption[%                             % Annex sectioning               %
  break%                                           % - Initial value                %
]{%                                                %                                %
  annex%                                           % - Name of the option           %
}                                                  %                                %
\DeclareStringOption[%                             % Bibliography sectioning        %
  break%                                           % - Initial value                %
]{%                                                %                                %
  bib%                                             % - Name of the option           %
}                                                  %                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% PACKAGE OPTIONS PROCESSING %%%%%%%%%%%%%%%%%%%%%% DESCRIPTION %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\ifx\myreport@text\@empty                          % Text sub-options               %
\else                                              %                                %
  \kvsetkeys@expandafter{%                         %                                %
    myreporttext%                                  %                                %
  }{%                                              %                                %
    \myreport@text%                                %                                %
  }                                                %                                %
\fi                                                %                                %
\ifx\myreport@sectioning\@empty                    % Sectioning sub-options         %
\else                                              %                                %
  \IfSubStr{\myreport@sectioning}{=}{              %                                %
    \kvsetkeys@expandafter{%                       %                                %
      myreportsect%                                %                                %
    }{%                                            %                                %
      \myreport@sectioning%                        %                                %
    }                                              %                                %
  }{                                               %                                %
    \expandafter\def                               %                                %
    \csname myreport@sect@part\endcsname{%         %                                %
      \myreport@sectioning%                        %                                %
    }                                              %                                %
    \expandafter\def                               %                                %
    \csname myreport@sect@chapter\endcsname{%      %                                %
      \myreport@sectioning%                        %                                %
    }                                              %                                %
    \expandafter\def                               %                                %
    \csname myreport@sect@section\endcsname{%      %                                %
      \myreport@sectioning%                        %                                %
    }                                              %                                %
    \expandafter\def                               %                                %
    \csname myreport@sect@subsection\endcsname{%   %                                %
      \myreport@sectioning%                        %                                %
    }                                              %                                %
    \expandafter\def                               %                                %
    \csname myreport@sect@subsubsection\endcsname{%%                                %
      \myreport@sectioning%                        %                                %
    }                                              %                                %
    \expandafter\def                               %                                %
    \csname myreport@sect@annex\endcsname{%        %                                %
      \myreport@sectioning%                        %                                %
    }                                              %                                %
    \expandafter\def                               %                                %
    \csname myreport@sect@bib\endcsname{%          %                                %
      \myreport@sectioning%                        %                                %
    }                                              %                                %
  }                                                %                                %
\fi                                                %                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% CLASS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DESCRIPTION %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\LoadClass[%                                       % Base class                     %
  a4paper,%                                        % - Page size                    %
  \myreport@text@fontsize%                         % - Font size                    %
]{report}                                          %                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% REQUIRED PACKAGES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DESCRIPTION %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage[                                   % My custom package              %
  lang={\myreport@text@lang},                      % - Language option              %
  paths={\myreport@paths},                         % - Folder paths                 %
  position={\myreport@position},                   % - Figures/tables/... position  %
  toc={\myreport@toc},                             % - TOC options                    %
]{mypackage}                                       %                                %
\RequirePackage{amsmath}                           % Advanced math formulas         %
\RequirePackage{amsfonts}                          % Extra math fonts and symbols   %
\RequirePackage{amssymb}                           % More math symbols and fonts    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% FONTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DESCRIPTION %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\ExplSyntaxOn
  \str_case_e:nn{\myreport@text@fontfamily}{
    {cmr}{
    }
    {lmr}{
      \RequirePackage{lmodern}
    }
    {lmdh}{
      \RequirePackage{lmodern}
    }
    {qtm}{
      \RequirePackage{tgtermes}
    }
    {qpl}{
      \RequirePackage{tgpagella}
    }
    {qbk}{
      \RequirePackage{tgbonum}
    }
    {qcs}{
      \RequirePackage{tgschola}
    }
    {ptm}{
      \RequirePackage{mathptmx}
    }
    {put}{
      \RequirePackage{utopia}
    }
    {ppl}{
      \RequirePackage{palatino}
    }
    {pbk}{
      \RequirePackage{bookman}
    }
    {bch}{
      \RequirePackage{charter}
    }
    {cmss}{
    }
    {lmss}{
      \RequirePackage{lmodern}
    }
    {qag}{
      \RequirePackage{tgadventor}
    }
    {qhv}{
      \RequirePackage{tgheros}
    }
    {phv}{
      \RequirePackage{helvet}
    }
    {cmtt}{
    }
    {lmtt}{
      \RequirePackage{lmodern}
    }
    {qcr}{
      \RequirePackage{tgcursor}
    }
    {pcr}{
      \RequirePackage{courier}
    }
  }
\ExplSyntaxOff
\IfStrEq{\myreport@text@fontfamily}{cmr}{}{%       % Default family of the document %
  \renewcommand{\familydefault}{%                  % (used by \normalfont, so also  %
    \myreport@text@fontfamily%                     % in captions, footnotes, ...);  %
  }%                                               % left alone for cmr, so that    %
}                                                  % fontspec's main font works     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% CUSTOM COMMANDS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\myclearpage}[2]{%
  \edef\mysavedtext{#2}%
  \ifMyannexUsed%
    \IfStrEq{\myreport@sect@annex}{nobreak}{%
      \def\mysavedtext{nobreak}%
    }{}%
  \fi%
  \ifMybibUsed%
    \IfStrEq{\myreport@sect@bib}{nobreak}{%
      \def\mysavedtext{nobreak}%
    }{}%
  \fi%
  \IfStrEq{\mysavedtext}{nobreak}{%
    \ifMyannexUsed%
      \IfStrEq{#1}{\myhighestsec}{%
        \clearpage%
      }{%
        \par%
      }%
    \else%
      \par%
    \fi%
  }{%
    \IfStrEq{#1}{mypart}{%
      \cleardoublepage%
    }{\IfStrEq{#1}{mychapter}{%
      \ifGlobalMypartUsed%
        \clearpage%
      \else%
        \cleardoublepage%
      \fi%
    }{\IfStrEq{#1}{mysection}{%
      \ifGlobalMypartUsed%
        \clearpage%
      \else%
        \ifGlobalMychapterUsed%
          \clearpage%
        \else%
          \cleardoublepage%
        \fi%
      \fi%
    }{\IfStrEq{#1}{mysubsection}{%
      \ifGlobalMypartUsed%
        \clearpage%
      \else%
        \ifGlobalMychapterUsed%
          \clearpage%
        \else%
          \ifGlobalMysectionUsed%
            \clearpage%
          \else%
            \cleardoublepage%
          \fi%
        \fi%
      \fi%
    }{\IfStrEq{#1}{mysubsubsection}{%
      \ifGlobalMypartUsed%
        \clearpage%
      \else%
        \ifGlobalMychapterUsed%
          \clearpage%
        \else%
          \ifGlobalMysectionUsed%
            \clearpage%
          \else%
            \ifGlobalMysubsectionUsed%
              \clearpage%
            \else%
              \cleardoublepage%
            \fi%
          \fi%
        \fi%
      \fi%
    }{%
      \pagebreak%
    }}}}}%
  }
}
\NewDocumentCommand{\mycourse}{s m o}{%
  \def\mycourseval{%
    #2%
  }%
  \IfNoValueF{#3}{%
    \IfBlankF{#3}{%
      \def\mycourseidval{%
        #3%
      }%
    }%
  }%
  \IfBooleanTF{#1}{%
    \def\mycoursestarval{true}%
  }{%
    \def\mycoursestarval{false}%
  }%
}
\ExplSyntaxOn
  \NewDocumentCommand{\myaddprofessor}{s m m}{%
    \str_if_eq:VnTF\myprofessorval{-NoValue-}{%
      \gdef\myprofessorval{\textsc{#2}\space#3}%
      \gdef\myprofessortabval{\textsc{#2}\space#3}%
      \IfBooleanTF{#1}{%
        \gdef\myprofessorgenderval{f}%
      }{%
        \gdef\myprofessorgenderval{m}%
      }%
    }{%
      \g@addto@macro\myprofessorval{\space\&\space\textsc{#2}\space#3}%
      \g@addto@macro\myprofessortabval{&\textsc{#2}\space#3}%
      \IfBooleanTF{#1}{%
        \g@addto@macro\myprofessorgenderval{,f}%
      }{%
        \g@addto@macro\myprofessorgenderval{,m}%
      }%
    }%
  }
\ExplSyntaxOff
\ExplSyntaxOn
  \NewDocumentCommand{\myaddassistant}{s m m}{%
    \str_if_eq:VnTF\myassistantval{-NoValue-}{%
      \gdef\myassistantval{\textsc{#2}\space#3}%
      \gdef\myassistanttabval{\textsc{#2}\space#3}%
      \IfBooleanTF{#1}{%
        \gdef\myassistantgenderval{f}%
      }{%
        \gdef\myassistantgenderval{m}%
      }%
    }{%
      \g@addto@macro\myassistantval{\space\&\space\textsc{#2}\space#3}%
      \g@addto@macro\myassistanttabval{&\textsc{#2}\space#3}%
      \IfBooleanTF{#1}{%
        \g@addto@macro\myassistantgenderval{,f}%
      }{%
        \g@addto@macro\myassistantgenderval{,m}%
      }%
    }%
  }
\ExplSyntaxOff
\NewDocumentCommand{\myacademicyear}{m}{%
  \def\myacademicyearval{#1}%
}
\NewDocumentCommand{\mytitle}{s m}{%
  \IfBooleanTF{#1}{%
    \def\mytitlestarval{true}%
  }{%
    \def\mytitlestarval{false}%
  }%
  \def\mytitleval{#2}%
}
\NewDocumentCommand{\mysubtitle}{m}{%
  \def\mysubtitleval{#1}%
}
\NewDocumentCommand{\myimage}{O{width=1} m}{%
  \def\myimageval{\myinclude[#1]{#2}}%
}
\NewDocumentCommand{\mylogo}{O{height=0.035} m}{%
  \def\mylogoval{\myinclude[#1]{#2}}%
}
\NewDocumentCommand{\mydate}{m}{%
  \def\mydateval{#1}%
}
\ExplSyntaxOn
  \NewDocumentCommand{\myaddauthor}{s m m O{}}{%
    \str_if_eq:VnTF\myauthorval{-NoValue-}{%
      \gdef\myauthorval{\textsc{#2}\space#3}%
      \gdef\myauthortabval{\textsc{#2}\space#3}%
      \gdef\myauthoridval{#4}%
      \gdef\myauthoridtabval{#4}%
      \IfBooleanTF{#1}{%
        \gdef\myauthorgenderval{f}%
      }{%
        \gdef\myauthorgenderval{m}%
      }%
    }{%
      \g@addto@macro\myauthorval{\space\&\space\textsc{#2}\space#3}%
      \g@addto@macro\myauthortabval{&\textsc{#2}\space#3}%
      \g@addto@macro\myauthoridval{\space\&\space#4}%
      \g@addto@macro\myauthoridtabval{&#4}%
      \IfBooleanTF{#1}{%
        \g@addto@macro\myauthorgenderval{,f}%
      }{%
        \g@addto@macro\myauthorgenderval{,m}%
      }%
    }%
  }
\ExplSyntaxOff
\ExplSyntaxOn
  \seq_new:N{\l_mymaketitle_authname_seq}
  \seq_new:N{\l_mymaketitle_authid_seq}
  \seq_new:N{\l_mymaketitle_auth_seq}
  \NewDocumentCommand{\mymaketitle}{s O{1}}{%
    \hypersetup{pageanchor=false}%
    \IfBooleanF{#1}{%
      \newgeometry{margin=1cm}%
    }%
    \str_case_e:nn{#2}{%
      {1}{%
        \begin{titlepage}%
          \setlength{\parindent}{0cm}%
          \begin{tabularx}{\textwidth}{>{\raggedright\arraybackslash}X >{\raggedleft\arraybackslash}X}%
            \str_if_eq:VnF{\mycourseval}{-NoValue-}{%
              \textbf{%
                \textsc{\mycourseval}%
              }%
            }%
            \str_if_eq:VnF{\mycourseidval}{-NoValue-}{%
              \str_if_eq:VnTF{\mycoursestarval}{-NoValue-}{%
                \textbf{%
                  \textsc{\space[\mycourseidval]}%
                }%
              }{%
                \str_if_eq:VnTF{\mycoursestarval}{false}{%
                  \textbf{%
                    \space\cite{\mycourseidval}%
                  }%
                }{%
                  \textbf{%
                    \textsc{\space[\mycourseidval]}%
                  }%
                }%
              }%
            }%
            &%
            \str_if_eq:VnF{\myprofessorgenderval}{-NoValue-}{%
              \str_if_eq:VnTF{\myprofessorgenderval}{m}{%
                \textbf{\myprofessormname}%
              }{%
                \str_if_eq:VnTF{\myprofessorgenderval}{f}{%
                  \textbf{\myprofessorfname}%
                }{%
                  \regex_match:nVTF{^[f,]*$}{\myprofessorgenderval}{%
                    \textbf{\myprofessorfpname}%
                  }{%
                    \textbf{\myprofessormpname}%
                  }%
                }%
              }%
              \textbf{%
                :\space%
              }%
            }%
            \str_if_eq:VnF{\myprofessorval}{-NoValue-}{%
              \myprofessorval%
            }%
          \end{tabularx}%
          \vspace{2pt}%
          \hrule height 4pt width \hsize%
          \vspace{-2pt}%
          \begin{tabularx}{\textwidth}{c >{\raggedleft\arraybackslash}X}%
            &%
            \str_if_eq:VnF{\myacademicyearval}{-NoValue-}{%
              \textbf{\textsc{\myacyearname\c_colon_str\space}}%
              \textsc{\myacademicyearval}%
            }%
          \end{tabularx}%
          \vspace{0.05\textheight}%
          \vspace*{\fill}%
          \begin{center}%
            \str_if_eq:VnF{\mytitleval}{-NoValue-}{%
              \str_if_eq:VnTF{\mytitlestarval}{true}{%
                \textbf{%
                  \Huge%
                  \mytitleval%
                }%
              }{%
                \textbf{%
                  \Huge%
                  \underline{\mytitleval}%
                }%
              }%
            }%
            \str_if_eq:VnF{\mysubtitleval}{-NoValue-}{%
              \textbf{%
                \textsc{%
                  \\[0.015\textheight]%
                  \LARGE%
                  \textcolor{darkgray}{\mysubtitleval}%
                }%
              }%
            }%
          \end{center}%
          \str_if_eq:VnF{\myimageval}{-NoValue-}{%
            \begin{center}%
              \vspace{0.05\textheight}%
              \myimageval%
              \vspace{0.05\textheight}%
            \end{center}%
          }%
          \vspace*{\fill}%
          \begin{tabularx}{\textwidth}{c >{\raggedleft\arraybackslash}X}%
            \str_if_eq:VnF{\mylogoval}{-NoValue-}{%
              \adjustbox{valign=b}{\mylogoval}%
            }%
            &%
            \str_if_eq:VnF{\mydateval}{-NoValue-}{%
              \textbf{\mydateval}%
            }%
          \end{tabularx}%
          \vspace{2pt}%
          \hrule height 4pt width \hsize%
          \vspace{-2pt}%
          \begin{center}%
            \str_if_eq:VnF{\myauthorval}{-NoValue-}{%
              \textbf{%
                \seq_set_split:NnV{\l_tmpa_seq}{&}{\myauthortabval}%
                \begin{tabular}{*{\int_eval:n{\seq_count:N \l_tmpa_seq}}{>{\centering\arraybackslash}p{\fp_eval:n{0.8 / \seq_count:N \l_tmpa_seq}\textwidth}}}%
                  \myauthortabval \\%
                  \myauthoridtabval%
                \end{tabular}%
              }%
            }%
          \end{center}%
        \end{titlepage}%
      }%
      {2}{%
        \begin{titlepage}%
          \setlength{\parindent}{0cm}%
          \begin{tabularx}{\textwidth}{>{\raggedright\arraybackslash}X r}%
            \str_if_eq:VnF{\mycourseval}{-NoValue-}{%
              \textbf{%
                \textsc{\mycourseval}%
              }%
            }%
            \str_if_eq:VnF{\mycourseidval}{-NoValue-}{%
              \str_if_eq:VnTF{\mycoursestarval}{-NoValue-}{%
                \textbf{%
                  \textsc{\space[\mycourseidval]}%
                }%
              }{%
                \str_if_eq:VnTF{\mycoursestarval}{false}{%
                  \textbf{%
                    \space\cite{\mycourseidval}%
                  }%
                }{%
                  \textbf{%
                    \textsc{\space[\mycourseidval]}%
                  }%
                }%
              }%
            }%
            &%
            \str_if_eq:VnF{\mylogoval}{-NoValue-}{%
              \adjustbox{valign=t}{\mylogoval}%
            }%
          \end{tabularx}%
          \vspace*{\fill}%
          \hrule height 1.5pt width \hsize%
          \vspace{8pt}%
          \begin{center}%
            \str_if_eq:VnF{\mytitleval}{-NoValue-}{%
              \str_if_eq:VnTF{\mytitlestarval}{true}{%
                \textbf{%
                  \Huge%
                  \mytitleval%
                }%
              }{%
                \textbf{%
                  \Huge%
                  \underline{\mytitleval}%
                }%
              }%
            }%
            \str_if_eq:VnF{\mysubtitleval}{-NoValue-}{%
              \textbf{%
                \textsc{%
                  \\[0.015\textheight]%
                  \LARGE%
                  \textcolor{darkgray}{\mysubtitleval}%
                }%
              }%
            }%
          \end{center}%
          \vspace{16pt}%
          \hrule height 1.5pt width \hsize%
          \str_if_eq:VnF{\myimageval}{-NoValue-}{%
            \begin{center}%
              \vspace{0.05\textheight}%
              \myimageval%
              \vspace{0.05\textheight}%
            \end{center}%
          }%
          \vspace*{\fill}%
          \par%
          \seq_set_split:NnV{\l_tmpa_seq}{&}{\myprofessortabval}%
          \seq_set_split:NnV{\l_tmpb_seq}{&}{\myassistanttabval}%
          \seq_set_split:NnV{\l_mymaketitle_authname_seq}{&}{\myauthortabval}%
          \seq_set_split:NnV{\l_mymaketitle_authid_seq}{&}{\myauthoridtabval}%
          \seq_clear:N{\l_mymaketitle_auth_seq}%
          \int_step_inline:nnn{1}{\int_eval:n{\seq_count:N{\l_mymaketitle_authname_seq}}}{%
            \tl_if_blank:eTF{\seq_item:Nn{\l_mymaketitle_authid_seq}{##1}}{%
              \seq_put_right:Nn{\l_mymaketitle_auth_seq}{%
                \seq_item:Nn{\l_mymaketitle_authname_seq}{##1}%
              }%
            }{%
              \seq_put_right:Nn{\l_mymaketitle_auth_seq}{%
                \seq_item:Nn{\l_mymaketitle_authname_seq}{##1}\space(\seq_item:Nn{\l_mymaketitle_authid_seq}{##1})%
              }%
            }%
          }%
          \hspace{45pt}%
          \bool_lazy_and:nnF{\str_if_eq_p:Vn{\myprofessorval}{-NoValue-}}{\str_if_eq_p:Vn{\myassistantval}{-NoValue-}}{%
            \begin{tabular}[t]{l|l}%
              \str_if_eq:VnF{\myprofessorgenderval}{-NoValue-}{%
                \str_if_eq:VnTF{\myprofessorgenderval}{m}{%
                  \textbf{\myprofessormname}%
                }{%
                  \str_if_eq:VnTF{\myprofessorgenderval}{f}{%
                    \textbf{\myprofessorfname}%
                  }{%
                    \regex_match:nVTF{^[f,]*$}{\myprofessorgenderval}{%
                      \textbf{\myprofessorfpname}%
                    }{%
                      \textbf{\myprofessormpname}%
                    }%
                  }%
                }%
              }%
              \str_if_eq:VnF{\myprofessorval}{-NoValue-}{%
                &\seq_use:Nn{\l_tmpa_seq}{\\&}\\%
              }%
              \str_if_eq:VnF{\myassistantgenderval}{-NoValue-}{%
                \str_if_eq:VnTF{\myassistantgenderval}{m}{%
                  \textbf{\myassistantmname}%
                }{%
                  \str_if_eq:VnTF{\myassistantgenderval}{f}{%
                    \textbf{\myassistantfname}%
                  }{%
                    \regex_match:nVTF{^[f,]*$}{\myassistantgenderval}{%
                      \textbf{\myassistantfpname}%
                    }{%
                      \textbf{\myassistantmpname}%
                    }%
                  }%
                }%
              }%
              \str_if_eq:VnF{\myassistantval}{-NoValue-}{%
                &\seq_use:Nn{\l_tmpb_seq}{\\&}%
              }%
            \end{tabular}%
          }%
          \hspace{\fill}%
          \str_if_eq:VnF{\myauthorval}{-NoValue-}{%
            \begin{tabular}[t]{l|l}%
              \str_if_eq:VnF{\myauthorgenderval}{-NoValue-}{%
                \str_if_eq:VnTF{\myauthorgenderval}{m}{%
                  \textbf{\myauthormname}%
                }{%
                  \str_if_eq:VnTF{\myauthorgenderval}{f}{%
                    \textbf{\myauthorfname}%
                  }{%
                    \regex_match:nVTF{^[f,]*$}{\myauthorgenderval}{%
                      \textbf{\myauthorfpname}%
                    }{%
                      \textbf{\myauthormpname}%
                    }%
                  }%
                }%
              }%
              \str_if_eq:VnF{\myauthorval}{-NoValue-}{%
                &\seq_use:Nn{\l_mymaketitle_auth_seq}{\\&}%
              }%
            \end{tabular}%
          }%
          \hspace*{45pt}%
          \\[25pt]%
          \begin{tabularx}{\textwidth}{>{\raggedright\arraybackslash}X r}%
            \str_if_eq:VnF{\myacademicyearval}{-NoValue-}{%
              \textbf{\textsc{\myacyearname\c_colon_str\space}}%
              \textsc{\myacademicyearval}%
            }%
            &%
            \str_if_eq:VnF{\mydateval}{-NoValue-}{%
              \textbf{\mydateval}%
            }%
          \end{tabularx}%
        \end{titlepage}%
      }%
    }%
    \IfBooleanF{#1}{%
      \restoregeometry%
    }%
    \hypersetup{pageanchor=true}%
  }
\ExplSyntaxOff
\ExplSyntaxOn
  \tl_new:N{\l_mypartheading_sectioning_tl}
  \tl_new:N{\l_mypartheading_name_tl}
  \bool_new:N{\l_mypartheading_nameUsed_bool}
  \keys_define:nn{mypartheading}{%
    number.code:n = {%
      \setcounter{mypart}{#1}%
    },%
    name.code:n = {%
      \bool_set_true:N{\l_mypartheading_nameUsed_bool}%
      \tl_set:Nn{\l_mypartheading_name_tl}{#1}%
    },%
    sectioning.tl_set:N = \l_mypartheading_sectioning_tl,%
    sectioning.initial:n = \myreport@sect@part,%
  }
  \NewDocumentCommand{\mypartheading}{s O{} m}{%
    \bool_set_false:N{\l_mypartheading_nameUsed_bool}%
    \keys_set:nn{mypartheading}{%
      name=\mypartname,%
      #2%
    }%
    \begingroup%
      \vspace{3em}%
      \myclearpage{mypart}{\l_mypartheading_sectioning_tl}%
      \setlength{\parindent}{0cm}%
      \vspace{-2em}%
      \centering\bfseries\itshape\Huge%
      \IfBooleanF{#1}{%
        \l_mypartheading_name_tl \c_space_token \themypart \\%
      }%
      \vspace{-0.5em}%
      \rule{\textwidth}{1pt}\\%
      #3\\%
      \vspace{-0.5em}%
      \rule{\textwidth}{0.3pt}%
      \vspace{0em}%
      \par%
    \endgroup%
  }
\ExplSyntaxOff
\ExplSyntaxOn
  \tl_new:N{\l_mychapterheading_sectioning_tl}
  \keys_define:nn{mychapterheading}{%
    number.code:n = {%
      \setcounter{mychapter}{#1}%
    },%
    sectioning.tl_set:N = \l_mychapterheading_sectioning_tl,%
    sectioning.initial:n = \myreport@sect@chapter,%
  }
  \NewDocumentCommand{\mychapterheading}{s O{} m}{%
    \keys_set:nn{mychapterheading}{%
      #2%
    }%
    \begingroup%
      \vspace{4em}%
      \myclearpage{mychapter}{\l_mychapterheading_sectioning_tl}%
      \setlength{\parindent}{0cm}%
      \vspace{-3em}%
      \bfseries\LARGE%
      \IfBooleanF{#1}{%
        \themychapter\hspace{1em}%
      }%
      #3\\%
      \vspace{-0.5em}%
      \par%
    \endgroup%
  }
\ExplSyntaxOff
\ExplSyntaxOn
  \tl_new:N{\l_mysectionheading_sectioning_tl}
  \keys_define:nn{mysectionheading}{%
    number.code:n = {%
      \setcounter{mysection}{#1}%
    },%
    sectioning.tl_set:N = \l_mysectionheading_sectioning_tl,%
    sectioning.initial:n = \myreport@sect@section,%
  }
  \NewDocumentCommand{\mysectionheading}{s O{} m}{%
    \keys_set:nn{mysectionheading}{%
      #2%
    }%
    \begingroup%
      \vspace{4em}%
      \myclearpage{mysection}{\l_mysectionheading_sectioning_tl}%
      \setlength{\parindent}{0cm}%
      \vspace{-3em}%
      \bfseries\Large%
      \IfBooleanF{#1}{%
        \themysection\hspace{1em}%
      }%
      #3\\%
      \vspace{-1em}%
      \par%
    \endgroup%
  }
\ExplSyntaxOff
\ExplSyntaxOn
  \tl_new:N{\l_mysubsectionheading_sectioning_tl}
  \keys_define:nn{mysubsectionheading}{%
    number.code:n = {%
      \setcounter{mysubsection}{#1}%
    },%
    sectioning.tl_set:N = \l_mysubsectionheading_sectioning_tl,%
    sectioning.initial:n = \myreport@sect@subsection,%
  }
  \NewDocumentCommand{\mysubsectionheading}{s O{} m}{%
    \keys_set:nn{mysubsectionheading}{%
      #2%
    }%
    \begingroup%
      \vspace{4em}%
      \myclearpage{mysubsection}{\l_mysubsectionheading_sectioning_tl}%
      \setlength{\parindent}{0cm}%
      \vspace{-3em}%
      \bfseries\large%
      \IfBooleanF{#1}{%
        \themysubsection\hspace{1em}%
      }%
      #3\\%
      \vspace{-1em}%
      \par%
    \endgroup%
  }
\ExplSyntaxOff
\ExplSyntaxOn
  \tl_new:N{\l_mysubsubsectionheading_sectioning_tl}
  \keys_define:nn{mysubsubsectionheading}{%
    number.code:n = {%
      \setcounter{mysubsubsection}{#1}%
    },%
    sectioning.tl_set:N = \l_mysubsubsectionheading_sectioning_tl,%
    sectioning.initial:n = \myreport@sect@subsubsection,%
  }
  \NewDocumentCommand{\mysubsubsectionheading}{s O{} m}{%
    \keys_set:nn{mysubsubsectionheading}{%
      #2%
    }%
    \begingroup%
      \vspace{4em}%
      \myclearpage{mysubsubsection}{\l_mysubsubsectionheading_sectioning_tl}%
      \setlength{\parindent}{0cm}%
      \vspace{-3em}%
      \bfseries\normalsize%
      \IfBooleanF{#1}{%
        \themysubsubsection\hspace{1em}%
      }%
      #3\\%
      \vspace{-1em}%
      \par%
    \endgroup%
  }
\ExplSyntaxOff
\ExplSyntaxOn
  \dim_new:N{\l_mypart_space_dim}
  \NewDocumentCommand{\l@mypart}{s m m}{%
    \begingroup%
      \dim_zero:N{\l_mypart_space_dim}%
      \setlength{\parindent}{0cm}%
      \bfseries\large%
      \addvspace{5pt}%
      \noindent%
      \setlength{\rightskip}{2em}%
      \setlength{\parfillskip}{-2em}%
      \hyperlink{\Hy@tocdestname}{%
        \hspace{\l_mypart_space_dim}%
        \hangindent=\l_mypart_space_dim%
        \hangafter=1%
        #2%
        \nobreak%
        \leavevmode%
        \hfill%
        \nobreak%
        #3%
      }%
      \par%
    \endgroup%
  }
\ExplSyntaxOff
\ExplSyntaxOn
  \dim_new:N{\l_mychapter_space_dim}
  \NewDocumentCommand{\l@mychapter}{s m m}{%
    \begingroup%
      \dim_zero:N{\l_mychapter_space_dim}%
      \IfBooleanF{#1}{%
        \ifGlobalMypartUsed%
          \dim_add:Nn{\l_mychapter_space_dim}{1em}%
        \fi%
      }%
      \setlength{\parindent}{0cm}%
      \bfseries\normalsize%
      \addvspace{5pt}%
      \noindent%
      \setlength{\rightskip}{2em}%
      \setlength{\parfillskip}{-2em}%
      \hyperlink{\Hy@tocdestname}{%
        \hspace{\l_mychapter_space_dim}%
        \hangindent=\l_mychapter_space_dim%
        \hangafter=1%
        #2%
        \nobreak%
        \leavevmode%
        \ifGlobalMypartUsed%
          \mydotfill%
        \else%
          \hfill%
        \fi%
        \nobreak%
        #3%
      }%
      \par%
    \endgroup%
  }
\ExplSyntaxOff
\ExplSyntaxOn
  \dim_new:N{\l_mysection_space_dim}
  \NewDocumentCommand{\l@mysection}{s m m}{%
    \begingroup%
      \dim_zero:N{\l_mysection_space_dim}%
      \IfBooleanF{#1}{%
        \ifGlobalMypartUsed%
          \dim_add:Nn{\l_mysection_space_dim}{1em}%
        \fi%
        \ifGlobalMychapterUsed%
          \dim_add:Nn{\l_mysection_space_dim}{1em}%
        \fi%
      }%
      \setlength{\parindent}{0cm}%
      \normalsize%
      \addvspace{5pt}%
      \noindent%
      \setlength{\rightskip}{2em}%
      \setlength{\parfillskip}{-2em}%
      \hyperlink{\Hy@tocdestname}{%
        \hspace{\l_mysection_space_dim}%
        \hangindent=\l_mysection_space_dim%
        \hangafter=1%
        #2%
        \nobreak%
        \leavevmode%
        \ifGlobalMypartUsed%
          \mydotfill%
        \else%
          \ifGlobalMychapterUsed%
            \mydotfill%
          \else%
            \hfill%
          \fi%
        \fi%
        \nobreak%
        #3%
      }%
      \par%
    \endgroup%
  }
\ExplSyntaxOff
\ExplSyntaxOn
  \dim_new:N{\l_mysubsection_space_dim}
  \NewDocumentCommand{\l@mysubsection}{s m m}{%
    \begingroup%
      \dim_zero:N{\l_mysubsection_space_dim}%
      \IfBooleanF{#1}{%
        \ifGlobalMypartUsed%
          \dim_add:Nn{\l_mysubsection_space_dim}{1em}%
        \fi%
        \ifGlobalMychapterUsed%
          \dim_add:Nn{\l_mysubsection_space_dim}{1em}%
        \fi%
        \ifGlobalMysectionUsed%
          \dim_add:Nn{\l_mysubsection_space_dim}{1em}%
        \fi%
      }%
      \setlength{\parindent}{0cm}%
      \normalsize%
      \addvspace{5pt}%
      \noindent%
      \setlength{\rightskip}{2em}%
      \setlength{\parfillskip}{-2em}%
      \hyperlink{\Hy@tocdestname}{%
        \hspace{\l_mysubsection_space_dim}%
        \hangindent=\l_mysubsection_space_dim%
        \hangafter=1%
        #2%
        \nobreak%
        \leavevmode%
        \mydotfill%
        \nobreak%
        #3%
      }%
      \par%
    \endgroup%
  }
\ExplSyntaxOff
\ExplSyntaxOn
  \dim_new:N{\l_mysubsubsection_space_dim}
  \NewDocumentCommand{\l@mysubsubsection}{s m m}{%
    \begingroup%
      \dim_zero:N{\l_mysubsubsection_space_dim}%
      \IfBooleanF{#1}{%
        \ifGlobalMypartUsed%
          \dim_add:Nn{\l_mysubsubsection_space_dim}{1em}%
        \fi%
        \ifGlobalMychapterUsed%
          \dim_add:Nn{\l_mysubsubsection_space_dim}{1em}%
        \fi%
        \ifGlobalMysectionUsed%
          \dim_add:Nn{\l_mysubsubsection_space_dim}{1em}%
        \fi%
        \ifGlobalMysubsectionUsed%
          \dim_add:Nn{\l_mysubsubsection_space_dim}{1em}%
        \fi%
      }%
      \setlength{\parindent}{0cm}%
      \normalsize%
      \addvspace{5pt}%
      \noindent%
      \setlength{\rightskip}{2em}%
      \setlength{\parfillskip}{-2em}%
      \hyperlink{\Hy@tocdestname}{%
        \hspace{\l_mysubsubsection_space_dim}%
        \hangindent=\l_mysubsubsection_space_dim%
        \hangafter=1%
        #2%
        \nobreak%
        \leavevmode%
        \mydotfill%
        \nobreak%
        #3%
      }%
      \par%
    \endgroup%
  }
\ExplSyntaxOff
\NewDocumentCommand{\l@myfigure}{m m}{%
  \l@mysection*{\myfigurename\space#1}{#2}%
}
\NewDocumentCommand{\l@mytable}{m m}{%
  \l@mysection*{\mytablename\space#1}{#2}%
}
\NewDocumentCommand{\l@myequation}{m m}{%
  \l@mysection*{\myequationname\space#1}{#2}%
}
\NewDocumentCommand{\l@myprogram}{m m}{%
  \l@mysection*{\myprogramname\space#1}{#2}%
}
\NewDocumentCommand{\myabstract}{s o}{%
  \IfIsRomanF{\newpage\pagenumbering{Roman}}%
  \ifGlobalMypartUsed%
    \mypartheading*{\myabstractname}%
  \else%
    \ifGlobalMychapterUsed%
      \mychapterheading*{\myabstractname}%
    \else%
      \mysectionheading*{\myabstractname}%
    \fi%
  \fi%
  \myhyperanchor*{myabstract}%
  \IfNoValueF{#2}{%
    \mylabel*{myabstract}{abst:#2}%
  }%
  \IfBooleanF{#1}{%
    \myaddtotoc{\myhighestsec}{\myabstractname}%
  }%
}
\ExplSyntaxOn
  \tl_new:N{\l_myintroduction_number_tl}
  \tl_new:N{\l_myintroduction_label_tl}
  \bool_new:N{\l_myintroduction_numberUsed_bool}
  \bool_new:N{\l_myintroduction_labelUsed_bool}
  \keys_define:nn{myintroduction}{%
    number.code:n = {%
      \bool_set_true:N{\l_myintroduction_numberUsed_bool}%
      \tl_set:Nn{\l_myintroduction_number_tl}{#1}%
    },%
    label.code:n = {%
      \bool_set_true:N{\l_myintroduction_labelUsed_bool}%
      \tl_set:Nn{\l_myintroduction_label_tl}{#1}%
    },%
  }
  \NewDocumentCommand{\myintroduction}{s O{}}{%
    \bool_set_false:N{\l_myintroduction_numberUsed_bool}%
    \bool_set_false:N{\l_myintroduction_labelUsed_bool}%
    \keys_set:nn{myintroduction}{%
      #2%
    }%
    \IfIsarabicF{\newpage\pagenumbering{arabic}}%
    \ifGlobalMypartUsed%
      \IfBooleanTF{#1}{%
        \mypartheading*{\myintroductionname}%
      }{%
        \bool_if:NTF{\l_myintroduction_numberUsed_bool}{%
          \mypartheading[number=\l_myintroduction_number_tl]{\myintroductionname}%
        }{%
          \mypartheading{\myintroductionname}%
        }%
      }%
      \myhyperanchor*{myintroduction}%
      \bool_if:NT{\l_myintroduction_labelUsed_bool}{%
        \mylabel*{myintroduction}{intro:\l_myintroduction_label_tl}%
      }%
      \IfBooleanF{#1}{%
        \myaddtotoc{mypart}{\mypartbox[l]{\mypartname\space\themypart}\hspace{1em}\myintroductionname}%
      }%
    \else%
      \ifGlobalMychapterUsed%
        \bool_if:NTF{\l_myintroduction_numberUsed_bool}{%
          \mychapterheading[number=\l_myintroduction_number_tl]{\myintroductionname}%
        }{%
          \mychapterheading{\myintroductionname}%
        }%
        \myhyperanchor*{myintroduction}%
        \bool_if:NT{\l_myintroduction_labelUsed_bool}{%
          \mylabel*{myintroduction}{intro:\l_myintroduction_label_tl}%
        }%
        \IfBooleanF{#1}{%
          \myaddtotoc{mychapter}{\mychapterbox[l]{\themychapter}\hspace{1em}\myintroductionname}%
        }%
      \else%
        \ifGlobalMysectionUsed%
          \bool_if:NTF{\l_myintroduction_numberUsed_bool}{%
            \mysectionheading[number=\l_myintroduction_number_tl]{\myintroductionname}%
          }{%
            \mysectionheading{\myintroductionname}%
          }%
          \myhyperanchor*{myintroduction}%
          \bool_if:NT{\l_myintroduction_labelUsed_bool}{%
            \mylabel*{myintroduction}{intro:\l_myintroduction_label_tl}%
          }%
          \IfBooleanF{#1}{%
            \myaddtotoc{mysection}{\mysectionbox[l]{\themysection}\hspace{1em}\myintroductionname}%
          }%
        \else%
          \ifGlobalMysubsectionUsed%
            \bool_if:NTF{\l_myintroduction_numberUsed_bool}{%
              \mysubsectionheading[number=\l_myintroduction_number_tl]{\myintroductionname}%
            }{%
              \mysubsectionheading{\myintroductionname}%
            }%
            \myhyperanchor*{myintroduction}%
            \bool_if:NT{\l_myintroduction_labelUsed_bool}{%
              \mylabel*{myintroduction}{intro:\l_myintroduction_label_tl}%
            }%
            \IfBooleanF{#1}{%
              \myaddtotoc{mysubsection}{\mysubsectionbox[l]{\themysubsection}\hspace{1em}\myintroductionname}%
            }%
          \else%
            \bool_if:NTF{\l_myintroduction_numberUsed_bool}{%
              \mysubsubsectionheading[number=\l_myintroduction_number_tl]{\myintroductionname}%
            }{%
              \mysubsubsectionheading{\myintroductionname}%
            }%
            \myhyperanchor*{myintroduction}%
            \bool_if:NT{\l_myintroduction_labelUsed_bool}{%
              \mylabel*{myintroduction}{intro:\l_myintroduction_label_tl}%
            }%
            \IfBooleanF{#1}{%
              \myaddtotoc{mysubsubsection}{\mysubsubsectionbox[l]{\themysubsubsection}\hspace{1em}\myintroductionname}%
            }%
          \fi%
        \fi%
      \fi%
    \fi%
  }
\ExplSyntaxOff
\ExplSyntaxOn
  \tl_new:N{\l_mypart_number_tl}
  \tl_new:N{\l_mypart_name_tl}
  \tl_new:N{\l_mypart_label_tl}
  \bool_new:N{\l_mypart_numberUsed_bool}
  \bool_new:N{\l_mypart_nameUsed_bool}
  \bool_new:N{\l_mypart_labelUsed_bool}
  \keys_define:nn{mypart}{%
    number.code:n = {%
      \bool_set_true:N{\l_mypart_numberUsed_bool}%
      \tl_set:Nn{\l_mypart_number_tl}{#1}%
    },%
    name.code:n = {%
      \bool_set_true:N{\l_mypart_nameUsed_bool}%
      \tl_set:Nn{\l_mypart_name_tl}{#1}%
    },%
    label.code:n = {%
      \bool_set_true:N{\l_mypart_labelUsed_bool}%
      \tl_set:Nn{\l_mypart_label_tl}{#1}%
    },%
  }
  \NewDocumentCommand{\mypart}{s m O{}}{%
    \bool_set_false:N{\l_mypart_numberUsed_bool}%
    \bool_set_false:N{\l_mypart_nameUsed_bool}%
    \bool_set_false:N{\l_mypart_labelUsed_bool}%
    \keys_set:nn{mypart}{%
      #3%
    }%
    \RegisterStructureUsage{Mypart}%
    \ifMyannexUsed%
      \IfIsalphF{\newpage\pagenumbering{myalph}}%
      \let\myheadingname\myannexname%
    \else%
      \IfIsarabicF{\newpage\pagenumbering{arabic}}%
      \let\myheadingname\mypartname%
    \fi%
    \bool_if:NT{\l_mypart_nameUsed_bool}{%
      \let\myheadingname\l_mypart_name_tl%
    }%
    \IfBooleanTF{#1}{%
      \mypartheading*[name=\myheadingname]{#2}%
    }{%
      \bool_if:NTF{\l_mypart_numberUsed_bool}{%
        \mypartheading[name=\myheadingname, number=\l_mypart_number_tl]{#2}%
      }{%
        \stepcounter{mypart}%
        \mypartheading[name=\myheadingname]{#2}%
      }%
    }%
    \myhyperanchor{mypart}%
    \bool_if:NT{\l_mypart_labelUsed_bool}{%
      \ifMyannexUsed%
        \mylabel{mypart}{ann:part:\l_mypart_label_tl}%
      \else%
        \mylabel{mypart}{part:\l_mypart_label_tl}%
      \fi%
    }%
    \IfBooleanF{#1}{%
      \myaddtotoc{mypart}{\mypartbox[l]{\myheadingname\space\themypart}\hspace{1em}#2}%
    }%
  }
\ExplSyntaxOff
\ExplSyntaxOn
  \tl_new:N{\l_mychapter_number_tl}
  \tl_new:N{\l_mychapter_label_tl}
  \bool_new:N{\l_mychapter_numberUsed_bool}
  \bool_new:N{\l_mychapter_labelUsed_bool}
  \keys_define:nn{mychapter}{%
    number.code:n = {%
      \bool_set_true:N{\l_mychapter_numberUsed_bool}%
      \tl_set:Nn{\l_mychapter_number_tl}{#1}%
    },%
    label.code:n = {%
      \bool_set_true:N{\l_mychapter_labelUsed_bool}%
      \tl_set:Nn{\l_mychapter_label_tl}{#1}%
    },%
  }
  \NewDocumentCommand{\mychapter}{s m O{}}{%
    \bool_set_false:N{\l_mychapter_numberUsed_bool}%
    \bool_set_false:N{\l_mychapter_labelUsed_bool}%
    \keys_set:nn{mychapter}{%
      #3%
    }%
    \RegisterStructureUsage{Mychapter}%
    \ifMyannexUsed%
      \IfIsalphF{\newpage\pagenumbering{myalph}}%
    \else%
      \IfIsarabicF{\newpage\pagenumbering{arabic}}%
    \fi%
    \IfBooleanTF{#1}{%
      \mychapterheading*{#2}%
    }{%
      \bool_if:NTF{\l_mychapter_numberUsed_bool}{%
        \mychapterheading[number=\l_mychapter_number_tl]{#2}%
      }{%
        \stepcounter{mychapter}%
        \mychapterheading{#2}%
      }%
    }%
    \myhyperanchor{mychapter}%
    \bool_if:NT{\l_mychapter_labelUsed_bool}{%
      \ifMyannexUsed%
        \mylabel{mychapter}{ann:chap:\l_mychapter_label_tl}%
      \else%
        \mylabel{mychapter}{chap:\l_mychapter_label_tl}%
      \fi%
    }%
    \IfBooleanF{#1}{%
      \myaddtotoc{mychapter}{\mychapterbox[l]{\themychapter}\hspace{1em}#2}%
    }%
  }
\ExplSyntaxOff
\ExplSyntaxOn
  \tl_new:N{\l_mysection_number_tl}
  \tl_new:N{\l_mysection_label_tl}
  \bool_new:N{\l_mysection_numberUsed_bool}
  \bool_new:N{\l_mysection_labelUsed_bool}
  \keys_define:nn{mysection}{%
    number.code:n = {%
      \bool_set_true:N{\l_mysection_numberUsed_bool}%
      \tl_set:Nn{\l_mysection_number_tl}{#1}%
    },%
    label.code:n = {%
      \bool_set_true:N{\l_mysection_labelUsed_bool}%
      \tl_set:Nn{\l_mysection_label_tl}{#1}%
    },%
  }
  \NewDocumentCommand{\mysection}{s m O{}}{%
    \bool_set_false:N{\l_mysection_numberUsed_bool}%
    \bool_set_false:N{\l_mysection_labelUsed_bool}%
    \keys_set:nn{mysection}{%
      #3%
    }%
    \RegisterStructureUsage{Mysection}%
    \ifMyannexUsed%
      \IfIsalphF{\newpage\pagenumbering{myalph}}%
    \else%
      \IfIsarabicF{\newpage\pagenumbering{arabic}}%
    \fi%
    \IfBooleanTF{#1}{%
      \mysectionheading*{#2}%
    }{%
      \ifGlobalMypartUsed%
      \else%
        \ifGlobalMychapterUsed%
        \else%
          \setcounter{myfigure}{0}%
          \setcounter{myprogram}{0}%
          \setcounter{myequation}{0}%
          \setcounter{mytable}{0}%
        \fi%
      \fi%
      \bool_if:NTF{\l_mysection_numberUsed_bool}{%
        \mysectionheading[number=\l_mysection_number_tl]{#2}%
      }{%
        \stepcounter{mysection}%
        \mysectionheading{#2}%
      }%
    }%
    \myhyperanchor{mysection}%
    \bool_if:NT{\l_mysection_labelUsed_bool}{%
      \ifMyannexUsed%
        \mylabel{mysection}{ann:sec:\l_mysection_label_tl}%
      \else%
        \mylabel{mysection}{sec:\l_mysection_label_tl}%
      \fi%
    }%
    \IfBooleanF{#1}{%
      \myaddtotoc{mysection}{\mysectionbox[l]{\themysection}\hspace{1em}#2}%
    }%
  }
\ExplSyntaxOff
\ExplSyntaxOn
  \tl_new:N{\l_mysubsection_number_tl}
  \tl_new:N{\l_mysubsection_label_tl}
  \bool_new:N{\l_mysubsection_numberUsed_bool}
  \bool_new:N{\l_mysubsection_labelUsed_bool}
  \keys_define:nn{mysubsection}{%
    number.code:n = {%
      \bool_set_true:N{\l_mysubsection_numberUsed_bool}%
      \tl_set:Nn{\l_mysubsection_number_tl}{#1}%
    },%
    label.code:n = {%
      \bool_set_true:N{\l_mysubsection_labelUsed_bool}%
      \tl_set:Nn{\l_mysubsection_label_tl}{#1}%
    },%
  }
  \NewDocumentCommand{\mysubsection}{s m O{}}{%
    \bool_set_false:N{\l_mysubsection_numberUsed_bool}%
    \bool_set_false:N{\l_mysubsection_labelUsed_bool}%
    \keys_set:nn{mysubsection}{%
      #3%
    }%
    \RegisterStructureUsage{Mysubsection}%
    \ifMyannexUsed%
      \IfIsalphF{\newpage\pagenumbering{myalph}}%
    \else%
      \IfIsarabicF{\newpage\pagenumbering{arabic}}%
    \fi%
    \IfBooleanTF{#1}{%
      \mysubsectionheading*{#2}%
    }{%
      \ifGlobalMypartUsed%
      \else%
        \ifGlobalMychapterUsed%
        \else%
          \ifGlobalMysectionUsed%
          \else%
            \setcounter{myfigure}{0}%
            \setcounter{myprogram}{0}%
            \setcounter{myequation}{0}%
            \setcounter{mytable}{0}%
          \fi%
        \fi%
      \fi%
      \bool_if:NTF{\l_mysubsection_numberUsed_bool}{%
        \mysubsectionheading[number=\l_mysubsection_number_tl]{#2}%
      }{%
        \stepcounter{mysubsection}%
        \mysubsectionheading{#2}%
      }%
    }%
    \myhyperanchor{mysubsection}%
    \bool_if:NT{\l_mysubsection_labelUsed_bool}{%
      \ifMyannexUsed%
        \mylabel{mysubsection}{ann:subsec:\l_mysubsection_label_tl}%
      \else%
        \mylabel{mysubsection}{subsec:\l_mysubsection_label_tl}%
      \fi%
    }%
    \IfBooleanF{#1}{%
      \myaddtotoc{mysubsection}{\mysubsectionbox[l]{\themysubsection}\hspace{1em}#2}%
    }%
  }
\ExplSyntaxOff
\ExplSyntaxOn
  \tl_new:N{\l_mysubsubsection_number_tl}
  \tl_new:N{\l_mysubsubsection_label_tl}
  \bool_new:N{\l_mysubsubsection_numberUsed_bool}
  \bool_new:N{\l_mysubsubsection_labelUsed_bool}
  \keys_define:nn{mysubsubsection}{%
    number.code:n = {%
      \bool_set_true:N{\l_mysubsubsection_numberUsed_bool}%
      \tl_set:Nn{\l_mysubsubsection_number_tl}{#1}%
    },%
    label.code:n = {%
      \bool_set_true:N{\l_mysubsubsection_labelUsed_bool}%
      \tl_set:Nn{\l_mysubsubsection_label_tl}{#1}%
    },%
  }
  \NewDocumentCommand{\mysubsubsection}{s m O{}}{%
    \bool_set_false:N{\l_mysubsubsection_numberUsed_bool}%
    \bool_set_false:N{\l_mysubsubsection_labelUsed_bool}%
    \keys_set:nn{mysubsubsection}{%
      #3%
    }%
    \RegisterStructureUsage{Mysubsubsection}%
    \ifMyannexUsed%
      \IfIsalphF{\newpage\pagenumbering{myalph}}%
    \else%
      \IfIsarabicF{\newpage\pagenumbering{arabic}}%
    \fi%
    \IfBooleanTF{#1}{%
      \mysubsubsectionheading*{#2}%
    }{%
      \ifGlobalMypartUsed%
      \else%
        \ifGlobalMychapterUsed%
        \else%
          \ifGlobalMysectionUsed%
          \else%
            \ifGlobalMysubsectionUsed%
            \else%
              \setcounter{myfigure}{0}%
              \setcounter{myprogram}{0}%
              \setcounter{myequation}{0}%
              \setcounter{mytable}{0}%
            \fi%
          \fi%
        \fi%
      \fi%
      \bool_if:NTF{\l_mysubsubsection_numberUsed_bool}{%
        \mysubsubsectionheading[number=\l_mysubsubsection_number_tl]{#2}%
      }{%
        \stepcounter{mysubsubsection}%
        \mysubsubsectionheading{#2}%
      }%
    }%
    \myhyperanchor{mysubsubsection}%
    \bool_if:NT{\l_mysubsubsection_labelUsed_bool}{%
      \ifMyannexUsed%
        \mylabel{mysubsubsection}{ann:subsubsec:\l_mysubsubsection_label_tl}%
      \else%
        \mylabel{mysubsubsection}{subsubsec:\l_mysubsubsection_label_tl}%
      \fi%
    }%
    \IfBooleanF{#1}{%
      \myaddtotoc{mysubsubsection}{\mysubsubsectionbox[l]{\themysubsubsection}\hspace{1em}#2}%
    }%
  }
\ExplSyntaxOff
\NewDocumentCommand{\mytableofcontents}{s o}{%
  \IfIsRomanF{\newpage\pagenumbering{Roman}}%
  \begingroup%
    \clearpage%
    \let\\\space%
    \ifGlobalMypartUsed%
      \mypartheading*{\mycontentsname}%
    \else%
      \ifGlobalMychapterUsed%
        \mychapterheading*{\mycontentsname}%
      \else%
        \mysectionheading*{\mycontentsname}%
      \fi%
    \fi%
    \myhyperanchor*{mycontents}%
    \IfNoValueF{#2}{%
      \mylabel*{mycontents}{toc:#2}%
    }%
    \addvspace{20pt}%
    \@starttoc{mytoc}%
    \IfBooleanF{#1}{%
      \myaddtotoc{\myhighestsec}{\mycontentsname}%
    }%
  \endgroup%
  \clearpage%
}
\NewDocumentCommand{\mylistoffigures}{s o}{%
  \clearpage%
  \IfIsRomanF{\newpage\pagenumbering{Roman}}%
  \ifGlobalMypartUsed%
    \mypartheading*{\mylistfigurename}%
  \else%
    \ifGlobalMychapterUsed%
      \mychapterheading*{\mylistfigurename}%
    \else%
      \mysectionheading*{\mylistfigurename}%
    \fi%
  \fi%
  \myhyperanchor*{mylistfigure}%
  \IfNoValueF{#2}{%
    \mylabel*{mylistfigure}{lof:#2}%
  }%
  \addvspace{20pt}%
  \@starttoc{mylof}%
  \IfBooleanF{#1}{%
    \myaddtotoc{\myhighestsec}{\mylistfigurename}%
  }%
  \clearpage%
}
\NewDocumentCommand{\mylistoftables}{s o}{%
  \clearpage%
  \IfIsRomanF{\newpage\pagenumbering{Roman}}%
  \ifGlobalMypartUsed%
    \mypartheading*{\mylisttablename}%
  \else%
    \ifGlobalMychapterUsed%
      \mychapterheading*{\mylisttablename}%
    \else%
      \mysectionheading*{\mylisttablename}%
    \fi%
  \fi%
  \myhyperanchor*{mylisttable}%
  \IfNoValueF{#2}{%
    \mylabel*{mylisttable}{lot:#2}%
  }%
  \addvspace{20pt}%
  \@starttoc{mylot}%
  \IfBooleanF{#1}{%
    \myaddtotoc{\myhighestsec}{\mylisttablename}%
  }%
  \clearpage%
}
\NewDocumentCommand{\mylistofprograms}{s o}{%
  \clearpage%
  \IfIsRomanF{\newpage\pagenumbering{Roman}}%
  \ifGlobalMypartUsed%
    \mypartheading*{\mylistprogramname}%
  \else%
    \ifGlobalMychapterUsed%
      \mychapterheading*{\mylistprogramname}%
    \else%
      \mysectionheading*{\mylistprogramname}%
    \fi%
  \fi%
  \myhyperanchor*{mylistprogramname}%
  \IfNoValueF{#2}{%
    \mylabel*{mylistprogram}{lop:#2}%
  }%
  \addvspace{20pt}%
  \@starttoc{mylop}%
  \IfBooleanF{#1}{%
    \myaddtotoc{\myhighestsec}{\mylistprogramname}%
  }%
  \clearpage%
}
\NewDocumentCommand{\mylistofequations}{s o}{%
  \clearpage%
  \IfIsRomanF{\newpage\pagenumbering{Roman}}%
  \ifGlobalMypartUsed%
    \mypartheading*{\mylistequationname}%
  \else%
    \ifGlobalMychapterUsed%
      \mychapterheading*{\mylistequationname}%
    \else%
      \mysectionheading*{\mylistequationname}%
    \fi%
  \fi%
  \myhyperanchor*{mylistequation}%
  \IfNoValueF{#2}{%
    \mylabel*{mylistequation}{loe:#2}%
  }%
  \addvspace{20pt}%
  \@starttoc{myloe}%
  \IfBooleanF{#1}{%
    \myaddtotoc{\myhighestsec}{\mylistequationname}%
  }%
  \clearpage%
}
\NewDocumentCommand{\mypartbibheading}{s m}{%
  \mypartheading*{#2}%
  \myhyperanchor*{#2}%
  \IfBooleanF{#1}{%
    \myaddtotoc{mypart}{#2}%
  }%
  \markboth{#2}{#2}%
}
\NewDocumentCommand{\mychapterbibheading}{s m}{%
  \mychapterheading*{#2}%
  \myhyperanchor*{#2}%
  \IfBooleanF{#1}{%
    \myaddtotoc{mychapter}{#2}%
  }%
  \markboth{#2}{#2}%
}
\NewDocumentCommand{\mysectionbibheading}{s m}{%
  \mysectionheading*{#2}%
  \myhyperanchor*{#2}%
  \IfBooleanF{#1}{%
    \myaddtotoc{mysection}{#2}%
  }%
  \markboth{#2}{#2}%
}
\NewDocumentCommand{\mysubsectionbibheading}{s m}{%
  \mysubsectionheading*{#2}%
  \myhyperanchor*{#2}%
  \IfBooleanF{#1}{%
    \myaddtotoc{mysubsection}{#2}%
  }%
  \markboth{#2}{#2}%
}
\NewDocumentCommand{\mysubsubsectionbibheading}{s m}{%
  \mysubsubsectionheading*{#2}%
  \myhyperanchor*{#2}%
  \IfBooleanF{#1}{%
    \myaddtotoc{mysubsubsection}{#2}%
  }%
  \markboth{#2}{#2}%
}
\defbibheading{mypartbibintoc}[\mybibname]{%
  \mypartbibheading{#1}%
}
\defbibheading{mychapterbibintoc}[\mybibname]{%
  \mychapterbibheading{#1}%
}
\defbibheading{mysectionbibintoc}[\mybibname]{%
  \mysectionbibheading{#1}%
}
\defbibheading{mysubsectionbibintoc}[\mybibname]{%
  \mysubsectionbibheading{#1}%
}
\defbibheading{mysubsubsectionbibintoc}[\mybibname]{%
  \mysubsubsectionbibheading{#1}%
}
\defbibheading{mypartbib}[\mybibname]{%
  \mypartbibheading*{#1}%
}
\defbibheading{mychapterbib}[\mybibname]{%
  \mychapterbibheading*{#1}%
}
\defbibheading{mysectionbib}[\mybibname]{%
  \mysectionbibheading*{#1}%
}
\defbibheading{mysubsectionbib}[\mybibname]{%
  \mysubsectionbibheading*{#1}%
}
\defbibheading{mysubsubsectionbib}[\mybibname]{%
  \mysubsubsectionbibheading*{#1}%
}
\NewDocumentCommand{\mybibliography}{s o}{
  \MybibUsedtrue%
  \clearpage%
  \IfIsRomanF{\newpage\pagenumbering{roman}}%
  \myhyperanchor*{mybibliography}%
  \IfNoValueF{#2}{%
    \mylabel*{mybib}{bib:#2}%
  }%
  \IfBooleanTF{#1}{%
    \ifGlobalMypartUsed%
      \mypartbibheading*{\mybibname}%
      \printbibliography[heading=none, filter=not]%
      \printbibliography[heading=mychapterbib, filter=articles, title={\myarticlesname}]%
      \printbibliography[heading=mychapterbib, filter=books, title={\mybooksname}]%
      \printbibliography[heading=mychapterbib, filter=collections, title={\mycollectionsname}]%
      \printbibliography[heading=mychapterbib, filter=manuals, title={\mymanualsname}]%
      \printbibliography[heading=mychapterbib, filter=theses, title={\mythesesname}]%
      \printbibliography[heading=mychapterbib, filter=references, title={\myreferencesname}]%
      \printbibliography[heading=mychapterbib, filter=reports, title={\myreportsname}]%
      \printbibliography[heading=mychapterbib, filter=websites, title={\mywebsitesname}]%
      \printbibliography[heading=mychapterbib, filter=patents, title={\mypatentsname}]%
    \else%
      \ifGlobalMychapterUsed%
        \mychapterbibheading*{\mybibname}%
        \printbibliography[heading=none, filter=not]%
        \printbibliography[heading=mysectionbib, filter=articles, title={\myarticlesname}]%
        \printbibliography[heading=mysectionbib, filter=books, title={\mybooksname}]%
        \printbibliography[heading=mysectionbib, filter=collections, title={\mycollectionsname}]%
        \printbibliography[heading=mysectionbib, filter=manuals, title={\mymanualsname}]%
        \printbibliography[heading=mysectionbib, filter=theses, title={\mythesesname}]%
        \printbibliography[heading=mysectionbib, filter=references, title={\myreferencesname}]%
        \printbibliography[heading=mysectionbib, filter=reports, title={\myreportsname}]%
        \printbibliography[heading=mysectionbib, filter=websites, title={\mywebsitesname}]%
        \printbibliography[heading=mysectionbib, filter=patents, title={\mypatentsname}]%
      \else%
        \mysectionbibheading*{\mybibname}%
        \printbibliography[heading=none, filter=not]%
        \printbibliography[heading=mysubsectionbib, filter=articles, title={\myarticlesname}]%
        \printbibliography[heading=mysubsectionbib, filter=books, title={\mybooksname}]%
        \printbibliography[heading=mysubsectionbib, filter=collections, title={\mycollectionsname}]%
        \printbibliography[heading=mysubsectionbib, filter=manuals, title={\mymanualsname}]%
        \printbibliography[heading=mysubsectionbib, filter=theses, title={\mythesesname}]%
        \printbibliography[heading=mysubsectionbib, filter=references, title={\myreferencesname}]%
        \printbibliography[heading=mysubsectionbib, filter=reports, title={\myreportsname}]%
        \printbibliography[heading=mysubsectionbib, filter=websites, title={\mywebsitesname}]%
        \printbibliography[heading=mysubsectionbib, filter=patents, title={\mypatentsname}]%
      \fi%
    \fi%
  }{%
    \ifGlobalMypartUsed%
      \mypartbibheading{\mybibname}%
      \printbibliography[heading=none, filter=not]%
      \printbibliography[heading=mychapterbibintoc, filter=articles, title={\myarticlesname}]%
      \printbibliography[heading=mychapterbibintoc, filter=books, title={\mybooksname}]%
      \printbibliography[heading=mychapterbibintoc, filter=collections, title={\mycollectionsname}]%
      \printbibliography[heading=mychapterbibintoc, filter=manuals, title={\mymanualsname}]%
      \printbibliography[heading=mychapterbibintoc, filter=theses, title={\mythesesname}]%
      \printbibliography[heading=mychapterbibintoc, filter=references, title={\myreferencesname}]%
      \printbibliography[heading=mychapterbibintoc, filter=reports, title={\myreportsname}]%
      \printbibliography[heading=mychapterbibintoc, filter=websites, title={\mywebsitesname}]%
      \printbibliography[heading=mychapterbibintoc, filter=patents, title={\mypatentsname}]%
    \else%
      \ifGlobalMychapterUsed%
        \mychapterbibheading{\mybibname}%
        \printbibliography[heading=none, filter=not]%
        \printbibliography[heading=mysectionbibintoc, filter=articles, title={\myarticlesname}]%
        \printbibliography[heading=mysectionbibintoc, filter=books, title={\mybooksname}]%
        \printbibliography[heading=mysectionbibintoc, filter=collections, title={\mycollectionsname}]%
        \printbibliography[heading=mysectionbibintoc, filter=manuals, title={\mymanualsname}]%
        \printbibliography[heading=mysectionbibintoc, filter=theses, title={\mythesesname}]%
        \printbibliography[heading=mysectionbibintoc, filter=references, title={\myreferencesname}]%
        \printbibliography[heading=mysectionbibintoc, filter=reports, title={\myreportsname}]%
        \printbibliography[heading=mysectionbibintoc, filter=websites, title={\mywebsitesname}]%
        \printbibliography[heading=mysectionbibintoc, filter=patents, title={\mypatentsname}]%
      \else%
        \mysectionbibheading{\mybibname}%
        \printbibliography[heading=none, filter=not]%
        \printbibliography[heading=mysubsectionbibintoc, filter=articles, title={\myarticlesname}]%
        \printbibliography[heading=mysubsectionbibintoc, filter=books, title={\mybooksname}]%
        \printbibliography[heading=mysubsectionbibintoc, filter=collections, title={\mycollectionsname}]%
        \printbibliography[heading=mysubsectionbibintoc, filter=manuals, title={\mymanualsname}]%
        \printbibliography[heading=mysubsectionbibintoc, filter=theses, title={\mythesesname}]%
        \printbibliography[heading=mysubsectionbibintoc, filter=references, title={\myreferencesname}]%
        \printbibliography[heading=mysubsectionbibintoc, filter=reports, title={\myreportsname}]%
        \printbibliography[heading=mysubsectionbibintoc, filter=websites, title={\mywebsitesname}]%
        \printbibliography[heading=mysubsectionbibintoc, filter=patents, title={\mypatentsname}]%
      \fi%
    \fi%
  }%
  \MybibUsedfalse%
}%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
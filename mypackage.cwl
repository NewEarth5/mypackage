# Include dependent packages
#include:geometry
#include:tcolorbox
#include:svg
#include:graphicx
#include:xcolor
#include:hyperref
#include:xstring

# Internal commands
\RegisterStructureUsage{GlobalVariable}#i
\IsRoman{true}{false}#i
\mytcbincludeprogram{options}{path}{language}{background color}{frame color}{number width}{number background color}#i
\myhyperanchor{name}#i
\mylabel{label}#il

# Commands
\currentacyear#Sn
\themyequation#Sn
\themyfigure#Sn
\themytable#Sn
\themylisting#Sn
\themypart#Sn
\themychapter#Sn
\themysection#Sn
\themysubsection#Sn
\themysubsubsection#Sn
\myinclude[options]{path}#Sn
\myfigure[options]{path}[short caption]{caption}[placement]#Sn
\myfigure*[options]{path}[short caption]{caption}[placement]#Sn
\myincludeprogram[options]{path}{language}#Sn
\myprogram[options]{path}{language}[short caption]{caption}[placement]#Sn
\myprogram*[options]{path}{language}[short caption]{caption}[placement]#Sn
\seeref{reference}#Sr

# Enviroments
\begin{myequation}{label}#Sln
\end{myequation}
\begin{mytable}[options]{column types}{label}[short caption]{caption}[placement]#Sn
\end{mytable}
\begin{mytable}*[options]{column types}{label}[short caption]{caption}[placement]#Sn
\end{mytable}

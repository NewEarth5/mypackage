# Include dependent packages
#include:geometry
#include:tcolorbox
#include:svg
#include:graphicx
#include:xcolor
#include:hyperref

# Internal commands
\mypartbox[alignment]{number}#i
\mychapterbox[alignment]{number}#i
\mysectionbox[alignment]{number}#i
\mysubsectionbox[alignment]{number}#i
\mysubsubsectionbox[alignment]{number}#i

# Commands
\mycurrentacyear#Sn
\currentacyear#S
\mycleantext{text}#Sn
\mycleanline{text}#Sn
\mycleanfirstline{text}#Sn
\mylenmax{length}{length}#Sn
\mylenmin{length}{length}#Sn
\myhighestsec#Sn
\themyequation#Sn
\themyfigure#Sn
\themytable#Sn
\themyprogram#Sn
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

* difvh-205-table1.do
* Alden Gross
*  2 Aug 2018
* -------------------
use $derived/interim-difvh-120.dta, clear
*

table1 commonage educbi female white vision hearing ///
   u8_* u_* , cat(u*) tex(tabl1.tex) p(9cm)
tex \section{Descriptive characteristics}
tex Table `++tablecounter'. \\
tex \input{tabl1.tex}



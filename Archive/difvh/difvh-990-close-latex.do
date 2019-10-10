* difvh-990-close-latex.do
* Alden Gross
*  2 Aug 2018
* -----------------
tex \end{document}
texdoc close
texify difvh.tex


time

today
copy difvh.pdf ///
$text/difvh_`r(datestr)'.pdf, replace


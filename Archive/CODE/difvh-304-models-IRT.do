use $derived/interim-difvh-125.dta, clear

*cap erase unidimensionalIRT.tex
*texdoc init unidimensionalIRT
*starttex , tex(unidimensionalIRT.tex) arial


* unidimensional IRT model
tex \newpage
tex \section{Unidimensional IRT model}

findname u*
local vlist "`r(varlist)'"
local w1: word 1 of `vlist'

runmplus `vlist' , ///
   coverage(0) varnocheck ///
   cat(`vlist') ///
   model( ///
      f BY `w1'* `vlist'; f@1; ///
      u1 WITh u2; u3 WITH u4; u8 WITH u7; ///
      u10 u11 u12 WITH u10* u11* u12*; ///
   ) output(stdyx; align; modindices(0); ) ///
   savelogfile( Results)

mat est = r(estimate)

local names: rowfullnames est
di "`names'"
lstrfun names , subinstr("`names'","$","_",.)
matrix rownames est = `names'


findname u*
local vlist "`r(varlist)'"

tex Table. Unidimensional IRT results \\

tex \begin{scriptsize}
tex \begin{longtable}{l c ccccccccc } \hline
tex Variable & Raw (standardized) & \multicolumn{9}{c}{Thresholds} \\
tex          & Loading            & 1 & 2 & 3 & 4 & 5 & 6 & 7 & 8 & 9 \\
tex \hline

qui foreach uvar in `vlist' {
   eme stdyx_f_by_`uvar' , mat(est)
   local slam`uvar' : di %4.2f `r(r1)'
   eme f_by_`uvar' , mat(est)
   local lam`uvar' : di %4.2f `r(r1)'
   sum `uvar' , meanonly
   distinct `uvar' if `uvar'!=`r(max)'
   local nthr`uvar'=`r(ndistinct)'
   local thrlist`uvar' ""
   forvalues th=1/`r(ndistinct)' {
      eme stdyx_thresholds_`uvar'_`th' , mat(est)
      local th`uvar'_`th' : di %4.2f `r(r1)'
      local thrlist`uvar' "`thrlist`uvar'' & `th`uvar'_`th''"
   }
   nois di "tex `uvar' & `lam`uvar'' (`slam`uvar'') & `thrlist`uvar''"
   local foo: var label `uvar'
   local foo`uvar': var label `uvar'
   tex `uvar'. `foo' & `lam`uvar'' (`slam`uvar'')  `thrlist`uvar'' \\
   *local scatteri "`scatteri' `slam`uvar'' `th`uvar'_1'"
}
tex \hline
tex \end{longtable}
tex \end{scriptsize}

*tex \end{document}
*texdoc close
*texify unidimensionalIRT.tex

local mlabposu1 =9
local mlabposu2 =9
local mlabposu3 =9
local mlabposu4 =9
local mlabposu5 =6
local mlabposu6 =12
local mlabposu7 =9
local mlabposu8 =12
local mlabposu9 =12
local mlabposu10 =12
local mlabposu11 =9
local mlabposu12 =9
local mlabposu13 =9
local mlabposu14 =9
local mlabposu15 =9
local mlabposu16 =6
local colors "red orange yellow blue purple    black gs10 brown cyan orange   green pink yellow     blue brown cyan"

local cc=0
foreach uvar in `vlist' {
   local col`uvar': word `++cc' of `colors'
   * Here is the dot for the first threshold. label: `foo`uvar''
   local scatteri1 `"`scatteri1' (scatteri `slam`uvar'' `th`uvar'_1' "`foo`uvar''", mlabpos(`mlabpos`uvar'')  mcolor(`col`uvar'') msymbol(O) legend(off) mlabsize(2.5) ) "'
   forvalues i= 2 / `nthr`uvar'' {
      local scatteri2`uvar' "`scatteri2`uvar'' `slam`uvar'' `th`uvar'_`i'' "
      *local scatteri2 `"`scatteri2' (scatteri `slam`uvar'' `th`uvar'_`i'' , mlabpos(9)  mcolor(black) msymbol(O) legend(off)  ) "'
   }
   * Here is the line connecting each threshold within an item
   local scatteri3 `"`scatteri3' (scatteri `slam`uvar'' `th`uvar'_1' `slam`uvar'' `th`uvar'_`nthr`uvar''' , recast(line) lpat(solid) mcolor(`col`uvar'') lcolor(`col`uvar'') ) "'
}

* scatterplot of loadings vs thresholds

graph twoway ///
   `scatteri1' ///
   (scatteri `scatteri2u1' , mlabpos(9)   mcolor(`colu1') msymbol(O) legend(off)  ) ///
   (scatteri `scatteri2u2' , mlabpos(9)   mcolor(`colu2') msymbol(O) legend(off)  ) ///
   (scatteri `scatteri2u3' , mlabpos(9)   mcolor(`colu3') msymbol(O) legend(off)  ) ///
   (scatteri `scatteri2u4' , mlabpos(9)   mcolor(`colu4') msymbol(O) legend(off)  ) ///
   (scatteri `scatteri2u5' , mlabpos(9)   mcolor(`colu5') msymbol(O) legend(off)  ) ///
   (scatteri `scatteri2u6' , mlabpos(9)   mcolor(`colu6') msymbol(O) legend(off)  ) ///
   (scatteri `scatteri2u7' , mlabpos(9)   mcolor(`colu7') msymbol(O) legend(off)  ) ///
   (scatteri `scatteri2u8' , mlabpos(9)   mcolor(`colu8') msymbol(O) legend(off)  ) ///
   (scatteri `scatteri2u9' , mlabpos(9)   mcolor(`colu9') msymbol(O) legend(off)  ) ///
   (scatteri `scatteri2u10' , mlabpos(9)  mcolor(`colu10') msymbol(O) legend(off)  ) ///
   (scatteri `scatteri2u11' , mlabpos(9)  mcolor(`colu11') msymbol(O) legend(off)  ) ///
   (scatteri `scatteri2u12' , mlabpos(9)  mcolor(`colu12') msymbol(O) legend(off)  ) ///
   (scatteri `scatteri2u13' , mlabpos(9)  mcolor(`colu13') msymbol(O) legend(off)  ) ///
   (scatteri `scatteri2u14' , mlabpos(9)  mcolor(`colu14') msymbol(O) legend(off)  ) ///
   (scatteri `scatteri2u15' , mlabpos(9)  mcolor(`colu15') msymbol(O) legend(off)  ) ///
   (scatteri `scatteri2u16' , mlabpos(9)  mcolor(`colu16') msymbol(O) legend(off)  ) ///
   `scatteri3' ///
   , xscale(range(-3 2)) ///
   xtitle("Item location along the latent cognitive trait (higher is better)") ///
     ytitle("Standardized factor loading (discrimination)") ///
   legend(off)
graph export load_thres_irt.png, replace width(3000)



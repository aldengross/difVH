

* use "C:\Users\sdu7\Box Sync\R21_SENSE-MATTERS\DIFVH\POSTED\DATA\DERIVED\difvh_analysis-120.dta",clear 
use  $derived/interim-difvh-120.dta , clear

*cap erase unidimensionalIRT.tex
*texdoc init unidimensionalIRT,force 
*starttex , tex(unidimensionalIRT.tex) arial


* unidimensional IRT model
tex \newpage
tex \section{Analysis set `++analysisset'. Unidimensional IRT model}

findname u8_*
local vlist "`r(varlist)'"
local w1: word 1 of `vlist'

runmplus `vlist' , ///
   idvariable(idno) coverage(0) varnocheck ///
   cat(`vlist') ///
   analysis(estimator=mlr; !parameterization= delta; !integration=montecarlo; ) ///
   model( ///
      f BY `w1'* `vlist'; f@1; ///
      ///s1 BY u8_1* u8_2 (s1); s1*; ///
      ///s2 BY u8_3* u8_4 (s2); s2*; ///
      ///s3 BY u8_8* u8_7 (s3); s3*; ///
      ///s4 BY u8_10* u8_11 u8_12; s4@1; ///
      ///f s1 s2 s3 s4 WITH s1@0 s2@0 s3@0 s4@0; ///
      ///f WITH s4@0; ///
      ///u8_1 WITh u8_2; u8_3 WITH u8_4; u8_8 WITH u8_7; ///
      ///u8_10 u8_11 u8_12 WITH u8_10* u8_11* u8_12*; ///
   ) output(stdyx; align; modindices(0); ) ///
   savelogfile( Results) ///
   savedata(save=fscores ; ///
      file= blsairt.dat)
mat est = r(estimate)


* Merge in saved results
preserve
   runmplus_load_savedata , out(Results.out) clear
   sum
   keep idno f*
   tempfile data
   save `data'
restore
capture drop _merge
merge idno using `data', sort update keep(f*)
tab _merge
drop _merge


local names: rowfullnames est
di "`names'"
lstrfun names , subinstr("`names'","$","_",.)
matrix rownames est = `names'

tex \subsection{Table of parameters}
tex Table `++tablecounter'. Unidimensional IRT results \\

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
      eme thresholds_`uvar'_`th' , mat(est)
      local th`uvar'_`th' : di %4.2f `r(r1)'
      local thrlist`uvar' "`thrlist`uvar'' & `th`uvar'_`th''"
   }
   nois di "tex `uvar' & `lam`uvar'' (`slam`uvar'') & `thrlist`uvar''"
   local foo: var label `uvar'
   local foo`uvar': var label `uvar'
   lstrfun foo2 , subinstr("`uvar'","_","\_",.)

   tex `foo2'. `foo' & `lam`uvar'' (`slam`uvar'')  `thrlist`uvar'' \\
   *local scatteri "`scatteri' `slam`uvar'' `th`uvar'_1'"
}
tex \hline
tex \end{longtable}
tex \end{scriptsize}





local mlabposu8_1 =9
local mlabposu8_2 =9
local mlabposu8_3 =9
local mlabposu8_4 =9
local mlabposu8_5 =6
local mlabposu8_6 =12
local mlabposu8_7 =9
local mlabposu8_8 =12
local mlabposu8_9 =12
local mlabposu8_10 =12
local mlabposu8_11 =9
local mlabposu8_12 =9
local mlabposu8_13 =9
local mlabposu8_14 =9
local mlabposu8_15 =9
local mlabposu8_16 =6
local colors "red orange yellow blue purple    black gs10 brown cyan orange   green pink yellow     blue brown cyan"

local cc=0
foreach uvar in `vlist' {
   local col`uvar': word `++cc' of `colors'
   * Here is the dot for the first threshold. label: `foo`uvar''
   *local scatteri1 `"`scatteri1' (scatteri `lam`uvar'' `th`uvar'_1' "`foo`uvar''", mlabpos(`mlabpos`uvar'')  mcolor(`col`uvar'') msymbol(O) legend(off) mlabsize(2.5) ) "'
   if inrange(`th`uvar'_1',-4,4)==1 {
      local scatteri1 `"`scatteri1' (scatteri `lam`uvar'' `th`uvar'_1' "`foo`uvar''", mlabpos(`mlabpos`uvar'')  mcolor(`col`uvar'') msymbol(O) legend(off) mlabsize(2.5) ) "'
      local linestart`uvar' = `th`uvar'_1'
   }
   else {
      local scatteri1 `"`scatteri1' (scatteri `lam`uvar'' `th`uvar'_2' "`foo`uvar''", mlabpos(`mlabpos`uvar'')  mcolor(`col`uvar'') msymbol(O) legend(off) mlabsize(2.5) ) "'
      local linestart`uvar' = `th`uvar'_2'
   }
   forvalues i= 2 / `nthr`uvar'' {
      if inrange(`th`uvar'_`i'',-4,4)==1 {
         local scatteri2`uvar' "`scatteri2`uvar'' `lam`uvar'' `th`uvar'_`i'' "
      }
      *local scatteri2 `"`scatteri2' (scatteri `slam`uvar'' `th`uvar'_`i'' , mlabpos(9)  mcolor(black) msymbol(O) legend(off)  ) "'
   }
   * Here is the line connecting each threshold within an item
   local scatteri3 `"`scatteri3' (scatteri `lam`uvar'' `linestart`uvar'' `lam`uvar'' `th`uvar'_`nthr`uvar''' , recast(line) lpat(solid) mcolor(`col`uvar'') lcolor(`col`uvar'') ) "'
}
*di in white "`scatteri1'"

local size=3
* scatterplot of loadings vs thresholds
if $makenewgraphs == 1 {
   graph twoway ///
      `scatteri1' ///
      (scatteri `scatteri2u8_1' , mlabpos(2)   mcolor(`colu8_1') msymbol(O) legend(off)  ) ///
      (scatteri `scatteri2u8_2' , mlabpos(2)   mcolor(`colu8_2') msymbol(O) legend(off)  ) ///
      (scatteri `scatteri2u8_3' , mlabpos(2)   mcolor(`colu8_3') msymbol(O) legend(off)  ) ///
      (scatteri `scatteri2u8_4' , mlabpos(2)   mcolor(`colu8_4') msymbol(O) legend(off)  ) ///
      (scatteri `scatteri2u8_5' , mlabpos(2)   mcolor(`colu8_5') msymbol(O) legend(off)  ) ///
      (scatteri `scatteri2u8_6' , mlabpos(2)   mcolor(`colu8_6') msymbol(O) legend(off)  ) ///
      (scatteri `scatteri2u8_7' , mlabpos(2)   mcolor(`colu8_7') msymbol(O) legend(off)  ) ///
      (scatteri `scatteri2u8_8' , mlabpos(2)   mcolor(`colu8_8') msymbol(O) legend(off)  ) ///
      (scatteri `scatteri2u8_9' , mlabpos(2)   mcolor(`colu8_9') msymbol(O) legend(off)  ) ///
      ///(scatteri `scatteri2u8_10' , mlabpos(2)  mcolor(`colu8_10') msymbol(O) legend(off)  ) ///
      ///(scatteri `scatteri2u8_11' , mlabpos(2)  mcolor(`colu8_11') msymbol(O) legend(off)  ) ///
      (scatteri `scatteri2u8_12' , mlabpos(2)  mcolor(`colu8_12') msymbol(O) legend(off)  ) ///
      (scatteri `scatteri2u8_13' , mlabpos(2)  mcolor(`colu8_13') msymbol(O) legend(off)  ) ///
      (scatteri `scatteri2u8_14' , mlabpos(2)  mcolor(`colu8_14') msymbol(O) legend(off)  ) ///
      (scatteri `scatteri2u8_15' , mlabpos(2)  mcolor(`colu8_15') msymbol(O) legend(off)  ) ///
      (scatteri `scatteri2u8_16' , mlabpos(2)  mcolor(`colu8_16') msymbol(O) legend(off)  ) ///
      `scatteri3' ///
      , xscale(range(-4 4)) ///-8 5
      ///xtitle("Item location along the latent cognitive trait (higher is better)") ///
      xtitle("") ///
       ytitle("Factor loading (discrimination; unstandardized)", size(`size')) ///
      legend(off) ///
      ylabel(1 2 3 ,nogrid gmax) yscale(range(.3 .9)) ///
      xlabel("",nogrid gmax) ///
      graphregion(margin(l=1 r=0))  ///
      plotregion(style(none))
   graph save foo.gph, replace
   graph export load_thres_irt.png, replace width(3000)
}

twoway hist f if inrange(f, -4, 4)==1, ///-8,5
   yscale(reverse) width(.15) percent  ///
   xscale(range(-4 4)) /// -8 5
   ylabel(0 2 4 6 8 10 ,nogrid gmax) yscale(range(0 10)) ///
   xtitle("Cognitive factor (Higher is better)", size(`size')) ///
   graphregion(margin(l=0 r=0))  ///
   ylabel(, nogrid gmax ) ///
   ytitle("Percent", size(`size') ) ///
   plotregion(style(none)) ///
   ysize(3) xsize(6)

graph save goo.gph , replace

graph combine foo.gph goo.gph    ///
      , imargin(0 0 0 0)           ///
      ///graphregion(margin(l=0 r=0))  ///
      scheme(lean2)               ///
      scale(1.2) col(1) ///
      ysize(5) xsize(7)
graph export discdiffplot.png, replace width(3000)



tex \subsection{Graph of loadings vs thresholds}
tex Figure `++figurecounter' \\
tex \begin{center}
tex \includegraphics[width=1\textwidth]{discdiffplot.png}\\
tex \end{center}






*tex \end{document}
*texdoc close
*texify unidimensionalIRT.tex





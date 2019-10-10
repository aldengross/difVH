 
*use "C:\Users\sdu7\Box Sync\R21_SENSE-MATTERS\DIFVH\POSTED\DATA\DERIVED\difvh_analysis-120.dta",clear 
use  "$derived/interim-difvh-120.dta" , clear
cd c:\trash

*cap erase alignmentvision.tex
*texdoc init alignmentvision , force   
*starttex , tex(alignmentvision.tex) arial
tex \newpage
tex \section{Hearing impairment - alignment analysis}
texdoc stlog
tab bptacat
texdoc stlog close
*tex \end{document}
*texdoc close
*texify alignmentvision.tex

if "`uvarset'"=="" {
   local uvarset "u_"
}

*tex \begin{document}

* DIF - alignment analysis 
* vision 
findname `uvarset'*
local vlist "`r(varlist)'"
local w1: word 1 of `vlist'

runmplus `vlist' bptacat , ///
   coverage(0) varnocheck ///
   cat(`vlist') ///
   variable( ///
      classes=d(2); ///
      knownclass=d(bptacat); ///
   ) analysis( ///
      type=mixture; ///
      !estimator=bayes; ///
      !fbiter=1000; thin=40; ///
      !chains=1; ///
      alignment = fixed(1 ) ; /// this makes the lv to N(0,1) in a reference dataset.
      algorithm=integration; ///
      process=2; ///
     TOLERANCE=0.01; ///
   ) model( ///
      %OVERALL% ///
      f BY `vlist';   ///
   ) output(stdyx; align; ) ///
   savelogfile( Results_hearing)

mat esth = r(estimate)
local names: rowfullnames esth
di "`names'"
lstrfun names , subinstr("`names'","$","_",.)
matrix rownames esth = `names'

tex \subsection{Alignment output}
preserve
   clear
   infix str v1 1-85 using Results_hearing.out
   gen line = _n
   gen foo=. // use this to ID what i want to take.
   replace foo=1 if trim(v1)=="APPROXIMATE MEASUREMENT INVARIANCE (NONINVARIANCE) FOR GROUPS"
   * Now, forward-fill for 9 lines from each of these instances.
   tab foo
   forvalues i=1/134 {
      cap replace foo=foo[_n-`i'] if foo[_n-`i']==1 & trim(v1[_n-`i'])=="APPROXIMATE MEASUREMENT INVARIANCE (NONINVARIANCE) FOR GROUPS"
   }
   tab foo
   replace foo=. if trim(v1)=="APPROXIMATE MEASUREMENT INVARIANCE (NONINVARIANCE) FOR GROUPS"
   forvalues i=1/500 {
      cap replace foo=. if foo[_n-`i']==1 & trim(v1[_n-`i'])=="FACTOR MEAN COMPARISON AT THE 5"
   }
   tab foo
   keep if foo==1
   ljs v1
   texdoc stlog
   list v1 if foo==1, clean noobs
   texdoc stlog close
restore

tex \newpage

tex \subsection{ICCs}
* OK. Show some ICCs now.
local labe2 "Hearing unimpaired"
local labe1 "Hearing impaired"
local grcm ""

foreach i in `vlist' { // *forvalues i=1/16 {
   distinct `i'
   local nthres`i' = `r(ndistinct)'-1
   foreach grpe in 1 2 {
     local aa`i'_`grpe' ""
     eme f_by_`i'_`grpe' , mat(esth)
     local a`i'_`grpe' : di %5.3f  `r(r1)'
     local b`i'_`grpe' ""
     forvalues t=1 / `nthres`i'' {
       eme thresholds_`i'_`t'_`grpe', mat(esth)
       local b`i'_`grpe' "`b`i'_`grpe'' `r(r1)'"
     }
     local foo : word count `b`i'_`grpe''
     foreach x in `b`i'_`grpe'' {
       local aa`i'_`grpe' "`aa`i'_`grpe'' `a`i'_`grpe''"
     }
   }
   di in white "As: `aa`i'_1',, `aa`i'_2' "
   di in white "Bs: `b`i'_1',, `b`i'_2' "
   local lab`i': var label `i'
   if $makenewgraphs == 1 {
      icc_2pl , ///
        a(`aa`i'_1' ) b(`b`i'_1' ) ///
        title("`lab`i'' (`i') - `labe1'", size(vlarge)) ///
        xtitle("") ///
        ytitle("") ///
        legend(off) ///
        text(0.9 -3.7 "a=`a`i'_1'" , placement(e) size(large) ) ///
        range(-7 7) yscale(range(0 1)) ylabel(0(.2)1) xlabel(-7(1)7)
      graph save `grp'lo`i'.gph , replace
      icc_2pl , ///
        a(`aa`i'_2' ) b( `b`i'_2' ) ///
        title("`lab`i'' (`i') - `labe2'", size(vlarge)) ///
        xtitle("") ///
        ytitle("") ///
        legend(off) ///
        text(0.9 -3.7 "a=`a`i'_2'" , placement(e) size(large) ) ///
        range(-7 7) yscale(range(0 1)) ylabel(0(.2)1)  xlabel(-7(1)7)
      graph save `grp'hi`i'.gph , replace
      graph combine `grp'lo`i'.gph `grp'hi`i'.gph , col(2) ///
        xsize(8) ysize(4) ycommon
      graph save icc_`grp'_`i'.gph , replace
      local grcm "`grcm' icc_`grp'_`i'.gph"
      graph export icc_`grp'_`i'h.png , replace width(3000)
   }
   local lab: var label u`i'
   tex u`i': `lab' \\
   tex \begin{center}
   tex \includegraphics[width=.8\textwidth]{icc_`grp'_`i'h.png}\\
   tex \end{center}

}
graph combine `grcm' , col(2) ///
   xsize(10) ysize(16) altshrink
graph export bigicc_`grp'h.png, replace width(3000)
*tex \end{document}
*texdoc close
*texify alignmentvision.tex



* Graph of loadings vs thresholds

*findname `uvarset'*
*local vlist "`r(varlist)'"

qui foreach uvar in `vlist' {
   foreach grp in 1 2 {
      local foo`uvar': var label `uvar'
      eme f_by_`uvar'_`grp' , mat(esth)
      local slam`uvar'_`grp' : di %4.2f `r(r1)'
      eme thresholds_`uvar'_1_`grp' , mat(esth)
      local th`uvar'_1_`grp' : di %4.2f `r(r1)'
     distinct `uvar'
      local nthres`uvar' = `r(ndistinct)'-1
     nois di in red "eme thresholds_`uvar'_`nthres`uvar''_`grp'"
      eme thresholds_`uvar'_`nthres`uvar''_`grp' , mat(esth)
      local th`uvar'_L_`grp' = `r(r1)'
     nois di in red "thre. `th`uvar'_L_`grp''"
   } // thresholds_u1_2_1 thresholds_u1_3_1
}
local mlabposu1 =12
local mlabposu2 =12
local mlabposu3 =12
local mlabposu4 =12
local mlabposu5 =12
local mlabposu6 =12
local mlabposu7 =6
local mlabposu8 =12
local mlabposu9 =12
local mlabposu10 =12
local mlabposu11 =6
local mlabposu12 =6
local mlabposu13 =12
local mlabposu14 =12
local mlabposu15 =6
local mlabposu16 =12
local colors "red orange green blue purple    black gs10 brown cyan orange   green pink orange     blue brown cyan"

local scatteri1 ""
local cc=0
foreach uvar in `vlist' {
   distinct `uvar'
   local nthres`uvar' = `r(ndistinct)'-1

   local col`uvar': word `++cc' of `colors'
   * Here is the dot for the first threshold. label: `foo`uvar''
   local scatteri1 `"`scatteri1' (scatteri `slam`uvar'_1' `th`uvar'_L_2' "`foo`uvar''", mlabpos(`mlabpos`uvar'') mlabcolor(`col`uvar'')  mcolor(`col`uvar'') msymbol(O) legend(off) mlabsize(2.5) ) "'
   local scatteri1 `"`scatteri1' (scatteri `slam`uvar'_1' `th`uvar'_L_1' ,  mcolor(`col`uvar'') msymbol(T) legend(off) mlabsize(2.5) ) "'
   local scatteri1 `"`scatteri1' (scatteri `slam`uvar'_1' `th`uvar'_L_1' `slam`uvar'_1' `th`uvar'_L_2'  , recast(line) lpat(dot) legend(off) ) "'
}

* scatterplot of loadings vs thresholds
di `"`scatteri1'"'
if $makenewgraphs == 1 {
   graph twoway ///
      `scatteri1' ///
      , xscale(range(-1 8)) ///
      xtitle("Item location along the latent cognitive trait (higher is better)") ///
       ytitle("Factor loading") ///
      legend(off)
   graph export load_thres_alignment_hearing.png, replace width(3000)
}
tex \subsection{Graph of loadings vs thresholds}
tex \begin{center}
tex \includegraphics[width=1\textwidth]{load_thres_alignment_hearing.png}\\
tex \end{center}











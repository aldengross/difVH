use $derived/interim-difvh-125.dta, clear

*cap erase alignmentvision.tex
*texdoc init alignmentvision
*starttex , tex(alignmentvision.tex) arial
tex \newpage
tex \section{Vision impairment}
texdoc stlog
tab va2040
texdoc stlog close

* DIF - alignment analysis 
* vision 
findname u*
local vlist "`r(varlist)'"
local w1: word 1 of `vlist'

runmplus `vlist' va2040 , ///
   coverage(0) varnocheck ///
   cat(`vlist') ///
   variable( ///
      classes=d(2); ///
      knownclass=d(va2040); ///
   ) analysis( ///
      type=mixture; ///
      !estimator=bayes; ///
      !fbiter=1000; thin=40; ///
      !chains=1; ///
      alignment = fixed(1 ) ; /// this makes the lv to N(0,1) in a reference dataset.
      algorithm=integration; ///
      process=2; ///
   ) model( ///
      %OVERALL% ///
      f BY `vlist';   ///
   ) output(stdyx; align; ) ///
   savelogfile( Results_vision)

mat estv = r(estimate)
local names: rowfullnames estv
di "`names'"
lstrfun names , subinstr("`names'","$","_",.)
matrix rownames estv = `names'


  than 20/40 |
  USING BCBE |
          VA |      Freq.     Percent        Cum.
-------------+-----------------------------------
0 Unimpaired |        570       88.65       88.65
  1 Impaired |         73       11.35      100.00
-------------+-----------------------------------
       Total |        643      100.00

preserve
   clear
   infix str v1 1-85 using Results_vision.out
   gen line = _n
   gen foo=. // use this to ID what i want to take.
   replace foo=1 if trim(v1)=="APPROXIMATE MEASUREMENT INVARIANCE (NONINVARIANCE) FOR GROUPS"
   * Now, forward-fill for 9 lines from each of these instances.
   tab foo
   forvalues i=1/120 {
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


* OK. Show some ICCs now.

tex \newpage
local labe1 "Vision unimpaired"
local labe2 "Vision impaired"
local grcm ""
forvalues i=1/16 {
   distinct u`i'
   local nthres`i' = `r(ndistinct)'-1
   foreach grpe in 1 2 {
      local aa`i'_`grpe' ""
      eme f_by_u`i'_`grpe' , mat(estv)
      local a`i'_`grpe' : di %5.3f `r(r1)'
      local b`i'_`grpe' ""
      forvalues t=1 / `nthres`i'' {
         eme thresholds_u`i'_`t'_`grpe', mat(estv)
         local b`i'_`grpe' "`b`i'_`grpe'' `r(r1)'"
      }
      local foo : word count `b`i'_`grpe''
      foreach x in `b`i'_`grpe'' {
         local aa`i'_`grpe' "`aa`i'_`grpe'' `a`i'_`grpe''"
      }
   }
   di in white "As: `aa`i'_1',, `aa`i'_2' "
   di in white "Bs: `b`i'_1',, `b`i'_2' "
   local lab`i': var label u`i'
   icc_2pl , ///
      a(`aa`i'_1' ) b(`b`i'_1' ) ///
      title("`lab`i'' (u`i') - `labe1'", size(vlarge)) ///
      xtitle("") ///
      ytitle("") ///
      legend(off) ///
      text(0.9 -3.7 "a=`a`i'_1'" , placement(e) size(large) ) ///
      range(-4 4) yscale(range(0 1)) ylabel(0(.2)1)
   graph save `grp'lo`i'.gph , replace
   icc_2pl , ///
      a(`aa`i'_2' ) b( `b`i'_2' ) ///
      title("`lab`i'' (u`i') - `labe2'", size(vlarge)) ///
      xtitle("") ///
      ytitle("") ///
      legend(off) ///
      text(0.9 -3.7 "a=`a`i'_2'" , placement(e) size(large) ) ///
      range(-4 4) yscale(range(0 1)) ylabel(0(.2)1)
   graph save `grp'hi`i'.gph , replace
   graph combine `grp'lo`i'.gph `grp'hi`i'.gph , col(2) ///
      xsize(8) ysize(4) ycommon
   graph save icc_`grp'_u`i'.gph , replace
   local grcm "`grcm' icc_`grp'_u`i'.gph"
   graph export icc_`grp'_u`i'v.png , replace width(3000)
   local lab: var label u`i'
   tex u`i': `lab' \\
   tex \begin{center}
   tex \includegraphics[width=.8\textwidth]{icc_`grp'_u`i'v.png}\\
   tex \end{center}

}
graph combine `grcm' , col(2) ///
   xsize(10) ysize(16) altshrink
graph export bigicc_`grp'v.png, replace width(3000)

*tex \end{document}
*texdoc close
*texify alignmentvision.tex





* Graph of loadings vs thresholds

findname u*
local vlist "`r(varlist)'"

qui foreach uvar in `vlist' {
   foreach grp in 1 2 {
      eme f_by_`uvar'_`grp' , mat(estv)
      local slam`uvar'_`grp' : di %4.2f `r(r1)'
      eme thresholds_`uvar'_1_`grp' , mat(estv)
      local th`uvar'_1_`grp' : di %4.2f `r(r1)'
      local foo`uvar': var label `uvar'
   }
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
local colors "red orange green blue purple    black gs10 brown cyan orange   green pink yellow     blue brown cyan"

local cc=0
foreach uvar in `vlist' {
   local col`uvar': word `++cc' of `colors'
   * Here is the dot for the first threshold. label: `foo`uvar''
   local scatteri1 `"`scatteri1' (scatteri `slam`uvar'_1' `th`uvar'_1_1' "`foo`uvar''", mlabpos(`mlabpos`uvar'')  mcolor(`col`uvar'') msymbol(O) legend(off) mlabsize(2.5) ) "'
   local scatteri1 `"`scatteri1' (scatteri `slam`uvar'_1' `th`uvar'_1_2' ,  mcolor(`col`uvar'') msymbol(T) legend(off) mlabsize(2.5) ) "'
   local scatteri1 `"`scatteri1' (scatteri `slam`uvar'_1' `th`uvar'_1_1' `slam`uvar'_1' `th`uvar'_1_2'  , recast(line) lpat(dot) legend(off) ) "'
}

* scatterplot of loadings vs thresholds
di `"`scatteri1'"'
graph twoway ///
   `scatteri1' ///
   , xscale(range(-6 -1)) ///
   xtitle("Item location along the latent cognitive trait (higher is better)") ///
     ytitle("Factor loading") ///
   legend(off)
graph export load_thres_alignment_vision.png, replace width(3000)


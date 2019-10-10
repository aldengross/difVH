*use $derived/interim-difvh-120.dta, clear

*global makenewgraphs=0
if "`uvarset'"=="" {
   local uvarset "u8_"
}
*if "`sensevar'"=="" {
*   local sensevar "hearing" // just for testing
*   findname u8_*
*   local vlist "`r(varlist)'"
*}
*local sensevar "hearing" // hearing


findname `uvarset'*
local vlist "`r(varlist)'"
*local vlist "u_3 u_4 u_5 u_6 u_7 u_8 u_9 u_13 u_14 u_15 u_16" // for hearing, set 4
*local vlist "u_1 u_2 u_10 u_11 u_12 u_14 u_15" // for vision, set 4

use  "$derived/interim-difvh-120.dta" , clear
*cap erase alignmentvision.tex
*texdoc init alignmentvision ,force
*starttex , tex(alignmentvision.tex) arial

`samplecutstatement'

tex \newpage
tex \subsection{`sensevar' impairment - alignment analysis}
texdoc stlog
tab `sensevar'
texdoc stlog close

texdoc stlog
varlablist `vlist'
itemsummary `vlist'
texdoc stlog close

* DIF - alignment analysis 


local w1: word 1 of `vlist'

runmplus `vlist' `sensevar' , ///
   coverage(0) varnocheck ///
   cat(`vlist') ///
   variable( ///
      classes=d(2); ///
      knownclass=d(`sensevar'); ///
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
      f BY `vlist'*1;   ///
   ) output(stdyx; align; ) ///
   savelogfile( Results_`sensevar'`analysisset')

mat est`sensevar' = r(estimate)
local names: rowfullnames est`sensevar'
di "`names'"
lstrfun names , subinstr("`names'","$","_",.)
matrix rownames est`sensevar' = `names'

tex \subsection{Alignment output, `sensevar'}
tex Table `++tablecounter' \\

preserve
   clear
   infix str v1 1-85 using Results_`sensevar'`analysisset'.out
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


* OK. Show some ICCs now.

tex \newpage
tex \subsection{ICCs, `sensevar'}
if "`sensevar'" == "vision" {
   local labe1 "`sensevar' unimpaired"
   local labe2 "`sensevar' impaired"
}
if "`sensevar'" == "hearing" {
   local labe1 "`sensevar' unimpaired"
   local labe2 "`sensevar' impaired"
}
local grcm ""

foreach i in `vlist' { // *forvalues i=1/16 {
   distinct `i' // `uvarset'`i'
   local nthres`i' = `r(ndistinct)'-1
   foreach grpe in 1 2 {
      local aa`i'_`grpe' ""
      eme f_by_`i'_`grpe' , mat(est`sensevar')
      local a`i'_`grpe' : di %5.3f `r(r1)'
      local b`i'_`grpe' ""
      forvalues t=1 / `nthres`i'' {
         eme thresholds_`i'_`t'_`grpe', mat(est`sensevar')
         local b`i'_`grpe' "`b`i'_`grpe'' `r(r1)'"
         local b`i'_`t'_`grpe' = `r(r1)'
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
         range(-7 10) yscale(range(0 1)) ylabel(0(.2)1) xlabel(-7(1)10)
      graph save `grp'lo`i'.gph , replace
      icc_2pl , ///
         a(`aa`i'_2' ) b( `b`i'_2' ) ///
         title("`lab`i'' (`i') - `labe2'", size(vlarge)) ///
         xtitle("") ///
         ytitle("") ///
         legend(off) ///
         text(0.9 -3.7 "a=`a`i'_2'" , placement(e) size(large) ) ///
         range(-7 10) yscale(range(0 1)) ylabel(0(.2)1) xlabel(-7(1)10)
      graph save `grp'hi`i'.gph , replace
      graph combine `grp'lo`i'.gph `grp'hi`i'.gph , col(2) ///
         xsize(8) ysize(4) ycommon
      graph save icc_`grp'_`i'`analysisset'.gph , replace
      local grcm "`grcm' icc_`grp'_`i'`analysisset'.gph"
      graph export icc_`grp'_`i'`sensevar'`analysisset'.png , replace width(3000)
      local lab: var label `i'
   }
   lstrfun foo2 , subinstr("`i'","_","\_",.)

   tex Figure `++figurecounter'. `foo2': `lab' \\
   tex \begin{center}
   tex \includegraphics[width=.8\textwidth]{icc_`grp'_`i'`sensevar'`analysisset'.png}\\
   tex \end{center}
   texdoc stlog
   tab `i' `sensevar', nolab
   texdoc stlog close
}

/* For SER presentation - hearing DIF by DSST
local foo=`a9_1'-.2
forvalues i=1/4 {
   local scatteriu8_9_1 "`scatteriu8_9_1' `au8_9_1' `bu8_9_`i'_1' "
   local scatteriu8_9_2 "`scatteriu8_9_2' `foo' `bu8_9_`i'_2' "
}
local scatteri3_1 `"(scatteri `au8_9_1' `bu8_9_1_1' `au8_9_1' `bu8_9_4_1' , recast(line) lpat(solid) mcolor(black) lcolor(black) ) "'
local scatteri3_2 `"(scatteri `foo'     `bu8_9_1_2' `foo'     `bu8_9_4_2' , recast(line) lpat(solid) mcolor(red) lcolor(red) ) "'
* local b`i'_`t'_`grpe' = `r(r1)'
local size=3
* scatterplot of loadings vs thresholds
di in red "`scatteriu8_9_1'"
di in white "`scatteriu8_9_2'"
di in red   "`scatteri3_1'"
di in white "`scatteri3_2'"
graph twoway ///
   (scatteri `scatteriu8_9_1' , mlabpos(2)   mcolor(black) msymbol(O) legend(off)  ) ///
   (scatteri `scatteriu8_9_2' , mlabpos(2)   mcolor(red) msymbol(O) legend(off)  ) ///
   `scatteri3_1' ///
   `scatteri3_2' ///
   , xscale(range(-4 4)) ///
   xlabel(-4 -3 -2 -1 0 1 2 3 4 ,nogrid gmax) ///
   ///xtitle("Item location along the latent cognitive trait (higher is better)") ///
   ytitle("Factor loading (discrimination; unstandardized)", size(`size')) ///
   xtitle("Cognitive factor (Higher is better)", size(`size') ) ///
   legend(off) ///
   ylabel("",nogrid gmax) ///yscale(range(.3 .9)) ///
   graphregion(margin(l=1 r=0))  ///
   plotregion(style(none))
graph export ser_dsst.png, replace width(3000)
ddddddddddd
*/


*graph combine `grcm' , col(2) ///
*   xsize(10) ysize(16) altshrink
*graph export bigicc_`grp'`sensevar'.png, replace width(3000)

*tex \end{document}
*texdoc close
*texify alignmentvision.tex





* Graph of loadings vs thresholds

*findname `uvarset'*
*local vlist "`r(varlist)'"

qui foreach uvar in `vlist' {
   foreach grp in 1 2 {
      local foo`uvar': var label `uvar'
      eme f_by_`uvar'_`grp' , mat(est`sensevar')
      local slam`uvar'_`grp' : di %4.2f `r(r1)'
      eme thresholds_`uvar'_1_`grp' , mat(est`sensevar')
      local th`uvar'_1_`grp' : di %4.2f `r(r1)'
      distinct `uvar'
      local nthres`uvar' = `r(ndistinct)'-1
      nois di in red "eme thresholds_`uvar'_`nthres`uvar''_`grp'"
      eme thresholds_`uvar'_`nthres`uvar''_`grp' , mat(est`sensevar')
      local th`uvar'_L_`grp' = `r(r1)'
      nois di in red "thre. `th`uvar'_L_`grp''"
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
local colors "red orange green blue purple    black gs10 brown cyan orange   green pink orange     blue brown cyan"





local scatteri1 ""
local cc=0
foreach uvar in `vlist' {
   distinct `uvar'
   local nthres`uvar' = `r(ndistinct)'-1

   local col`uvar': word `++cc' of `colors'
   * Here is the dot for the first threshold. label: `foo`uvar''
   local scatteri1 `"`scatteri1' (scatteri `slam`uvar'_1' `th`uvar'_L_1' "`foo`uvar''", mlabpos(`mlabpos`uvar'') mlabcolor(`col`uvar'')  mcolor(`col`uvar'') msymbol(O) legend(off) mlabsize(2.5) ) "'
   local scatteri1 `"`scatteri1' (scatteri `slam`uvar'_1' `th`uvar'_L_2' ,  mcolor(`col`uvar'') msymbol(T) legend(off) mlabsize(2.5) ) "'
   local scatteri1 `"`scatteri1' (scatteri `slam`uvar'_1' `th`uvar'_L_1' `slam`uvar'_1' `th`uvar'_L_2'  , recast(line) lpat(dot) legend(off) ) "'
   * circle is the group 1, the vision unimpaired group. 
   * Triangles are the group 2, vision impaired group.
   
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
   graph export load_thres_alignment_`sensevar'`analysisset'.png, replace width(3000)
}
tex \subsection{Graph of loadings vs thresholds for `sensevar'}
tex Figure `++figurecounter' \\
tex \begin{center}
tex \includegraphics[width=1\textwidth]{load_thres_alignment_`sensevar'`analysisset'.png}\\
tex \end{center}

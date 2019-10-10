*use $derived/interim-difvh-125.dta, clear


if "`uvarset'"=="" {
   local uvarset "u_"
}
*local sensevar "vision" // hearing
*findname `uvarset'*
*local vlist "`r(varlist)'"
*local vlist "u_3 u_4 u_5 u_6 u_7 u_8 u_9 u_13 u_14 u_15 u_16" // for hearing, set 4
*local vlist "u_1 u_2 u_10 u_11 u_12 u_14 u_15" // for vision, set 4

* use "C:\Users\sdu7\Box Sync\R21_SENSE-MATTERS\DIFVH\POSTED\DATA\DERIVED\difvh_analysis-120.dta",clear 
use  "$derived/interim-difvh-120.dta" , clear
*cap erase alignmentvision.tex
*texdoc init alignmentvision ,force
*starttex , tex(alignmentvision.tex) arial

cap drop grp
gen grp = 0 if `sensevar'==0 & `demog'==0
replace grp = 1 if `sensevar'==1 & `demog'==0
replace grp = 2 if `sensevar'==0 & `demog'==1
replace grp = 3 if `sensevar'==1 & `demog'==1
cap label drop grp
label define grp 0 "0 `sensevar'==0, `demog'==0" 1 "1 `sensevar'==1, `demog'==0" 2 "2 `sensevar'==0, `demog'==1" 3 "3 `sensevar'==1, `demog'==1"
label values grp grp
tab grp
local sensevar "grp"

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
      classes=d(4); ///
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
      f BY `vlist';   ///
   ) output(stdyx; align; ) ///
   savelogfile( Results_`sensevar'`analysisset')

mat est`sensevar' = r(estimate)
local names: rowfullnames est`sensevar'
di "`names'"
lstrfun names , subinstr("`names'","$","_",.)
matrix rownames est`sensevar' = `names'

tex \subsection{Alignment output, `sensevar'}
tex Table `++tablecounter'. \\
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
local labe1 "Sensory unimpaired, `demog'==0"
local labe2 "Sensory impaired, `demog'==0"
local labe3 "Sensory unimpaired, `demog'==1"
local labe4 "Sensory impaired, `demog'==1"


local grcm ""

foreach i in `vlist' { // *forvalues i=1/16 {
   distinct `i' // `uvarset'`i'
   local nthres`i' = `r(ndistinct)'-1
   foreach grpe in 1 2 3 4 {
     local aa`i'_`grpe' ""
     eme f_by_`i'_`grpe' , mat(est`sensevar')
     local a`i'_`grpe' : di %5.3f `r(r1)'
     local b`i'_`grpe' ""
     forvalues t=1 / `nthres`i'' {
       eme thresholds_`i'_`t'_`grpe', mat(est`sensevar')
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
         title("`lab`i'' (`i') - `labe1'", size(medium)) ///
         xtitle("") ///
         ytitle("") ///
         legend(off) ///
         text(0.9 -3.7 "a=`a`i'_1'" , placement(e) size(large) ) ///
         range(-7 10) yscale(range(0 1)) ylabel(0(.2)1) xlabel(-7(1)10)
      graph save `grp'lo`i'.gph , replace
      icc_2pl , ///
         a(`aa`i'_2' ) b( `b`i'_2' ) ///
         title("`lab`i'' (`i') - `labe2'", size(medium)) ///
         xtitle("") ///
         ytitle("") ///
         legend(off) ///
         text(0.9 -3.7 "a=`a`i'_2'" , placement(e) size(large) ) ///
         range(-7 10) yscale(range(0 1)) ylabel(0(.2)1) xlabel(-7(1)10)
      graph save `grp'hi`i'.gph , replace

      icc_2pl , ///
         a(`aa`i'_3' ) b( `b`i'_3' ) ///
         title("`lab`i'' (`i') - `labe3'", size(medium)) ///
         xtitle("") ///
         ytitle("") ///
         legend(off) ///
         text(0.9 -3.7 "a=`a`i'_3'" , placement(e) size(large) ) ///
         range(-7 10) yscale(range(0 1)) ylabel(0(.2)1) xlabel(-7(1)10)
      graph save `grp'hi3`i'.gph , replace

      icc_2pl , ///
         a(`aa`i'_4' ) b( `b`i'_4' ) ///
         title("`lab`i'' (`i') - `labe4'", size(medium)) ///
         xtitle("") ///
         ytitle("") ///
         legend(off) ///
         text(0.9 -3.7 "a=`a`i'_4'" , placement(e) size(large) ) ///
         range(-7 10) yscale(range(0 1)) ylabel(0(.2)1) xlabel(-7(1)10)
      graph save `grp'hi4`i'.gph , replace

      graph combine `grp'lo`i'.gph `grp'hi`i'.gph `grp'hi3`i'.gph `grp'hi4`i'.gph , col(2) ///
         xsize(8) ysize(8) ycommon
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
   tab `i' `sensevar'
   texdoc stlog close
}
*graph combine `grcm' , col(2) ///
*   xsize(10) ysize(16) altshrink
*graph export bigicc_`grp'`sensevar'.png, replace width(3000)

*tex \end{document}
*texdoc close
*texify alignmentvision.tex




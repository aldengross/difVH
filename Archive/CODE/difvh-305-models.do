
* difvh-305-models.do
* Alden Gross
*  2 Aug 2018
* -----------------
*
  
*wfenv LasiDIF , a(lasi) alg

use $derived/interim-difvh-125.dta, clear

cap erase alignmentvision.tex
texdoc init alignmentvision
starttex , tex(alignmentvision.tex) arial

tex \section{Vision impairment}
texdoc stlog
tab va2040
texdoc stlog close

* DIF - alignment analysis 
* vision 
findname u*
local vlist "`r(varlist)'"
local w1: word 1 of `vlist'
/*
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

mat est = r(estimate)
local names: rowfullnames est
di "`names'"
lstrfun names , subinstr("`names'","$","_",.)
matrix rownames est = `names'
*/

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

local labe1 "Vision unimpaired"
local labe2 "Vision impaired"
local grcm ""
forvalues i=1/16 {
   distinct u`i'
   local nthres`i' = `r(ndistinct)'-1
   foreach grpe in 1 2 {
      local aa`i'_`grpe' ""
      eme f_by_u`i'_`grpe' , mat(est)
      local a`i'_`grpe' = `r(r1)'
      local b`i'_`grpe' ""
      forvalues t=1 / `nthres`i'' {
         eme thresholds_u`i'_`t'_`grpe', mat(est)
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
      ///xtitle("Latent cognitive trait") ///
      ///ytitle("P(Correct response)") ///
      ///legend(order(1 "HS or more") pos(10) ring(0) col(1)) ///
      legend(off) ///
      text(0.9 -3.7 "a=`a`i'_2'" , placement(e) size(large) ) ///
      range(-4 4) yscale(range(0 1)) ylabel(0(.2)1)
   graph save `grp'hi`i'.gph , replace
   graph combine `grp'lo`i'.gph `grp'hi`i'.gph , col(2) ///
      xsize(8) ysize(4) ycommon
   graph save icc_`grp'_u`i'.gph , replace
   local grcm "`grcm' icc_`grp'_u`i'.gph"
   graph export icc_`grp'_u`i'.png , replace width(3000)
   tex \newpage
   local lab: var label u`i'
   tex u`i': `lab' \\
   tex \begin{center}
   tex \includegraphics[width=.9\textwidth]{icc_`grp'_u`i'.png}\\
   tex \end{center}

}
graph combine `grcm' , col(2) ///
   xsize(10) ysize(16) altshrink
graph export bigicc_`grp'.png, replace width(3000)

tex \end{document}
texdoc close
texify alignmentvision.tex
ddddddddddddddddddddddddd





* Q: correlation between cognitive test items ? 

 capture log close 
 
 log using IRT_model_hearing.log, replace text 

 
 
 
 
 
local vlist " u1 u2   u10 u11 u12   u14 u15    "
local bptacat0 "No hearing impairment"
local bptacat1 "With hearing impairment"

noisily{
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
   ) model( ///
      %OVERALL% ///
      f BY `vlist';   ///
   ) output(stdyx; align; ) ///
   savelogfile( Resources)
   }
tab bptacat
   
mat est  = r(estimate)
 


log close 

 
 * ------------------------------------------------------------------------------------------------------
 
 /*
 
* DIF - MIMIC
// vision impairment _ va2040 
/*
sum rage_h
replace rage_h=rage_h-`r(mean)'
findname u*
*/

local varlist "u1 u2 u3 u4 u5 u6 u7 u8 u9 u10 u11 u12 u13 u14 u15   "
  sum `varlist'
mplusmimic , uvar(`varlist') groupvar(va2040 ) allowby(`varlist') ///
   mod(0) allowthreshold(`varlist')

 
 
 // hearing impairment _ bptacat 
local varlist "u1 u2 u3 u4 u5 u6 u7 u8 u9 u10 u11 u12 u13 u14 u15   "
 
mplusmimic , uvar(`varlist') groupvar(bptacat ) allowby(`varlist') ///
   mod(0) allowthreshold(`varlist') //xvar(rage_h )  lit res educ allowthreshold(`varlist')

 

 
* save $derived/interim-difvh-305.dta, replace


 
* drop v1 v2 v3 v4 v5 v6 v7


 /*
 
* The IRT model for cognitive screening items
findname u*

local vlist "u1 u2 u3 u4 u5 u6 u7 u8 u9 u10 u11 u12 u13 u14 u15"

local w1: word 1 of `vlist'

runmplus `vlist' idno , ///
   idvariable(idno) ///
   cat(`vlist' ) ///
   analysis(estimator=wlsmv;) ///
   model(moc BY `vlist' ; ///
      moc BY `w1'* ; ///
      moc@1; u6 WITH u10*; u8 WITH u9*; ) ///
   output(stdyx; modindices(-1); ) ///
   savedata(save=fscores ; ///
      file= moc.dat) ///
      savelogfile( moc)
mat est = r(estimate)



local names: rowfullnames est
di "`names'"
lstrfun names , subinstr("`names'","$","_",.)
matrix rownames est = `names'
 
* Merge in saved results
preserve
   runmplus_load_savedata , out(moc.out) clear
   sum
   keep id moc*
   tempfile data
   save `data'
restore
merge id  using `data', sort update
tab _merge
drop _merge


label var moc "Cognitive Factor Score (unidimensional)"
rename moc fcog

*/ 



 
}

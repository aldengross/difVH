* difvh-320-figure2.do
* Alden Gross
*  2 Aug 2018
* -----------------
*
use $derived/interim-difvh-305.dta, clear


local educ0 "No education"
local educ1 "Some education"
local lit0 "Illiterate"
local lit1 "Literate"
local res0 "Urban"
local res1 "Rural"

*texdoc stlog
foreach grp in educ lit res {
   tex \subsection{`grp'}
   noisily di in white "`grp'"
   *use `odata'  , clear
   *keep if `grp'!=.

   runmplus `vlist' `grp' , ///
      coverage(0) varnocheck ///
      cat(`vlist') ///
      variable( ///
         classes=d(2); ///
         knownclass=d(`grp'); ///
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
      savelogfile(c:\trash\gcpalignmentm`grp')
   mat est = r(estimate)

   *texdoc stlog close
   preserve
      clear
      infix str v1 1-85 using c:\trash\gcpalignmentm`grp'.out
      gen line = _n
      gen foo=. // use this to ID what i want to take.
      replace foo=1 if trim(v1)=="APPROXIMATE MEASUREMENT INVARIANCE (NONINVARIANCE) FOR GROUPS"
      * Now, forward-fill for 9 lines from each of these instances.
      tab foo
      forvalues i=1/60 {
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

   local names: rowfullnames est
   di "`names'"
   lstrfun names , subinstr("`names'","$","_",.)
   matrix rownames est = `names'

   local grcm ""
   forvalues i=1/11 {
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
         title("`lab`i'' (u`i') - ``grp'0'", size(vlarge)) ///
         xtitle("") ///
         ytitle("") ///
         ///xtitle("Latent cognitive trait") ///
         ///ytitle("P(Correct response)") ///
         ///legend(order(1 "Less than HS" ) pos(10) ring(0) col(1)) ///
         legend(off) ///
         range(-4 4) yscale(range(0 1)) ylabel(0(.2)1)
      graph save `grp'lo`i'.gph , replace
      icc_2pl , ///
         a(`aa`i'_2' ) b( `b`i'_2' ) ///
         title("`lab`i'' (u`i') - ``grp'1'", size(vlarge)) ///
         xtitle("") ///
         ytitle("") ///
         ///xtitle("Latent cognitive trait") ///
         ///ytitle("P(Correct response)") ///
         ///legend(order(1 "HS or more") pos(10) ring(0) col(1)) ///
         legend(off) ///
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

}

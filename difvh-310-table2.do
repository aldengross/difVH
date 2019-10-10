* difvh-310-table2.do
 
* Alden Gross
 
* -----------------
* Summary statistics from modeling
 use "C:\Users\sdu7\Box Sync\R21_SENSE-MATTERS\DIFVH\POSTED\DATA\DERIVED\interim-difvh-120.dta",clear 

tex \newpage
tex \begin{landscape}
tex \section{Parameters from the IRT measurement model}
tex Note. The IRT measurement model accounted for correlations
tex within a person by clustering on participants. \\[0.5cm]

tex \begin{longtable}{l cccc cccc ccc } \hline
tex Indicator & Factor loading, & Threshold \\
tex           & Raw (Standardized) \\
tex \hline
local names: rowfullnames est
di "`names'"




findname u*
local vlist "`r(varlist)'"
foreach x in `vlist' {
   eme moc_by_`x' , mat(est)
   local b`x' : di %4.2f `r(r1)'
   eme stdyx_moc_by_`x' , mat(est)
   local bs`x' : di %4.2f `r(r1)'

   distinct `x'
   local foo = `r(ndistinct)' -1
   local thr`x' ""
   forvalues i=1/ `foo' {
      eme thresholds_`x'_`i' , mat(est)
      local thr`x'`i' : di %4.2f `r(r1)'
      local thr`x' "`thr`x'' & `thr`x'`i''"
   }
   local foo: var label `x'
   tex `foo' (`x') & `b`x'' (`bs`x'') & `thr`x'' \\
}
tex \hline
tex \end{longtable}
tex \end{landscape}


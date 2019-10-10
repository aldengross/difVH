use  "$derived/interim-difvh-120.dta" , clear
/*
findname u_*
local varlist "`r(varlist)'"
mplusmimic , uvar(`varlist') groupvar(hearing ) allowby(`varlist') ///
   mod(0) allowthreshold(`varlist') //xvar(rage_h )  lit res educ allowthreshold(`varlist')
*/

* Mplus MIMIC

findname u_*
local varlist "`r(varlist)'"
local w1: word 1 of `varlist'
qui foreach u in `varlist' {
   local threslow ""
   local threshig ""
   sum `u', meanonly
   levelsof `u' if `u'!=`r(max)', local(levs`u')
   local mcs ""
   local mcdif ""
   local i=0
   foreach x in `levs`u'' {
      local thres "`thres' {`u'SS`++i'*} ;"
      local threslow "`threslow' [`u'SS`i'*] (ulow`x');"
      local threshig "`threshig' [`u'SS`i'*] (uhig`x');"
      local mcs "`mcs' d`x' "
      local mcdif "`mcdif' d`x' = uhig`x'-ulow`x';"
   }
   lstrfun thres , subinstr("`thres'","SS","$",.)
   lstrfun threslow , subinstr("`threslow'","SS","$",.)
   lstrfun threshig , subinstr("`threshig'","SS","$",.)
   local grpvar "vision"
   runmplus `varlist' `grpvar' , /// /*rage_h dm028_n*/
      variable(GROUPING IS `grpvar'(0=low 1=hig); ) ///
      cat(`varlist') ///
      model( ///
         f BY `w1' `varlist'; ///
         /// !u`u' ON `grpvar'; ! rage_h dm028_n; ///
         ///f ON rage_h (aa); f ON rgender_r (bb); ///
         f*; [f*]; ///
         {u_1@1 u_2@1 u_3@1 u_4@1 u_5@1 u_6@1 u_7@1 u_8@1 u_9@1 u_10@1 u_11@1 u_12@1 u_13@1 u_14@1 u_15@1 u_16@1 }; /// `thres' ///
         MODEL low: ///
            !f BY u`u'* (a1); f@1; [f@0]; ///
            `threslow' ///
         MODEL hig: ///
            !f BY u`u'* (a2); f*; [f*]; ///
            `threshig' ///
         MODEL CONSTRAINT: new( `mcs'); `mcdif' /// diflo=a1-a2;
      ) savelogfile(mimicme)
      mat est=r(estimate)
      mat se=r(se)
   noisily di "************ u`u'"
   /*
   *noisily eme new_diflo_rural , mat(est)
   noisily eme u`u'_on_res , mat(est)
   local est=`r(r1)'
   *noisily eme new_diflo_rural , mat(se)
   noisily eme u`u'_on_res , mat(se)
   local p=`est'/`r(r1)'
   noisily di "z=`p'"
   */
   foreach x in `mcs' {
      eme new_`x'_hig , mat(est)
      local est`x' = `r(r1)'
      eme new_`x'_hig , mat(se)
      local p=`est`x''/`r(r1)'
      noisily di "thres `x': z=`p'"
   }
}
describe u_*
 
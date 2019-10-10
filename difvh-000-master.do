* cd C:\Users\AldenGross\Dropbox\
* wftree , m(difvh) p(ALG DM SLW PR)
* !junction "c:\work\difvh" "C:\Users\alden\box sync\difvh"
* cd C:\work\difvh\POSTED\ANALYSIS
* automaster2 , m(biocard) u(Alden Gross) nvb // a(biocard)


wfenv difvh , alg
global makenewgraphs = 1 // possible values: 1 or 0


include $analysis/difvh-001-preambling.do
include $analysis/difvh-005-start-latex.do
include $analysis/difvh-105-call-source.do
include $analysis/difvh-110-create-variables.do
include $analysis/difvh-120-select-cases-for-analysis.do
include $analysis/difvh-205-table1.do
include $analysis/difvh-210-figure1-main-outcome-undadjusted.do

* analysis set 1
include $analysis/difvh-304-models-IRT.do

* analysis sets 2 and 3
foreach uvarset in u8_ { // u_ {
   if "`uvarset'"=="u8_" {
      local c =8
   }
   if "`uvarset'"=="u_" {
      local c =5
   }
   findname `uvarset'*
   local vlist "`r(varlist)'"

   tex \newpage
   tex \section{Analysis set `++analysisset'. Alignment analysis with `c' categories}
   foreach sensevar in vision hearing pva2040 {
      include $analysis/difvh-307-models-alignment.do
   }
}

* analysis set 4
tex \newpage
tex \section{Analysis set `++analysisset'. Alignment analysis with certain tests}
foreach uvarset in u8_ { // set 4
   foreach sensevar in vision hearing pva2040 {
      local vlist "${vlist`sensevar'}"
      include $analysis/difvh-307-models-alignment.do
   }
}

* analysis set 5
*include $analysis/difvh-308-models-mimic.do // analysis set 5. not working yet.
*local `++analysisset' //set 5
tex \newpage
tex \section{Analysis set `++analysisset'. MIMIC models}
tex Nothing pretty to report here, and a work in progress. But it does appear MIMIC models can 
tex replicate the DIF finding for u9 - DSST by hearing impairment status. \\

/* analysis sets 6,7,8,9
foreach demog in commonage educbi female white {
   tex \newpage
   tex \section{Analysis set `++analysisset'. Alignment analysis for `demog'==1}
   foreach uvarset in u8_ { // set 4
      use  "$derived/interim-difvh-120.dta" , clear
      findname `uvarset'*
      local vlist "`r(varlist)'"
      local samplecutstatement "keep if `demog'==1"
      foreach sensevar in vision hearing pva2040 {
         include $analysis/difvh-307-models-alignment.do
      }
      if "`demog'"!="commonage" {
         tex \newpage
         tex \section{Analysis set `++analysisset'. Alignment analysis for `demog'==0}
         local samplecutstatement "keep if `demog'==0"
    foreach sensevar in vision hearing {
       include $analysis/difvh-307-models-alignment.do
    }
      }
   }
   local samplecutstatement ""
}

* analysis sets 13-17
foreach demog in agemed educbi female white {
   tex \newpage
   tex \section{Analysis set `++analysisset'. Alignment analysis for 4-group categories involving `demog'}
   use  "$derived/interim-difvh-120.dta" , clear
   findname u8_*
   local vlist "`r(varlist)'"
   foreach sensevar in vision hearing pva2040 {
      include $analysis/difvh-309-models-alignment-4grp.do
   }
}
*/

*Include $Analysis/Difvh-305-Models-Alignment-Vision.Do
*Include $Analysis/Difvh-306-Models-Alignment-Hearing.Do
include $analysis/difvh-405-sensitivity-analyses.do
include $analysis/difvh-505-stuff-in-text.do
include $analysis/difvh-990-close-latex.do

/*
notes 9/17/19
CVLT long delay - we like this most. drop the other 2
vision: use best presenting acuity. pva2040
   va2040: best corrected.
hearing cutoffs: instead of 25, use 40. Drop the "middle" category.
   use 0 as exposed, 2 as unexposed, and drop group 1 for bptacat3.

BSW to send ALG updated vision/BLSA data
JD to send ALG updated hearing/BLSA data
JD to send ARIC data

check out the LORDIF approach
*/







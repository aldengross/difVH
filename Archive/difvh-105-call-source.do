* difvh-105-call-source.do
* Alden Gross
*  2 Aug 2018
* -------------------
* call data from source files
* (and process minimally in this file)

clear all
capture log close
 
local datanum=0

// open dataset


use  "$derived\20180316_w_BLSA_hneq_v0.0.dta", clear
lowercase
isid idno visit
rename age ageh
tempfile dat`++datanum'
save `dat`datanum'' , replace


use "$derived\vision_demo_allvisits2018.sas7bdat.dta", clear
lowercase
isid idno visit
rename age agev
drop visit_date typevis missed visvfdon visvfrnd
tempfile dat`++datanum'
save `dat`datanum'' , replace


use "$derived\cognition_allvisits2018.dta", clear
isid idno visit
tempfile dat`++datanum'
save `dat`datanum'' , replace


use `dat1', clear
forvalues i=2 / `datanum' {
   merge idno visit using `dat`i'' , sort update
   tab _merge
   rename _merge merge`i'
} 
checkvar merge* 
 
keep if merge2==3
keep if inlist(merge3,3,4)==1
codebook idno
 
 lowercase
 *
save "$derived/difvh_analysis-105.dta" , replace
*
 
 
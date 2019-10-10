* difvh-105-call-source.do
* Alden Gross
*  2 Aug 2018
* -------------------
* call data from source files
* (and process minimally in this file)

clear all
capture log close
log using vision_cog.log, replace 

local datanum=0

// open dataset
* add this: blsa_tot_vision_0919_plusage.sas7bdat

use  $source\20180316_w_BLSA_hneq_v0.0.dta, clear
lowercase
isid idno visit
rename age ageh
tempfile dat`++datanum'
save `dat`datanum'' , replace


inputst $source\vision_demo_allvisits2018.sas7bdat
lowercase
isid idno visit
rename age agev
drop visit_date typevis missed visvfdon visvfrnd
tempfile dat`++datanum'
save `dat`datanum'' , replace


inputst $source\cognition_allvisits2018.sas7bdat
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
save $derived/difvh_analysis-105.dta , replace
*
 
 
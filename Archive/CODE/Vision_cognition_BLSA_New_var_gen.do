




// house keeping 
clear all
capture log close
log using vision_cog.log, replace 
 

// open dataset

cd "C:\Users\sdu7\Box Sync\R21_SENSE-MATTERS\DIFVH\POSTED\ANALYSIS"

import delimited "C:\Users\sdu7\Box Sync\R21_SENSE-MATTERS\DIFVH\POSTED\DATA\SOURCE\DIGITSYM.csv",clear 
 save "C:\Users\sdu7\Box Sync\R21_SENSE-MATTERS\DIFVH\POSTED\DATA\DERIVED\dss.dta",replace

import delimited "C:\Users\sdu7\Box Sync\R21_SENSE-MATTERS\DIFVH\POSTED\DATA\SOURCE\MMS.csv",clear 
 save "C:\Users\sdu7\Box Sync\R21_SENSE-MATTERS\DIFVH\POSTED\DATA\DERIVED\mms.dta",replace 


use  "C:\Users\sdu7\Box Sync\R21_SENSE-MATTERS\DIFVH\POSTED\DATA\DERIVED\cognition_all.dta",clear 


// merge dataset

merge 1:1 idno visit using "C:\Users\sdu7\Box Sync\R21_SENSE-MATTERS\DIFVH\POSTED\DATA\DERIVED\vision_demo_all.dta"
drop _merge
merge 1:1 idno visit using "C:\Users\sdu7\Box Sync\R21_SENSE-MATTERS\DIFVH\POSTED\DATA\DERIVED\dss.dta",force
keep if _merge != 2
drop _merge
/*merge 1:1 idno visit using "C:\Users\sdu7\Box Sync\R21_SENSE-MATTERS\DIFVH\POSTED\DATA\DERIVED\mms.dta",force
keep if _merge !=2 
codebook,com 
*/
duplicates report idno 

// label
label var mmstot "Mini Mental State Exam"
label var dsstot "Digit Symbol Substitution Test"


 // log transformation and standardization 

 /*
 // log transformation and standardization 
 capture drop trtdif logtrtdif
 gen trtdif = trbts - trats 
 gen logtrtdif = log10(trtdif+ 42) // 42 is the median of logtrtdif 
 label var logtrtdif "log transform trailB-trailA"
 sum logtrtdif
 */
 
 foreach trans in  trats trbts  {
 capture drop log`trans'
 gen log`trans' = log10(`trans')
 label var log`trans' "Log transform `trans'"
 codebook log`trans',com
 }
 
// 



 //winsorizing 
  
 foreach v in    trats trbts  {
 capture drop win`v'
 winsor `v', gen(win`v') p(0.05) high
 label var win`v' "winsorized `v'"
 codebook `v' win`v',com
 }
 
 // inverse , reciprocal 
 
  foreach v in    trats trbts  {
 capture drop rev`v'
 gen rev`v'= 60/`v'
 label var rev`v' "reciprocal `v'"
 }

 capture drop revbvrtot
 gen revbvrtot = 1/bvrtot
 label var revbvrtot  "reciprocal Benton visual test "
 codebook revtrats revtrbts revbvrtot
 foreach v in revtrats revtrbts revbvrtot {
hist `v',freq normal
 graph save "`v'",replace
 }
 graph combine "revtrats" "revtrbts" "revbvrtot"
 graph save "hist_tran",repalce

 
  foreach v in revtrats revtrbts revbvrtot {
  graph box `v' 
 graph save "`v'",replace
 }
 graph combine "revtrats" "revtrbts" "revbvrtot"
 graph save "box_tran",replace
 
 
 
 
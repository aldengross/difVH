*difvh-Exploratory data analysis - EDA.do
*Simo
* 3rd Aug. 2018
* -------------------





cd "C:\Users\sdu7\Box Sync\R21_SENSE-MATTERS\DIFVH\POSTED\ANALYSIS"
* ------------------- ARIC neurocognitive data  -------------------
/* Q:
1) why no clockwise and WRAT
2) cognitive score distribution, my way of dealing with incident learning?
3) different domians and global cognitive test scores? Which cogntive test is more commonly used in analysis? 
4) hearing and cognitive fucntions reserach: use how many categories? 2? 3? 4? 
5)  Resources: BLSA codebook, cognitive datasets
6)  What does the number mean ? 

*/
clear all
capture log close
log using hear_cog.log , replace
use "C:\Users\sdu7\Box Sync\R21_SENSE-MATTERS\DIFVH\POSTED\DATA\DERIVED\vision_cognition_BLSA.dta",clear 

// explore datasets 

codebook,com 

/* only keep the first vision viist 

sort vision_visit
bys idno: gen tag = _n
keep if tag ==1 
*/












































*/









* ------------------- ARIC neurocognitive data  -------------------
/* Q:
1) why no clockwise and WRAT
2) cognitive score distribution, my way of dealing with incident learning?
3) different domians and global cognitive test scores? Which cogntive test is more commonly used in analysis? 
4) hearing and cognitive fucntions reserach: use how many categories? 2? 3? 4? 
5)  Resources: BLSA codebook, cognitive datasets
6)  What does the number mean ? 

*/

cd "C:\Users\sdu7\Box Sync\R21_SENSE-MATTERS\DIFVH\POSTED\ANALYSIS"
clear all
capture log close
log using hear_cog.log , replace

use "C:\Users\sdu7\Box Sync\CCHPH\ARIC\projects\ARIC-Missingness\data\hearing_cognition_visit6.dta",clear

// extract neurocognitive vars , rename and label
//  generate variables with new names 
gen dss  =   ncs2b 
gen wr   =   ncs3b 
gen incl =   ncs4b + ncs4c
gen wf   =   ncs5e 
gen an   =   ncs6b 
gen lm1  =   ncs7d 
gen dsb  =   ncs8b 
gen tmta =   ncs9e 
gen tmtb=    ncs10e
gen bnt =    ncs12b
gen smell=   ncs14b   
gen lm2 =    ncs15d    



 // Label variables 
 
 
label var   dss       "Digit Symbol Substitution Test" 
label var   wr        "Word Recall" 
label var   incl      "Incidental learning" 
label var   wf        "Word Fulency" 
label var   an        "Animal Naming Test" 
label var   lm1       "Logical Memory I" 
label var   dsb       "Digit Span Backwards" 
label var   tmta      "Trail Making Test A" 
label var   tmtb      "Trail Making Test B" 
label var   bnt       "Boston Naming Test"
label var   smell      "Smell Test"  
label var   lm2        "Logical Memory II"  



* 1) Outcome exploration

// summary statistics 
codebook dss wr incl wf an lm1 dsb tmta tmtb bnt smell lm2,com

quietly {
foreach x in  dss wr incl wf an lm1 dsb tmta tmtb bnt smell lm2 { 
hist `x', freq normal
graph save `x' ,replace
}

graph combine "dss" "wr" "incl" "wf" "an" "lm1""dsb""tmta" "tmtb" "bnt" "smell" "lm2", altshrink
graph export hist.png ,replace


// correlation between each test

// CORRELATION MATRIX PLOT
corr dss wr incl wf an lm1 dsb tmta tmtb bnt smell lm2
graph matrix dss wr incl wf an lm1 dsb tmta tmtb bnt smell lm2,half msize(vsmall)
graph export corr_martrix.png,replace 

*2) correlation betwen cognitive test and hearing loss

// boxplot 

quietly {
foreach x in  dss wr incl wf an lm1 dsb tmta tmtb bnt smell lm2 { 
graph box `x',over(bptacat)
graph save `x',replace
}
graph combine "dss" "wr" "incl" "wf" "an" "lm1""dsb""tmta" "tmtb" "bnt" "smell" "lm2", altshrink
}

graph export box.png  ,replace



quietly {
foreach x in  dss wr incl wf an lm1 dsb tmta tmtb bnt smell lm2 { 
graph box `x',over(bptacat4)
graph save `x',replace
}
graph combine "dss" "wr" "incl" "wf" "an" "lm1""dsb""tmta" "tmtb" "bnt" "smell" "lm2" ,col(4) ///
   altshrink

 /*graphregion(color(white) lcolor(white) margin(small))  ///
			  plotregion(fcolor(white) margin(small)) ///
			  imargin(0 0 ) title("") 
			  */
}

graph export box_cat4.png  ,replace



/* UPTACAT 

// boxplot 



quietly {
foreach x in  dss wr incl wf an lm1 dsb tmta tmtb bnt smell lm2 { 
graph box `x',over(uptacat)
graph save `x',replace
}
graph combine "dss" "wr" "incl" "wf" "an" "lm1""dsb""tmta" "tmtb" "bnt" "smell" "lm2", altshrink
}

graph export box_upta.png  ,replace



quietly {
foreach x in  dss wr incl wf an lm1 dsb tmta tmtb bnt smell lm2 { 
graph box `x',over(uptacat4)
graph save `x',replace
}
graph combine "dss" "wr" "incl" "wf" "an" "lm1""dsb""tmta" "tmtb" "bnt" "smell" "lm2" ,col(4) ///
   altshrink

 /*graphregion(color(white) lcolor(white) margin(small))  ///
			  plotregion(fcolor(white) margin(small)) ///
			  imargin(0 0 ) title("") 
			  */
}

graph export box_upta_cat4.png  ,replace



*/



//  table1


table1_mc, by(bptacat) ///
vars(dss contn \ wr contn \incl contn \wf contn \an contn \lm1 contn \dsb contn \tmta conts \tmtb conts \bnt conts \smell contn \lm2 contn ) ///
format(%4.2f) saving(table1.xls, replace) 







***************************** OTHER VARS *************************8
/*
 cont: cesd61 walkspeed15ft61 age
 cate: elevel02 self_hl  race sex 

 
 //mplus
 
 
local varlist "incl wr wf an lm1 tmta tmtb bnt"
* hhi_total 

runmplus `varlist' , model(f BY `varlist';)


return list
local rmsea = r(RMSEA)
di "`rmsea'"
mat list r(estimate)
mat est =r(estimate)
plotmatrix ,mat(est) 
pwd


*/

 log close



























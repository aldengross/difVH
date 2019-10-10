* difvh-110-create-variables.do
* Alden Gross
*  2 Aug 2018

 
use $derived/difvh_analysis-105.dta, clear
drop u*

capture drop visnum
bys idno: egen visnum=rank(visit)
tab visnum
 
 // generate hearing related var
// bpta_continuous 
 
rename   aud_r_500hz        aud4a3  
rename   aud_r_1000hz      aud4a7   
rename   aud_r_2000hz      aud4a9   
rename    aud_r_4000hz   aud4a13

 rename  aud_l_500hz        aud4b3  
rename   aud_l_1000hz      aud4b7   
rename   aud_l_2000hz      aud4b9   
rename    aud_l_4000hz   aud4b13

// generate average PTA for right & left ear 
foreach x in ptar bpta ptal bptacat3  bptacat bptacat4 {
   capture drop `x'
}

gen ptar=(aud4a3 + aud4a7 + aud4a9 + aud4a13)/4          //
   gen ptal=(aud4b3 + aud4b7 + aud4b9 + aud4b13)/4          //
      label var                                    ///
      ptar                                      ///
      "PTA Right"                                  //
   label var                                       ///
      ptal                                      ///
      "PTA Left"                                   //
 

 // gen continuous var  
gen bpta = min(ptar, ptal) if !missing(ptar) & !missing(ptal)
label var bpta "better ear hearing"

 codebook   ptar ptal bpta bpta_3f bpta_4f ,com // check the vars
  
// gen binary var 
gen bptacat = (bpta >25 ) if!missing(bpta)
label var bptacat "PTA binary <=25 vs. >25"                    //
label define bcat 1 "1 Hearing Impairment" 0 "0 Normal Hearing"
label values bptacat bcat

gen bptacat3 = 0 if bpta_4f  <=25 
replace bptacat3 =1 if bpta_4f  >25  & bpta_4f  <= 40 
replace bptacat3 =2 if bpta_4f  >40 & !missing(bpta_4f ) 

label var bptacat3 "PTA 3 categories, better ear "
label values bptacat3 cat3
label define cat3  0 "<=25 db"                              ///
      1 ">25 & <=40 db"                            ///
      2 ">40 "                            ///

codebook bptacat3
tab bptacat3

gen bptacat4 = 0 if bpta_4f  <=25 
replace bptacat4 =1 if bpta_4f  >25  & bpta_4f  <= 40 
replace bptacat4 =2 if bpta_4f  >40 & bpta_4f  <=60 
replace bptacat4 =3 if bpta_4f  > 60 & !missing(bpta_4f )

label var bptacat4 "PTA 4 categories, better ear "
label values bptacat4 cat4
label define cat4  0 "<=25 db"                              ///
      1 ">25 & <=40 db"                            ///
      2 ">40 & <=60 db"                            ///
      3 ">60 db"  
codebook bptacat4
tab bptacat4
   
// transform variables 
foreach trans in  trats trbts  {
 capture drop log`trans'
 gen log`trans' = log10(`trans')
 label var log`trans' "Log transform `trans'"
 codebook log`trans',com
}
 tab1 trats trbts  



local att  "digfor digbac logtrats                          "
local exe  "logtrbts crdrot simtot  clk325 clk1110 dsstot "
local memo "cvltca cvlfrs cvlfrl bvrtot                  "
local lan  "flucat flulet boscor                         " 

 
cap drop u*
codebook    `att' `exe' `memo' `lan'  , com 
  
  replace flucat=25 if inrange(flucat,25,44)==1
 replace crdrot=. if crdrot<0
 replace flucat=. if flucat>90
 replace flulet=. if flulet>90
 replace boscor=. if boscor>90
 replace digfor=4 if inrange(digfor,0,4)==1
 replace digfor=12 if inrange(digfor,12,14)==1
replace digbac=3 if inrange(digbac,0,3)==1
 replace digbac=12 if inrange(digbac,12,13)==1
 replace boscor=44 if boscor<44
 replace  simtot=12 if  simtot<12
 replace  simtot=26 if  simtot==27
 replace clk325=5 if clk325<5
 replace clk1110=6 if clk1110<6
 replace bvrtot=22 if inrange(bvrtot,22,66)==1
 * note bvrtot is an error variable. rescale so higher is better
 replace bvrtot=22-bvrtot
 replace logtrats=2 if inrange(logtrats,2,10)==1
 replace logtrats=1.2 if inrange(logtrats,0,1.2)==1
 foreach x in logtrats logtrbts {
   replace `x'=60/`x'
 }
 sum `att' `exe' `memo' `lan'  
pwcorr `att' `exe' `memo' `lan' 
 distinct `att' `exe' `memo' `lan' 
 
 // discretinize the cognitve variables ? 
 * item For the rest of the variables, we used a percentile dicretization approach to discretize variables into up to 5 categories


local i=0
foreach x in `att' `exe' `memo' `lan' {
   distinct `x'
   if `r(ndistinct)'<=7 { //10
      cap drop u`++i'
      clonevar u`i' = `x'
   }
   else {
      cap drop u`++i'
      dtize3 `x' , bins(7) //6
      rename `x'_cat u`i'
      local foo: var label `x'
      label var u`i' "`foo'"
   }
 }
 findname u*
 foreach x in `r(varlist)' {
   cap drop foo
   egen foo=group(`x')
   replace `x'=foo
 }
 replace u4=8 if u4==9
 replace u9=7 if u9==8
 replace u14=8 if u14==9
 replace u14=2 if u14==1
 replace u15=2 if u15==1
findname u*
foreach x in `r(varlist)' {
   cap drop foo
   egen foo=group(`x')
   replace `x'=foo
}
itemsummary u*

label var u1 "DSF"
label var u2 "DSB"
label var u5 "Card rotations"
label var u9 "DSST"
label var u11 "CVLT short delay"
label var u12 "CVLT long delay"
label var u14 "Verbal fluency"
label var u16 "BNT60"



cap drop hascog
gen hascog=.
foreach x in ///
   digfor digbac logtrats                       ///
   logtrbts crdrot simtot  clk325 clk1110 dsstot ///
   cvltca cvlfrs cvlfrl bvrtot                   ///
   flucat flulet boscor {
   replace hascog=1 if `x'!=.
}


codebook idno if hascog==1 & bptacat !=. & va2040!=.
cap drop vis
bys idno: egen vis = rank(visit) if hascog==1 & bptacat !=. & va2040!=.

tab vis

cap label drop va2040
label define va2040 0 "0 Unimpaired" 1 "1 Impaired"
label values va2040 va2040
tab va2040

save $derived\difvh_analysis-110.dta ,replace 

 
 
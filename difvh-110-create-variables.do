* difvh-110-create-variables.do
* Alden Gross
*  2 Aug 2018

set seed 8675309 // even if not sure needed, set it anyway

use "$derived/difvh_analysis-105.dta", clear
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
      "PTA Right"           
   label var                                       ///
      ptal                                      ///
      "PTA Left"        
 

 // gen continuous var  
gen bpta = min(ptar, ptal) if !missing(ptar) & !missing(ptal)
label var bpta "better ear hearing"

 codebook   ptar ptal bpta bpta_3f bpta_4f ,com // check the vars
  
// gen binary var 
*hearing cutoffs: instead of 25, use 40. Drop the "middle" category.
*   use 0 as exposed, 2 as unexposed, and drop group 1 for bptacat3.
gen bptacat = (bpta >40 ) if!missing(bpta)
label var bptacat "PTA binary <=40 vs. >40"                    //
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

* vision and hearing variables.
cap label drop va2040
label define va2040 0 "0 Unimpaired" 1 "1 Impaired"
label values va2040 va2040
tab va2040

clonevar vision =va2040 
clonevar hearing=bptacat 
label var pva2040 "Best presenting visual acuity"
cap label drop pva2040 
label define pva2040 0 "0 Unimpaired" 1 "1 Impaired"
label values pva2040 pva2040 
tab pva2040 


cap drop hascog
gen hascog=.
foreach x in ///
   digfor digbac trats                       ///
   trbts crdrot simtot  clk325 clk1110 dsstot ///
   cvltca cvlfrs cvlfrl bvrtot                   ///
   flucat flulet boscor {
   replace hascog=1 if `x'!=.
}

rename age agetv
bys idno: egen age=min(agetv)

cap drop vis
bys idno: egen vis = rank(visit) if hascog==1 & bptacat !=. & va2040!=.

cap drop maxvis
bys idno: egen maxvis = max(vis) if hascog==1 & bptacat !=. & va2040!=. & age >= 55 



// transform variables 
foreach trans in  trats trbts  {
   capture drop log`trans'
   gen log`trans' = ln(`trans')
   label var log`trans' "Log transform `trans'"
   codebook log`trans',com
}
 tab1 trats trbts  



local att  "digfor digbac trats                          "
local exe  "trbts crdrot simtot  clk325 clk1110 dsstot "
local memo "cvltca cvlfrs cvlfrl bvrtot                  "
local lan  "flucat flulet boscor                         " 
local varlist "`att' `exe' `memo' `lan'"
distinct `varlist'
cap drop u*
codebook    `varlist'  ,com 
  
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
replace simtot=12 if  simtot<12
replace simtot=26 if  simtot==27
replace clk325=6 if clk325<6
replace clk1110=6 if clk1110<6
replace cvlfrl=3 if cvlfrl<3
replace cvlfrs=1 if cvlfrs==0
replace cvltca=20 if cvltca<20
replace bvrtot=22 if inrange(bvrtot,22,66)==1
* note bvrtot is an error variable. rescale so higher is better
replace bvrtot=22-bvrtot
replace dsstot=65 if inrange(dsstot,65,88)==1
sum trats trbts
replace trats=90 if inrange(trats,90,500)==1
foreach x in trats trbts { // reverse scale Trails tests
   replace `x'=60/`x'
}
replace trats=4 if inrange(trats,4,7)==1
replace trbts=1.5 if inrange(trbts,1.5,3)==1

sum `varlist'
pwcorr `varlist'
distinct `varlist'

* discretize the cognitve variables
* item For the rest of the variables, we used a percentile dicretization 
* approach to discretize variables into up to 8 categories

tex \newpage
tex \section{Data processing note - discretization}
tex Cognitive tests were discretized into either up 8 categories or up to 5 
tex categories (as a sensitivity analysis).
tex We used an equal interval discretization method in both cases, collapsing
tex adjoining categories if one category had less than 5 percent of the records
tex in the dataset or if any indicator had 0 records in either the vision 
tex or hearing impaired group. \\
************** 8 CATEGORIES ************** 
tex 
local i=0
foreach x in `varlist' {
   distinct `x'
   if `r(ndistinct)'<=8 {
      cap drop u8_`++i'
      clonevar u8_`i' = `x'
   }
   else {
      cap drop u8_`++i'
      dtize3 `x' , bins(8)
      rename `x'_cat u8_`i'
      local foo: var label `x'
      label var u8_`i' "`foo'"
   }
   * cycle now through every u8_* variable. if a category is under 5%, collapse it into an adjoining category.
   * also if any variable has a 0 cell with vision or hearing, collapse it into an adjoining category.
   levelsof u8_`i' , local(cats)
   sum u8_`i' , meanonly
   local max`i' = `r(max)'
   local n`i' = `r(N)'
   foreach u in `cats' {
      sum u8_`i' if u8_`i'==`u'
      if (`r(N)'/`n`i'')<0.06 & `u' < `max`i'' {
         replace u8_`i'=u8_`i'+1 if u8_`i'==`u'
      }
      if (`r(N)'/`n`i'')<0.06 & `u' == `max`i'' {
         replace u8_`i'=u8_`i'-1 if u8_`i'==`u'
      }
   }
   * If any variable has a 0 cell with vision or hearing, collapse it into an adjoining category.
   levelsof u8_`i' , local(cats)
   sum u8_`i' , meanonly
   local max`i' = `r(max)'
   local n`i' = `r(N)'
   foreach u in `cats' {
      foreach vh in vision hearing {
    sum u8_`i' if u8_`i'==`u' & `vh'==1 & age >= 55 & vis==maxvis
    if (`r(N)')<4 & `u' < `max`i'' {
       replace u8_`i'=u8_`i'+1 if u8_`i'==`u'
         }
    if (`r(N)')<4 & `u' == `max`i'' {
            replace u8_`i'=u8_`i'-1 if u8_`i'==`u'
    }
      }
   }
}
*itemsummary u8_*

************** 5 CATEGORIES ************** 
local i=0
foreach x in `varlist' {
   distinct `x'
   if `r(ndistinct)'<=5 {
      cap drop u_`++i'
      clonevar u_`i' = `x'
   }
   else {
      cap drop u_`++i'
      dtize3 `x' , bins(5)
      rename `x'_cat u_`i'
      local foo: var label `x'
      label var u_`i' "`foo'"
   }
   * cycle now through every u8_* variable. if a category is under 5%, collapse it into an adjoining category.
   levelsof u_`i' , local(cats)
   sum u_`i' , meanonly
   local max`i' = `r(max)'
   local n`i' = `r(N)'
   foreach u in `cats' {
      sum u_`i' if u_`i'==`u'
      if (`r(N)'/`n`i'')<0.06 & `u' < `max`i'' {
         replace u_`i'=u_`i'+1 if u_`i'==`u'
      }
      if (`r(N)'/`n`i'')<0.06 & `u' == `max`i'' {
         replace u_`i'=u_`i'-1 if u_`i'==`u'
      }
   }
   * If any variable has a 0 cell with vision or hearing, collapse it into an adjoining category.
   levelsof u_`i' , local(cats)
   sum u_`i' , meanonly
   local max`i' = `r(max)'
   local n`i' = `r(N)'
   foreach u in `cats' {
      foreach vh in vision hearing {
    sum u_`i' if u_`i'==`u' & `vh'==1 & age >= 55 & vis==maxvis
    if (`r(N)')<4 & `u' < `max`i'' {
       replace u_`i'=u8_`i'+1 if u_`i'==`u'
         }
    if (`r(N)')<4 & `u' == `max`i'' {
            replace u_`i'=u_`i'-1 if u_`i'==`u'
    }
      }
   }
}

findname u_*
foreach x in `r(varlist)' {
   di in red "*********** `x'"
   tab `x' va2040 , nolab
   tab `x' bptacat, nolab
}
/*
replace u8_2=6 if u8_2==7
replace u8_3=5 if u8_3==6 | u8_3==7
replace u8_4=4 if u8_4==5 | u8_4==6 | u8_4==7
replace u8_9=5 if u8_9==6
replace u8_10=1 if u8_10==0
replace u8_12=1 if u8_12==0
replace u8_14=5 if u8_14==6 | u8_14==7
replace u8_15=5 if u8_15==6
replace u8_15=1 if u8_15==0

replace u_3 = 3 if u_3 == 4
replace u_4 = 3 if u_4 == 4
replace u_9 = 3 if u_9 == 4
replace u_14 = 3 if u_14 ==4
replace u_15 = 1 if u_15 == 0
replace u_15 = 3 if u_15 == 4
*/
findname u*
foreach x in `r(varlist)' {
   cap drop foo
   egen foo=group(`x')
   replace `x'=foo
}

foreach x in u8 u {
   label var `x'_1 "DSF"
   label var `x'_2 "DSB"
   label var `x'_3 "TMT-A"
   label var `x'_4 "TMT-B"
   label var `x'_5 "Card rotations"
   label var `x'_6 "Similarities"
   label var `x'_7 "Clock 3:35"
   label var `x'_8 "Clock 11:10"
   label var `x'_9 "DSST"
   label var `x'_10 "CVLT sum"
   label var `x'_11 "CVLT short delay"
   label var `x'_12 "CVLT long delay"
   label var `x'_13 "BVRT"
   label var `x'_14 "Animals"
   label var `x'_15 "Letters"
   label var `x'_16 "BNT60"
}

itemsummary u8_*
itemsummary u_*


itemsummary u8_* if hascog==1 & bptacat !=. & va2040!=. & age >= 55 & vis==maxvis
itemsummary u_* if hascog==1 & bptacat !=. & va2040!=. & age >= 55 & vis==maxvis

codebook idno if hascog==1 & bptacat !=. & va2040!=.

tab vis

* demographic categories
* these cutoffs derived by running this code from 120.do.
bys vision: sum agetv
bys hearing: sum agetv
cap drop commonage
gen commonage=1 if inrange(agetv,60,90)==1
replace commonage=0 if commonage==.
cap drop agemed
gen agemed = (agetv>77) if agetv!=. // should be 75, but there are very few vision-impaired young people.
cap label drop agemed
label define agemed 0 "0 Young" 1 "1 Old"
label values agemed agemed


cap drop educbi
gen educbi=(educat==4) if educat!=.
cap label drop educbi
label define educbi 0 "0 Low" 1 "1 High"
label values educbi educbi 
* less than HS; HS; college; graduate school

gen female = male*-1+1
cap label drop female
label define female 0 "0 Male" 1 "1 Female"
label values female female

gen white = (racecd==1) if racecd!=.
cap label drop white
label define white 0 "0 Nonwhite" 1 "1 white"
label values white white

cap label drop nothing
label define nothing -1 "-1"
label values u* nothing
tab1 u*


save "$derived\difvh_analysis-110.dta" ,replace 


findname u8_*
foreach x in `r(varlist)' {
   di in red "*********** `x'"
   tab `x' vision , nolab , if hascog==1 & hearing !=. & vision!=. & age >= 55 & vis==maxvis
   *tab `x' hearing, nolab , if hascog==1 & hearing !=. & vision!=. & age >= 55 & vis==maxvis
}


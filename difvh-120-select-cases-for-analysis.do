* difvh-120-select-cases-for-analysis.do
* Alden Gross
*  2 Aug 2018
* -------------------
 
use "$derived\difvh_analysis-110.dta", clear

 // exclude baseline visit 
  // Non-missing hearing visual vars 

* keep records if there is cognition AND vision AND hearing
keep if hascog==1 & hearing !=. & vision!=.
// select only those who are older than 55 
keep if age >= 55 
// select recent visit cases
*cap drop maxvis
*bys idno: egen maxvis = max(vis) if hascog==1 & bptacat !=. & va2040!=. & age >= 55 
keep if vis==maxvis
codebook idno

* re-consider the discretizations
/*itemsummary u*
replace u3=2 if u3==1
replace u4=2 if u4==1
replace u5=2 if u5==1
replace u6=3 if u6<3
replace u7=2 if u7==1
replace u9=2 if u9==1
replace u10=2 if u10==1
replace u10=7 if u10==8
replace u11=2 if u11==1
replace u12=3 if u12<3
replace u15=6 if u15==7
itemsummary u*
*/
findname u*
foreach x in `r(varlist)' {
   cap drop foo
   egen foo=group(`x')
   replace `x'=foo
}
itemsummary u*

bys vision: sum agetv
bys hearing: sum agetv

* 9/17/19 decision: drop CVLT immediate and short delay items
drop u_10 u_11
drop u8_10 u8_11

save "$derived/interim-difvh-120.dta" , replace



// sensitivity analysis _ exclude  baseline visit 
use "$derived/interim-difvh-120.dta", clear
findname u_*
foreach x in `r(varlist)' {
   di in red "*********** `x'"
   tab `x' vision , nolab
   tab `x' hearing, nolab
}
keep if visit != 1 
save "$derived/interim-difvh-125.dta", replace




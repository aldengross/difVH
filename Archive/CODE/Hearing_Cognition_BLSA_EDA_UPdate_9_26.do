

* DIF _EDA_ hearing and cognition 
* Author: Simo
* 9/26
// hearing and cognition in BLSA 
/*
1_exclude those who have 77 tag
2_check extreme value for word fluency 
3_transformation multiplying -1
4_cognitive data









*/
  

// house keeping 
capture log close _all
log using hearing_cog.log, replace text  // start logfile
version 10 //I'm using Stata 15, but some students may have earlier versions
clear all //clear all data from memory
macro drop _all //clear all macros in memory
set more off   //give output all at once (not one screenful at a time)
set linesize 80 //maximum allowed width for output


*** Part one _Hearing ***



cd "C:\Users\sdu7\Box Sync\R21_SENSE-MATTERS\DIFVH\POSTED\ANALYSIS"

/*
//open datasets 

import excel "C:\Users\sdu7\Box Sync\R21_SENSE-MATTERS\DIFVH\POSTED\DATA\SOURCE\BLSA_hearing_noise_teleform.xlsx", ///
sheet("Blsa_hearing_noise_teleform") firstrow clear

// explore datasets
// rename the datasets

 
rename	HNEQtid	hneqtid	
rename	HNEQdate	hneqdate	
rename	HNEQ14tid	hneq14tid	
rename	HNEQ01	sr_hearing	
rename	HNEQ02	hx_firearms	
rename	HNEQ03	hx_noise_occupational	
rename	HNEQ04	hx_noise_recreational	
rename	HNEQ05	use_ha_r	
rename	HNEQ06	years_use_ha_r	
rename	HNEQ07	avg_hours_use_ha_r	
rename	HNEQ08	hx_ear_surgery_r	
rename	HNEQ09	use_ha_l	
rename	HNEQ10	years_use_ha_l	
rename	HNEQ11	avg_hours_use_ha_l	
rename	HNEQ12	hx_ear_surgery_l	
rename	HNEQ13R	impacted_cerumen_r	
rename	HNEQ13L	impacted_cerumen_l	
rename	HNEQ14R	exam_type_r	
rename	HNEQ14L	exam_type_l	
rename	HNEQ14R1	aud_r_1000hz	
rename	HNEQ14RT1	aud_r_1000hz_repeat	
rename	HNEQ14LT1	aud_l_1000hz_repeat	

rename	HNEQ14R0	aud_r_500hz	
rename	HNEQ14R2	aud_r_2000hz	
rename	HNEQ14R4	aud_r_4000hz	
rename	HNEQ14R8	aud_r_8000hz	
rename	HNEQ14L0	aud_l_500hz	
rename	HNEQ14L1	aud_l_1000hz	
rename	HNEQ14L2	aud_l_2000hz	
rename	HNEQ14L4	aud_l_4000hz	
rename	HNEQ14L8	aud_l_8000hz	
rename	HNEQ15R	sds_r	
rename	HNEQ15L	sds_l	
rename	HNEQ16S1	quicksin_1	
rename	HNEQ16S2	quicksin_2	
rename	HNEQ17	patient_reliability	
rename	HNEQ18	manual_performed	
rename	HNEQ19	exam_complete	
rename	HNEQ19A	reason_incomplete	


codebook,com 
duplicates report id

*/
// Hearing data checking (exclude the extreme values? )

use "C:\Users\sdu7\Box Sync\R21_SENSE-MATTERS\DIFVH\POSTED\DATA\DERIVED\20180316_w_BLSA_hneq_v0.0.dta",clear 

merge 1:1 idno visit using  "C:\Users\sdu7\Box Sync\R21_SENSE-MATTERS\DIFVH\POSTED\DATA\DERIVED\cognition_all.dta" ,force
keep if _merge == 3 
drop _merge
merge 1:1 idno visit using "C:\Users\sdu7\Box Sync\R21_SENSE-MATTERS\DIFVH\POSTED\DATA\DERIVED\dss.dta",force
keep if _merge != 2
drop _merge
codebook,com 
duplicates report idno 
/*

--------------------------------------
   copies | observations       surplus
----------+---------------------------
        1 |          556             0
        2 |          402           201
        3 |          186           124
--------------------------------------
*/



merge 1:1 idno visit using "C:\Users\sdu7\Box Sync\R21_SENSE-MATTERS\DIFVH\POSTED\DATA\DERIVED\difvh_analysis.dta",force

/*
   Result                           # of obs.
    -----------------------------------------
    not matched                            20
        from master                         0  (_merge==1)
        from using                         20  (_merge==2)

    matched                             1,144  (_merge==3)
    -----------------------------------------
*/ 

/*


--------------------------------------
   copies | observations       surplus
----------+---------------------------
        1 |          556             0
        2 |          402           201
        3 |          186           124
--------------------------------------
---------------------------------------------------------------------
*/
// original cogntiive graphs

 //  distributions of cognitive tests scores 
 * box plot*
 // local the value labels to the vars 
foreach vis in  flucat flulet boscor ///  laugage
cvltca cvlfrs cvlfrl bvrtot /// memory 
digfor digbac trats  /// attention 
trbts crdrot simtot  clk325 clk1110 dsstot /// executive
 trbts crdrot simtot  clk325 clk1110  {  
local vlabel : var label `vis' 
display "`vlabel'"
}
 
 
local lan "flucat flulet boscor"
local memo "cvltca cvlfrs cvlfrl bvrtot"
local att "digfor digbac trats"
local exe "trbts crdrot simtot  clk325 clk1110 dsstot "
 
foreach v in `lan' `memo' `att' `exe' `glo' {
local vlabel: var label `v'
di "`vlabel'
graph box `v', title("`vlabel'", size(medsmall))
graph save `v',replace 
}


// export graphs
graph combine "flucat" "flulet" "boscor" ,title("language domain",size(med)) // laugage
graph export lang.png, width(4000) replace

graph combine "cvltca" "cvlfrs" "cvlfrl" "bvrtot"  ,title("memory domain" , size(med)) altshrink // memory 
graph export memo.png, width(4000) replace

graph combine "digfor" "digbac" "trats"  ,title("attention domain",size(med) ) // attention
graph export att.png, width(4000) replace 

graph combine "trbts" "crdrot" "simtot"  "clk325" "clk1110" "dsstot", altshrink  title("executive function domain",size(med)) // executive 
graph export exe.png, width(4000) replace

 
 
 
 *histgram *
 
 // local the value labels to the vars 
foreach vis in  flucat flulet boscor ///  laugage
cvltca cvlfrs cvlfrl bvrtot /// memory 
digfor digbac trats  /// attention 
trbts crdrot simtot  clk325 clk1110 dsstot /// executive
 trbts crdrot simtot  clk325 clk1110  {  
local vlabel : var label `vis' 
display "`vlabel'"
}
 
 
local lan "flucat flulet boscor"
local memo "cvltca cvlfrs cvlfrl bvrtot"
local att "digfor digbac trats"
local exe "trbts crdrot simtot  clk325 clk1110 dsstot "
 
foreach v in `lan' `memo' `att' `exe'   {
local vlabel: var label `v'
di "`vlabel'
hist  `v', freq normal title("`vlabel'", size(medsmall))
graph save `v',replace 
}


// export graphs
graph combine "flucat" "flulet" "boscor" ,title("language domain",size(med)) // laugage
graph export lang_hit.png, width(4000) replace

graph combine "cvltca" "cvlfrs" "cvlfrl" "bvrtot"  ,title("memory domain" , size(med)) altshrink // memory 
graph export memo_hit.png, width(4000) replace

graph combine "digfor" "digbac" "trats"  ,title("attention domain",size(med) ) // attention
graph export att_hit.png, width(4000) replace 

graph combine "trbts" "crdrot" "simtot"  "clk325" "clk1110" "dsstot", altshrink  title("executive function domain",size(med)) // executive 
graph export exe_hit.png, width(4000) replace

  
 
 
 putdocx begin
putdocx paragraph, 
foreach x in   memo att exe lang    ///
 memo_hit att_hit exe_hit lang_hit   {
  putdocx image `x'.png
}

 . putdocx save  Cognition_EDA_Graphs_new.docx ,replace


*_______________________________________________

// cognitive vars transformation  

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
 
 
 foreach v in revtrats revtrbts revbvrtot wintrats wintrbts logtrats logtrbts{
hist `v',freq normal
 graph save "`v'",replace
 }
 graph combine "revtrats" "revtrbts" "revbvrtot" "wintrats" "wintrbts" "logtrats" "logtrbts", ///
 title("histogram of transformed cognitive variables",size(med))
 graph export hist_tran.png, replace

 
  foreach var in revtrats revtrbts revbvrtot wintrats wintrbts logtrats logtrbts{
  graph box `var' 
 graph save "`var'",replace
 }
 graph combine "revtrats" "revtrbts" "revbvrtot" "wintrats" "wintrbts" "logtrats" "logtrbts", ///
 title("Boxplot of transformed cognitive variables", size(med))
 graph export box_tran.png, replace
 
 
 
 
 // generate hearing related var
 
// bpta_continuous 

rename	aud_r_500hz	            aud4a3	
rename	aud_r_1000hz 	        aud4a7	
rename	aud_r_2000hz	        aud4a9	
rename	aud_r_4000hz     	    aud4a13
rename	aud_r_8000hz     	    aud4a17
rename	aud_l_500hz	            aud4b3	
rename	aud_l_1000hz         aud4b7	
rename	aud_l_2000hz	        aud4b9	
rename	aud_l_4000hz	    aud4b13
rename	aud_l_8000hz	    aud4b17


*/


 

// generate average PTA for right & left ear 

gen ptar=(aud4a3 + aud4a7 + aud4a9 + aud4a13)/4				//
	gen ptal=(aud4b3 + aud4b7 + aud4b9 + aud4b13)/4				//
		label var 												///
		ptar 													///
		"PTA Right"												//
	label var 													///
		ptal 													///
		"PTA Left"												//
sum ptar ptal
codebook aud4a3	aud4a7 aud4a9 aud4a13 ptar ptal bpta_3f bpta_4f ,com // check the vars
	
 // gen continuous var  
gen bpta = min(ptar, ptal) if !missing(ptar) & !missing(ptal)
label var bpta "better ear hearing"

 
 
	gen bptacat3 = 0 if bpta_4f  <=25 
	replace bptacat3 =1 if bpta_4f  >25  & bpta_4f  <= 40 
	replace bptacat3 =2 if bpta_4f  >40 & !missing(bpta_4f ) 
	
	label var bptacat3 "PTA 3 categories, better ear "
	label values bptacat3 cat3
	label define cat3  0 "<=25 db" 										///
			1 ">25 & <=40 db" 									///
			2 ">40 " 									///
			
	codebook bptacat3
	tab bptacat3
	
	
	
	
	gen bptacat4 = 0 if bpta_4f  <=25 
	replace bptacat4 =1 if bpta_4f  >25  & bpta_4f  <= 40 
	replace bptacat4 =2 if bpta_4f  >40 & bpta_4f  <=60 
	replace bptacat4 =3 if bpta_4f  > 60 & !missing(bpta_4f )
	
	label var bptacat4 "PTA 4 categories, better ear "
	label values bptacat4 cat4
	label define cat4  0 "<=25 db" 										///
			1 ">25 & <=40 db" 									///
			2 ">40 & <=60 db" 									///
			3 ">60 db"	
	codebook bptacat4
	tab bptacat4
	
	/*
	
 
  better ear  |      Freq.     Percent        Cum.
--------------+-----------------------------------
      <=25 db |        821       46.41       46.41
>25 & <=40 db |        496       28.04       74.45
>40 & <=60 db |        398       22.50       96.95
       >60 db |         54        3.05      100.00
--------------+-----------------------------------
        Total |      1,769      100.00
		
		*/

// *** Part two Hearing and cogntion_Continuouos ***


/*  ** Date Checking 


gen date = date(dov, "DMY")
format date %td



gen aud_date = date(hneqdate, "DMY")
format date %td 

 [21oct2012,19dec2017]  
[ 12mar2012  12dec2017]


*/
/*
*** Part three Hearing and cognition_Binary/four category ***


table1_mc, by(bptacat4) ///
 vars(flucat  conts \flulet conts \ boscor  conts \ /// 
cvltca  contn \cvlfrs  contn \cvlfrl  contn \bvrtot  contn \ /// memory 
digfor  contn \digbac  contn \ trats  contn \ /// attention 
trbts  contn \ crdrot  contn \ simtot  contn \ clk325  contn \clk1110  contn \dsstot  contn \ /// executive
revtrats contn \revtrbts contn \revbvrtot contn \logtrats  contn \logtrbts  contn \  wintrats  contn \ wintrbts  contn ) /// transform
 format(%4.2f) saving(table1_hearing.xls, sheet(bptacat4,replace)) 


table1_mc, by(bptacat3) ///
 vars(flucat  conts \flulet conts \ boscor  conts \ /// 
cvltca  contn \cvlfrs  contn \cvlfrl  contn \bvrtot  contn \ /// memory 
digfor  contn \digbac  contn \ trats  contn \ /// attention 
trbts  contn \ crdrot  contn \ simtot  contn \ clk325  contn \clk1110  contn \dsstot  contn \ /// executive
revtrats contn \revtrbts contn \revbvrtot contn \logtrats  contn   \logtrbts  contn \  wintrats  contn \ wintrbts  contn )  /// transform
 format(%4.2f) saving(table1_hearing.xls, sheet(bptacat3,replace)) 
*/

 
 
 
 
 
 
 
************ CODE BELOW FOR MODIFICATION ******************


foreach x in flucat flulet boscor /// language
cvltca cvlfrs cvlfrl bvrtot /// memory 
digfor digbac trats  /// attention 
trbts crdrot simtot  clk325 clk1110 dsstot  /// executive
revtrats  revtrbts  revbvrtot  logtrbts   logtrats  wintrats   wintrbts {  
local varlabel: var label `x'  
di "`varlabel'"
graph twoway scatter  `x'  bpta , mcolor(emidblue)  msize(vsmall) msymbol(circle) title("`varlabel'",size(medsmall))  ///
 || lowess  `x'  bpta , legend(off) 
 graph save `x',replace
 }
 
 
  
// export graphs

graph combine "flucat" "flulet" "boscor" ,title("hearing and cognition scatterplot_language domain",size(small)) // laugage
graph export lang_hearing.png, width(4000) replace

graph combine "cvltca" "cvlfrs" "cvlfrl" "bvrtot"  ,title("hearing and cognition scatterplot_memory domain" , size(small)) altshrink // memory 
graph export memo_hearing.png, width(4000) replace

graph combine "digfor" "digbac" "trats"  ,title("hearing and cognition scatterplot_attention domain",size(small) ) // attention
graph export att_hearing.png, width(4000) replace 

graph combine "trbts" "crdrot" "simtot"  "clk325" "clk1110" "dsstot", altshrink  title("hearing and cognition scatterplot_executive function domain",size(small)) // executive 
graph export exe_hearing.png, width(4000) replace
/*
graph combine "wrttot" "mmstot" , title("hearing and cognition scatterplot_ global domain",size(med))
graph export glo_hearing.png, width(4000) replace 
 */
  graph combine "revtrats"  "revtrbts"  "revbvrtot"  "logtrbts"   "logtrats"  "wintrats"   "wintrbts"  ///
 , title("hearing and log_transformed cognition scores scatterplot",size(med))
graph export logtrans_hearing_cog.png, width(4000) replace 
 
 
 
 

// putdocx

putdocx begin
 putdocx paragraph
foreach x in hist_tran box_tran lang_hearing memo_hearing att_hearing exe_hearing logtrans_hearing_cog { 
  putdocx image `x'.png, width(8) 
}

 . putdocx save Hearing_Cognition_BLSA_EDA_Graphs_new.docx ,replace

 
 
 
 
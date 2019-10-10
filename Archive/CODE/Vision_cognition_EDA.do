* DIF _EDA_ vision and cognition 
* Simo
* Aug 23rd 
* __________________________________


/*

// house keeping 
clear all
capture log close
log using vision_cog.log, replace 
 
// search specific var

foreach var in cognition score test vision va eye edu sex race diab hyper {
lookfor `var'
}
*/

****** one vision ********

//  vision var
codebook  ///
logmar_bcbe10 va2040 /// vision acuity
contrast10  cs155  /// contrast 
missed vf_impaired /// vision field (no clinical cut point)
sa_min sa80 ,com // stereo acurity  (cut-off based on population mean )




// exclusion criteria : only keep the recent visit
/*
sort id vf_visit
bys id: gen tag = _n
bys id: gen count = _N
keep if tag == count 
des 
duplicates report id


827 participnats 

*/


foreach vis in logmar_bcbe10 contrast10 missed sa_min {
local vlabel : var label `vis'
hist `vis', freq normal title("`vlabel'")
graph save `vis',replace
}
graph combine "logmar_bcbe10" "contrast10" "missed" "sa_min" ,altshrink title("histogram of vision variables ")

graph export hist_vision.png,replace 


foreach vis in logmar_bcbe10 contrast10 missed sa_min {
local vlabel : var label `vis'
graph box `vis',title("`vlabel'")
graph save `vis' ,replace 
}
graph combine "logmar_bcbe10" "contrast10" "missed" "sa_min" ,altshrink title("Boxplot of vision variables ")

graph export box_vision.png, replace

// tab of binary var 


foreach v of varlist va2040 cs155 vf_impaired sa80 {
tab `v'
}








 **** TWO: Cognition ****
// cognition vars

foreach x in logi digit word clock memo  {
lookfor `x'
}


/*

codebook digfor digbac /// difit forward backward
crdrot simtot /// crad rotation 
trats trbts /// trail making A & B
cvltca cvlfrs cvlfrl  /// delayed word recall 
boscor bvrtot wrttot /// WRAT Boston scores 
flucat flulet /// word fleency ?
 clk325 clk1110 /// clock 
 tr_exec trbts_log tr_exec_log sens_cog_tag /// derived
,com

*/ 


// codebook group by cognitive domains 
codebook  flucat flulet boscor ///  laugage
cvltca cvlfrs cvlfrl bvrtot /// memory 
digfor digbac trats  /// attention 
trbts crdrot simtot  clk325 clk1110 dsstot /// executive
wrttot mmstot /// wide achievement & mms
logflucat logflulet logboscor logtrats logtrbts logtrtdif  /// transform
winflucat winflulet winboscor wintrats wintrbts wintrtdif,com // derived

// tag vars 
 codebook ///
 cvlifr1tag cvlifr2tag cvlifr3tag cvlifr4tag cvlifr5tag cvlifrbtag cvlsdfrtag cvlsdcrtag cvlldfrtag cvlldcrtag cvlldretag ///
 flutag fortag bcktag trailstag crdtag clktag bvrtag dsstag sens_cog_tag cestag mmstag dsstag ,com


 // swilk group by cognitive domains 
 putdocx begin 
swilk  flucat flulet boscor ///  laugage
cvltca cvlfrs cvlfrl bvrtot /// memory 
digfor digbac trats  /// attention 
trbts crdrot simtot  clk325 clk1110 dsstot /// executive
wrttot mmstot /// wide achievement & mms
logflucat logflulet logboscor logtrats logtrbts logtrtdif  /// transform
winflucat winflulet winboscor wintrats wintrbts wintrtdif // derived

 putdocx save example.docx,replace 

 
 //  distributions of cognitive tests scores 
 * box plot*
 // local the value labels to the vars 
foreach vis in  flucat flulet boscor ///  laugage
cvltca cvlfrs cvlfrl bvrtot /// memory 
digfor digbac trats  /// attention 
trbts crdrot simtot  clk325 clk1110 dsstot /// executive
wrttot mmstot /// wide achievement & mms
trbts crdrot simtot  clk325 clk1110  {  
local vlabel : var label `vis' 
display "`vlabel'"
}
 
 
local lan "flucat flulet boscor"
local memo "cvltca cvlfrs cvlfrl bvrtot"
local att "digfor digbac trats"
local exe "trbts crdrot simtot  clk325 clk1110 dsstot "
local glo "wrttot mmstot"

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

graph combine "wrttot" "mmstot" , title("global domain",size(med))
graph export glo.png, width(4000) replace 
 
 
 
 *histgram *
 
 // local the value labels to the vars 
foreach vis in  flucat flulet boscor ///  laugage
cvltca cvlfrs cvlfrl bvrtot /// memory 
digfor digbac trats  /// attention 
trbts crdrot simtot  clk325 clk1110 dsstot /// executive
wrttot mmstot /// wide achievement & mms
trbts crdrot simtot  clk325 clk1110  {  
local vlabel : var label `vis' 
display "`vlabel'"
}
 
 
local lan "flucat flulet boscor"
local memo "cvltca cvlfrs cvlfrl bvrtot"
local att "digfor digbac trats"
local exe "trbts crdrot simtot  clk325 clk1110 dsstot "
local glo "wrttot mmstot"

foreach v in `lan' `memo' `att' `exe' `glo' {
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

graph combine "wrttot" "mmstot" , title("global domain",size(med))
graph export glo_hit.png, width(4000) replace 
 
 
 
 *****************************************************************88
 
 
 
 // log transformation and standardization 
 capture drop trtdif logtrtdif
 gen trtdif = trbts - trats 
 gen logtrtdif = log10(trtdif+ 42) // 42 is the median of logtrtdif 
 label var logtrtdif "log transform trailB-trailA"
 sum logtrtdif
 
 foreach trans in flucat flulet boscor trats trbts  {
 capture drop log`trans'
 gen log`trans' = log10(`trans')
 label var log`trans' "Log transform `trans'"
 codebook log`trans',com
 }
 

 
 // distribution of log-transformation 
 
foreach v in logflucat logflulet logboscor logtrats logtrbts logtrtdif{
local vlabel: var label `v'
di "`vlabel'
hist  `v', freq normal title("`vlabel'", size(medsmall))
graph save trans`v'_hist,replace 
graph box `v', title("`vlabel'",size(medsmall))
graph save trans`v'_box,replace
}

 
 graph combine "translogflucat_hist" "translogflulet_hist" "translogboscor_hist" "translogtrats_hist" "translogtrbts_hist" "translogtrtdif_hist" , title("Histogram of test scores after log transformation",size(med))
graph export trans_hist.png, width(4000) replace 
 
 
  graph combine "translogflucat_box" "translogflulet_box" "translogboscor_box" "translogtrats_box" "translogtrbts_box" "translogtrtdif_box", title("box of test scores after log transformation",size(med))
graph export trans_box.png, width(4000) replace 
 
 
 
 
  // winsorizing 
 
 
 foreach v in flucat flulet boscor trats trbts trtdif {
 capture drop win`v'
 winsor `v', gen(win`v') p(0.1) 
 label var win`v' "winsorized `v'"
 codebook win`v',com
 }
 

 
 foreach v in winflucat winflulet winboscor wintrats wintrbts wintrtdif{
local vlabel: var label `v'
di "`vlabel'
hist  `v', freq normal title("`vlabel'", size(medsmall))
graph save win`v'_hist,replace 
graph box `v', title("`vlabel'",size(medsmall))
graph save win`v'_box,replace
}

 
 graph combine "winwinflucat_hist" "winwinflulet_hist" "winwinboscor_hist" ///
 "winwintrats_hist" "winwintrbts_hist" "winwintrtdif_hist" , ///
 title("Histogram of test scores after winsorization",size(med))
graph export win_hist.png, width(4000) replace 
 
 
graph combine "winwinflucat_box" "winwinflulet_box" "winwinboscor_box" ///
"winwintrats_box" "winwintrbts_box" "winwintrtdif_box", ///
title("box of test scores after winsorization",size(med))
graph export win_box.png, width(4000) replace 
 
 
 
 
 
 
 
 
 
 
 *****************************************************************88
 // correlations 
corr flucat flulet boscor ///  laugage
cvltca cvlfrs cvlfrl bvrtot /// memory 
digfor digbac trats  /// attention 
trbts crdrot simtot  clk325 clk1110 dsstot trtdif /// executive
wrttot mmstot // wide achievement & mms




// transormed version 
corr logflucat logflulet logboscor ///  laugage
cvltca cvlfrs cvlfrl bvrtot /// memory 
digfor digbac logtrats  /// attention 
logtrbts crdrot simtot  clk325 clk1110 dsstot logtrtdif /// executive
wrttot mmstot // wide achievement & mms




// matrix plot 
graph matrix flucat flulet boscor ///  laugage
cvltca cvlfrs cvlfrl bvrtot /// memory 
digfor digbac trats  /// attention 
trbts crdrot simtot  clk325 clk1110 dsstot /// executive
wrttot mmstot /// wide achievement & mms
, half msize(small)
graph export matrix.png,width(4000) replace 


 
 
 
 
 
 
 
 
 
 
 
 *************Three  Correlations __ Continuous *************

 

foreach x in flucat flulet boscor /// l
cvltca cvlfrs cvlfrl bvrtot /// memory 
digfor digbac trats  /// attention 
trbts crdrot simtot  clk325 clk1110 dsstot trtdif /// executive
wrttot mmstot /// wide achievement & mms
logflucat logflulet logboscor logtrats logtrbts logtrtdif  /// transform
winflucat winflulet winboscor wintrats wintrbts wintrtdif   {
local vlabel: var label `x' 
graph twoway scatter  `x'  logmar_bcbe10 , mcolor(emidblue)  msize(vsmall) msymbol(circle) title("`vlabel'",size(medsmall))  ///
 || lowess  `x'  logmar_bcbe10 , legend(off)
 graph save `x',replace
 }
 
  
// export graphs

graph combine "flucat" "flulet" "boscor" ,title("vision and cognition scatterplot_language domain",size(small)) // laugage
graph export lang_vision.png, width(4000) replace

graph combine "cvltca" "cvlfrs" "cvlfrl" "bvrtot"  ,title("vision and cognition scatterplot_memory domain" , size(small)) altshrink // memory 
graph export memo_vision.png, width(4000) replace

graph combine "digfor" "digbac" "trats"  ,title("vision and cognition scatterplot_attention domain",size(small) ) // attention
graph export att_vision.png, width(4000) replace 

graph combine "trbts" "crdrot" "simtot"  "clk325" "clk1110" "dsstot", altshrink  title("vision and cognition scatterplot_executive function domain",size(small)) // executive 
graph export exe_vision.png, width(4000) replace

graph combine "wrttot" "mmstot" , title("vision and cognition scatterplot_ global domain",size(med))
graph export glo_vision.png, width(4000) replace 
 
  graph combine "logflucat" "logflulet" "logboscor" "logtrats" "logtrbts" "logtrtdif"   ///
 , title("vision and log_transformed cognition scores scatterplot",size(med))
graph export logtrans_vision_cog.png, width(4000) replace 
 
 
 
 graph combine "winflucat" "winflulet" "winboscor" "wintrats" "wintrbts" "wintrtdif"   ///
 , title("vision and winsorized transformed cognition scores scatterplot ",size(med))
graph export wintrans_vision.png, width(4000) replace 
 
 
 


// putdocx
putdocx begin

putdocx paragraph, 
foreach x in box_vision hist_vision memo att exe lang glo  ///
 memo_hit att_hit exe_hit lang_hit glo_hit  ///
 win_box win_hist trans_box trans_hist ///
 matrix ///
  memo_vision att_vision exe_vision lang_vision glo_vision  ///
  logtrans_vision_cog wintrans_vision {
  putdocx image `x'.png
}

 . putdocx save Vison_Cognition_EDA_Graphs.docx ,replace

/* cognition


 putdocx begin
putdocx paragraph, 
foreach x in   memo att exe lang    ///
 memo_hit att_hit exe_hit lang_hit   {
  putdocx image `x'.png
}

 . putdocx save Vison_Cognition_EDA_Graphs_new.docx ,replace

*/
 
 
 
 
 *************Four : Correlations __ Caegorical *************
 

//  table1


table1_mc, by(va2040) ///
 vars(flucat  conts \flulet conts \ boscor  conts \ /// 
cvltca  contn \cvlfrs  contn \cvlfrl  contn \bvrtot  contn \ /// memory 
digfor  contn \digbac  contn \ trats  contn \ /// attention 
trbts  contn \ crdrot  contn \ simtot  contn \ clk325  contn \clk1110  contn \dsstot  contn \trtdif  conts \ /// executive
wrttot  contn \ mmstot  contn \ /// wide achievement & mms
logflucat  contn \logflulet  contn \logboscor  contn \logtrats  contn \logtrbts  contn \logtrtdif contn \  /// transform
winflucat  contn \winflulet  contn \winboscor  contn \wintrats  contn \ wintrbts  contn \wintrtdif  contn ) ///
 format(%4.2f) saving(table1_vision.xls, replace) 


 
 // only keep those whose 
 
 
 table1_mc, by(va2040) ///
 vars(flucat  conts \flulet conts \ boscor  conts \ /// 
cvltca  contn \cvlfrs  contn \cvlfrl  contn \bvrtot  contn \ /// memory 
digfor  contn \digbac  contn \ trats  contn \ /// attention 
trbts  contn \ crdrot  contn \ simtot  contn \ clk325  contn \clk1110  contn \dsstot  contn \trtdif  conts \ /// executive
wrttot  contn \ mmstot  contn \ /// wide achievement & mms
logflucat  contn \logflulet  contn \logboscor  contn \logtrats  contn \logtrbts  contn \logtrtdif contn \  /// transform
winflucat  contn \winflulet  contn \winboscor  contn \wintrats  contn \ wintrbts  contn \wintrtdif  contn ) ///
 format(%4.2f) saving(table1_vision.xls, replace) 


 
 
/*
 title( Table1_ cognitive test score by vision (acuity) impairment)
 
 Number of people included (0) and excluded in table1
 
 
 
 

 }


 
 
 
 
 
/// trbts_log tr_exec_log logmar_pbe logmar_pbe10 logmar_bcbe logmar_bcbe10 contrast contrast10













log close




graphlog using vision_cog.log , replace porientation(landscape) lspacing(1) msize(0.1) fsize(12) fwidth(0.6) enumerate  openpdf 







































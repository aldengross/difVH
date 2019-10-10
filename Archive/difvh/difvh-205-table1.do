* difvh-205-table1.do
* Alden Gross
*  2 Aug 2018
* -------------------
use $derived/interim-difvh-120.dta, clear
*
codebook  ///
logmar_bcbe10 va2040 /// vision acuity
contrast10  cs155  /// contrast 
missed vf_impaired /// vision field (no clinical cut point)
sa_min sa80 ,com // stereo acurity  (cut-off based on population mean )



table1_mc, by(va2040) ///
 vars(flucat  conts \flulet conts \ boscor  conts \ /// 
cvltca  contn \cvlfrs  contn \cvlfrl  contn \bvrtot  contn \ /// memory 
digfor  contn \digbac  contn \ trats  contn \ /// attention 
trbts  contn \ crdrot  contn \ simtot  contn \ clk325  contn \clk1110  contn \dsstot  contn \trtdif  conts \ /// executive
wrttot  contn \ mmstot  contn \ /// wide achievement & mms
logflucat  contn \logflulet  contn \logboscor  contn \logtrats  contn \logtrbts  contn \logtrtdif contn \  /// transform
winflucat  contn \winflulet  contn \winboscor  contn \wintrats  contn \ wintrbts  contn \wintrtdif  contn ) ///
 format(%4.2f) saving(table1_vision.xls, replace) 


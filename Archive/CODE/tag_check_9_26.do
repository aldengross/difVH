

// check tag 
tab crdrot crdtag
tab dsstot dsstag
tab flulet  flutag
tab cvltca  cvlifr1tag
tab  cvlfrs  cvlifr1tag
tab  cvlfrl cvlifr1tag
tab  bvrtot bvrtag
tab  trats  trailstag
tab trbts   trailstag 
tab  clk325 clktag
tab  clk1110 clktag

/*
tab  dsstot 
tab  trbts  
tab  simtot 
tab  crdrot  
tab  simtot 
tab  digfor  
tab  digbac 
tab  boscor  
*/ 

sum crdrot   if  crdtag    ==77          
sum dsstot   if dsstag        ==77     
sum flulet   if  flutag      ==77      
sum cvltca   if  cvlifr1tag   ==77  
sum  cvlfrs  if   cvlifr1tag     ==77  
sum  cvlfrl  if  cvlifr1tag ==77
sum  bvrtot  if  bvrtag ==77
sum  trats   if  trailstag ==77
sum trbts    if  trailstag  ==77
sum  clk325  if  clktag ==77
sum  clk1110 if  clktag    ==77





 





foreach x in ///
cvlifr1tag   ///
cvlifr2tag   ///
cvlifr3tag   ///
cvlifr4tag   ///
cvlifr5tag   ///
cvlifrbtag   ///
cvlsdfrtag   ///
cvlsdcrtag   ///
cvlldfrtag   ///
cvlldcrtag   ///
cvlldretag   ///
flutag       ///
fortag       ///
             ///
bcktag       ///
             ///
trailstag    ///
crdtag       ///
clktag       ///
bvrtag       ///
dsstag       ///
sens_cog_tag ///
cestag       ///
mmstag       {
tab `x' 
}

/*

cvlifr1tag      double  %12.0g                CVL Missing data tag for IFR1
cvlifr2tag      double  %12.0g                CVL Missing data tag for IFR2
cvlifr3tag      double  %12.0g                CVL Missing data tag for IFR3
cvlifr4tag      double  %12.0g                CVL Missing data tag for IFR4
cvlifr5tag      double  %12.0g                CVL Missing data tag for IFR5
cvlifrbtag      double  %12.0g                CVL Missing data tag for IFRB
cvlsdfrtag      double  %12.0g                CVL Missing data tag for SDFR
cvlsdcrtag      double  %12.0g                CVL Missing data tag for SDCR
cvlldfrtag      double  %12.0g                CVL Missing data tag for LDFR
cvlldcrtag      double  %12.0g                CVL Missing data tag for LDCR
cvlldretag      double  %12.0g                CVL Missing data tag for LDRE
flutag          double  %11.0g                Fluency tag
fortag          double  %11.0g                WAIS-R Digits Forward Special data
                                                tag
bcktag          double  %11.0g                WAIS-R Digits Backward Special
                                                data tag
trailstag       double  %11.0g                NPTAG
crdtag          double  %11.0g                Card Rotations: Special data tag
clktag          double  %11.0g                Neuro Clk tag
bvrtag          double  %12.0g                BVR Tag
dsstag          double  %12.0g                
sens_cog_tag    double  %12.0g                
cestag          double  %12.0g                
mmstag          double  %12.0g   




















 
 
cvlifr1tag   ///
cvlifr2tag   ///
cvlifr3tag   ///
cvlifr4tag   ///
cvlifr5tag   ///
cvlifrbtag   ///
cvlsdfrtag   ///
cvlsdcrtag   ///
cvlldfrtag   ///
cvlldcrtag   ///
cvlldretag   ///
flutag       ///
fortag       ///
bcktag       ///
 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
foreach x in flucat ///
flulet   ///
boscor   ///  laugage
cvltca   ///
 cvlfrs  ///
 cvlfrl  ///
 bvrtot  /// memory 
digfor   ///
 digbac  ///
 trats   /// attention 
trbts    ///
crdrot   ///
 simtot  ///
 clk325  ///
 clk1110  ///
 dsstot  /// executive
 trbts   ///
 crdrot   ///
 simtot   ///
 clk325  ///
 clk1110 
 
 
foreach x in ///
cvlifr1tag   ///
cvlifr2tag   ///
cvlifr3tag   ///
cvlifr4tag   ///
cvlifr5tag   ///
cvlifrbtag   ///
cvlsdfrtag   ///
cvlsdcrtag   ///
cvlldfrtag   ///
cvlldcrtag   ///
cvlldretag   {
tab `x'
}

flutag       ///
fortag       ///
             ///
bcktag       ///
             ///
trailstag    ///
crdtag       ///
clktag       ///
bvrtag       ///
dsstag       ///
sens_cog_tag ///
cestag       ///
mmstag       {
tab `x' 
}

/*

. codebook *tag*,com

Variable       Obs Unique      Mean  Min  Max  Label
------------------------------------------------------------------------------------------------------------
cvlifr1tag    1133     12   71.5481   70   99  CVL Missing data tag for IFR1
cvlifr2tag    1133     12  71.57282   70   99  CVL Missing data tag for IFR2
cvlifr3tag    1133     11  71.59841   70   99  CVL Missing data tag for IFR3
cvlifr4tag    1133     11  71.59047   70   99  CVL Missing data tag for IFR4
cvlifr5tag    1133     11  71.59047   70   99  CVL Missing data tag for IFR5
cvlifrbtag    1133     11  71.61959   70   99  CVL Missing data tag for IFRB
cvlsdfrtag    1133     11  71.65666   70   99  CVL Missing data tag for SDFR
cvlsdcrtag    1133     11  71.64431   70   99  CVL Missing data tag for SDCR
cvlldfrtag    1133     11  71.72198   70   99  CVL Missing data tag for LDFR
cvlldcrtag    1133     11  71.72816   70   99  CVL Missing data tag for LDCR
cvlldretag    1133     12  71.66461    7   99  CVL Missing data tag for LDRE
flutag        1134     10  71.05115   70   99  Fluency tag
fortag        1135     11  70.88811   70   99  WAIS-R Digits Forward Special data tag
bcktag        1134     11  71.03086   70   99  WAIS-R Digits Backward Special data tag
trailstag     1134     10   71.0097   70   99  NPTAG
crdtag        1105     11  71.21991   70   99  Card Rotations: Special data tag
clktag         989     10  71.10819   70   99  Neuro Clk tag
bvrtag        1105      9  70.70588   70   99  BVR Tag
dsstag        1132     10  71.54417   70   99  
sens_cog_tag  1144      2  .0122378    0    1  
cestag           0      0         .    .    .  
mmstag           0      0         .    .    .  
------------------------------------------------------------------------------------------------------------

. 

* fhads-005-start-latex.do
* Alden Gross
* 11 Jul 2013
* -------------------
cap erase difVH.tex
texdoc init difVH , force
starttex , tex(difVH.tex) arial

tex {\bf Alden Gross, Jennifer Deal, Bonnie Swenor} \\
today
tex `r(date2)' \\
tex \begin{center}
tex {\bf R21: Measurement of Cognitive Function in Older Adults with Sensory Loss}\\[0.5cm]
tex \end{center}
tex

tex {\bf Project goal.} \\[0.5cm]
tex    The overarching goal of this report is
tex to evaluate DIF in the battery of cognitive tests in BLSA. \\[0.5cm]

tex {\bf Methods.} \\[0.5cm]
tex Pursuant to the overarching goal we have 5 sets of analyses in BLSA data:
tex \bi
   tex \item (1) Estimate a single-group, single-factor IRT model to evaluate fit and item characteristics.
   tex \item (2) Alignment analysis to evaluate differential item functioning (DIF) by (a) vision and (b) hearing. For each sensory impairment,
      tex we provide a summary of thresholds and loadings that might be different across sensory groups, item characteristic curves (ICCs) for each cognitive test item, 
      tex and a graph of loadings vs the final threshold. Models are estimated using up to 8 categories for cognitive tests.
   tex \item (3) Rerun (2) with up to 5 categories for cognitive tests, instead of 8.
   tex \item (4) Rerun (3) to evaluate DIF in hearing among items that do not rely highly on hearing. Same for vision.
      tex Why? To evaluate for differences in cognitive test performance not attributable to the focal impairment.

   *tex \item (5) Rerun (3) as a MIMIC model to leverage anchor items that should not vary by sensory impairment (use TMT-A for hearing and DSF for vision).

   tex \item Sensitivity analyses to control for demographics
   tex \bi
      tex \item (6) To control for age differences in hearing/vision by sample restriction, 
         tex rerun (3) among people with a common age range.
      tex \item (7-8) To control for sex differences in hearing/vision by sample restriction, 
         tex rerun (3) among males and females separately.
      tex \item (9-10) To control for education differences in hearing/vision by sample restriction, 
         tex rerun (3) among separate groups defined by HS education or less, and higher.
      tex \item (11-12) To control for race differences in hearing/vision by sample restriction, 
         tex rerun (3) among white and nonwhite participants separately.
   tex \ei

   tex \item Subgroup analyses
   tex \bi
      local counter=12
      foreach x in age sex education race {
         tex \item (`++counter') Rerun (3) stratified into 4 groups (instead of just sensory impaired/sensory unimpaired). Groups are defined based on sensory impairment status and `x'.
      }
   tex \ei

tex \ei




tex \newpage
tex \tableofcontents
tex \newpage


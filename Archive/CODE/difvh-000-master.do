

wfenv difvh , alg subfolder(code)

cap erase difVH.tex
texdoc init difVH
starttex , tex(difVH.tex) arial

include $analysis/difvh-105-call-source.do
include $analysis/difvh-110-create-variables.do
include $analysis/difvh-120-select-cases-for-analysis.do
include $analysis/difvh-304-models-IRT.do
include $analysis/difvh-305-models-alignment-vision.do
include $analysis/difvh-306-models-alignment-hearing.do
include $analysis/difvh-990-close-latex.do

/*
Next steps
   scatterplots of loadings vs thresholds
   MIMIC model outputs
*/

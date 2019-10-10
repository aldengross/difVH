* dif_cogsens project
* difvh-000-master.do
* Alden Gross
*  2 Aug 2018
* -------------------
*!junction "c:\work\difvh" "C:\Users\agross\BoxSync\R21_SENSE-MATTERS\difvh"
*cd c:\work\difvh
*wftree , m(difvh) p(ALG BS JAD SD)
*cd C:\work\difvh\POSTED\ANALYSIS
*automaster2 , m(dif_cogsens) a(difvh) u(Alden Gross) nvb

wfenv dif_cogsens , a(difvh) alg

include $analysis/difvh-001-preambling.do // date seed etc
include $analysis/difvh-005-start-latex.do
include $analysis/difvh-105-call-source.do
include $analysis/difvh-110-create-variables.do
include $analysis/difvh-120-select-cases-for-analysis.do
include $analysis/difvh-205-table1.do
include $analysis/difvh-210-figure1-main-outcome-undadjusted.do
include $analysis/difvh-305-models.do
include $analysis/difvh-310-table2.do
include $analysis/difvh-320-figure2.do
include $analysis/difvh-405-sensitivity-analyses.do
include $analysis/difvh-505-stuff-in-text.do
include $analysis/difvh-990-close-latex.do

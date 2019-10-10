* fhads-001-preambling.do
* Alden Gross
* 11 Jul 2013
* -------------------
date // or today : RNJ ado's that provide locals for date
local today = "`r(date2)'" // e.g., "11 JAN 2011"
local datestr = "`r(datestr)'" // e.g., "20110111"
* Settings --------------------------------------------------
set seed 8675309 // even if not sure needed, set it anyway
set more off // unless you really want it
local tablecounter=0 
local figurecounter=0
local analysisset=0

* For analysis set 4
global vlisthearing "u_3 u_4 u_5 u_6 u_7 u_8 u_9 u_13 u_14 u_15 u_16" // for hearing, set 4
*global vlistvision "u_1 u_2 u_10 u_11 u_12 u_14 u_15" // for vision, set 4
* SANS some CVLT items
global vlistvision "u_1 u_2 u_12 u_14 u_15" // for vision, set 4

di "$vlisthearing"
di "$vlistvision"

*varlablist $vlisthearing
*varlablist $vlistvision

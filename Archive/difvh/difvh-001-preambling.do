* difvh-001-preambling.do
* Alden Gross
*  2 Aug 2018
* -------------------
date // or today : RNJ ado's that provide locals for date
local today = "`r(date2)'" // e.g., "11 JAN 2011"
local datestr = "`r(datestr)'" // e.g., "20110111"
* Settings --------------------------------------------------
set seed 8675309 // even if not sure needed, set it anyway
set more off // unless you really want it


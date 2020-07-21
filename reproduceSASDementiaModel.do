cd "/Users/burke/Documents/research/bpCog/nhanes"

use using coxreg_currgcp.dta

rename female0 female

stset t_end, id(newid) failure(deminc)
sts graph

log using reproduceSASDementiaModel.smcl, replace
stcox c.gcp_bl c.gcp_slope c.age i.female ib5.educ ib2.racebpcog , nohr
log close


predict baseHaz, basechazard 
predict baseSurv, basesurv
predict xb, xb


preserve
collapse (first) baseHaz baseSurv, by(t_end)
gen surv = 1-baseHaz
pwcorr surv baseSurv
graph twoway scatter surv  t_end, msize(tiny)
save baselineHazard.dta, replace

graph twoway scatter baseHaz t_end
restore

sum baseHaz if t_end> 0.99 & t_end < 1.01
gen oneYearRisk = `r(mean)' * exp(xb) 


preserve
keep if _n < 20
save testCases.dta, replace
restore


* this gets us the tvc codfficient...but, we can't get a baseline hazard curve
stcox c.gcp_bl c.gcp_slope i.female ib5.educ ib2.racebpcog , nohr tvc(c.age)


* https://constantinruhe.files.wordpress.com/2017/01/ruhe2016_sj_finalsubmission.pdf
stsplit, at(failures)
generate age_t = age*ln(_t)

stcox c.gcp_bl c.gcp_slope i.female ib5.educ ib2.racebpcog  age_t, nolog nohr
predict baseHazTVC, basechazard 

preserve
collapse (first) baseHazTVC , by(t_end)
graph twoway scatter baseHazTVC  t_end, msize(tiny)
save baselineHazardTVC.dta, replace

restore


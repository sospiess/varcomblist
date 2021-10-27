// version ommited on purpose
// v1.0.0-rc  $TS$  Sven O. Spieß

capture log off
preserve
clear




*Display possible pairs of variables of interest in auto example dataset:
sysuse auto

varcomblist mpg trunk-length price
return list
di "`r(comblist)'"


varcomblist mpg trunk-length price, generate varseparator("-") pairseparator(";  ")
return list
di "`r(comblist)'"
describe *X*


varcomblist mpg trunk-length price, pairprefix(`""("') pairsuffix(`")" "')  ///
  varseparator(", ") local(list)

local i = 1
foreach pair of local list {
       di "-> pair`i' = `pair'"
       local ++i
}




*Estimate the covariance between errors of mpg and trunk in sem:
sem (mpg <- turn trunk price) (trunk <- length)

varcomblist mpg trunk, varprefix("e.") local(errcov)
sem (mpg <- turn trunk price) (trunk <- length),  ///
  covariance(`errcov')




restore
capture log on
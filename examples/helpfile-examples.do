// version ommited on purpose
// 07nov2021  based on v1.0.0  of the ado- and helpfile, Sven O. Spieß

capture log off
preserve
clear




*Iterate over pairs of variables of interest:
sysuse auto

varcomblist price-mpg t* length, pairprefix(`""("') pairsuffix(`")" "')  ///
  vardelimit(", ") local(list)

local i = 1
foreach pair of local list {
       di "-> pair `i' = `pair'"
       local ++i
}


*Estimate the covariance between errors of mpg and trunk in sem:
sem (mpg <- turn trunk price) (trunk <- length)

varcomblist mpg trunk, varprefix("e.") local(errcov_endog)
sem (mpg <- turn trunk price) (trunk <- length),  ///
  covariance(`errcov_endog')





restore
capture log on
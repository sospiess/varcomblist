// version number intentionally omitted
// certification script for version 1.0.0 (07nov2021) of -varcomblist.ado-
// creation date: 07nov2021; modified: n/a; author: Sven O. Spieß

clear all
set linesize 82
if usubstr("`c(pwd)'", -4, .) == "test" {
    cd ..
}
log using "./.logs/test-varcomblist.smcl", replace name(test)


run ./varcomblist.ado


sysuse auto




// Test 1
//   Invalid syntax.
rcof "noisily: varcomblist"                                    == 100
rcof "noisily: varcomblist mpg"                                == 102
rcof "noisily: varcomblist make price mpg, generate"           ==   7
rcof "noisily: varcomblist price mpg rep78, g gendel(#)"       == 198
rcof "noisily: varcomblist price mpg rep78, g gendel(.)"       == 198
rcof "noisily: varcomblist price mpg rep78, varprefix(a b c)"  == 198
rcof "noisily: varcomblist price mpg rep78, varsuffix(a b c)"  == 198




// Test 2
//   Correct returned scalars
varcomblist make price
assert r(k)    == 2
assert r(n_pr) == 1
assert r(n_pr) == comb(2,2)


varcomblist make price mpg
assert r(k)    == 3
assert r(n_pr) == 3
assert r(n_pr) == comb(3,2)


varcomblist make price mpg rep78 headroom
assert r(k)    == 5
assert r(n_pr) == 10
assert r(n_pr) == comb(5,2)


di "No. of variables = `c(k)' ==> no. of pairs = `=comb(`c(k)', 2)'"
varcomblist _all
return list
assert r(k)    == `c(k)'
assert r(n_pr) == comb(`c(k)',2)




// Test 3
//   Correct delimiters and affixes in list of pairs

//   Defaults: vardelimiter = "*", pairdelimiter = " ", no affixes, no r(newlist)
varcomblist price mpg rep78
return list
assert "`r(varlist)'"   == "price mpg rep78"
assert "`r(comblist)'"  == "price*mpg price*rep78 mpg*rep78"
assert "`r(newlist)'"   == ""


//   alternative delimiters (pipe and minus)
varcomblist price mpg rep78, pairdel(" | ") vardel("-")
return list
assert "`r(varlist)'"   == "price mpg rep78"
assert "`r(comblist)'"  == "price-mpg | price-rep78 | mpg-rep78"
assert "`r(newlist)'"   == ""


//   as above plus leading pairdelimiter 
varcomblist price mpg rep78, pairdel(" | ") pairdelfirst vardel("-")
return list
assert "`r(varlist)'"   == "price mpg rep78"
assert "`r(comblist)'"  == " | price-mpg | price-rep78 | mpg-rep78"
assert "`r(newlist)'"   == ""


//   trailing pairdelimiter instead
varcomblist price mpg rep78, pairdel(" | ") pairdellast vardel("-")
return list
assert "`r(varlist)'"   == "price mpg rep78"
assert "`r(comblist)'"  == "price-mpg | price-rep78 | mpg-rep78 | "
assert "`r(newlist)'"   == ""


//   leading & trailing pairdelimiter
varcomblist price mpg rep78, pairdel(" | ") pairdelfirst pairdellast vardel("-")
return list
assert "`r(varlist)'"   == "price mpg rep78"
assert "`r(comblist)'"  == " | price-mpg | price-rep78 | mpg-rep78 | "
assert "`r(newlist)'"   == ""


//   shorthand for both leading & trailing pairdelimiter
varcomblist price mpg rep78, pairdel(" | ") pairdelall vardel("-")
return list
assert "`r(varlist)'"   == "price mpg rep78"
assert "`r(comblist)'"  == " | price-mpg | price-rep78 | mpg-rep78 | "
assert "`r(newlist)'"   == ""


//   include all pre-/suffixes & non-default delimiters
varcomblist price mpg rep78, varpre(`""a: " "b: ""') varsuffix(.1 .2) vardel(", ")  ///
    pairpre("(") pairsuf(") ") pairdel("| ") pairdelf pairdell
return list
assert "`r(varlist)'"   == "price mpg rep78"
assert "`r(comblist)'"  == "| (a: price.1, b: mpg.2) | (a: price.1, b: rep78.2) | (a: mpg.1, b: rep78.2) | "
assert "`r(newlist)'"   == ""




// Test 4
//   Generate newvars with interaction terms.

varcomblist price mpg rep78, generate
return list
assert "`r(varlist)'"   == "price mpg rep78"
assert "`r(comblist)'"  == "price*mpg price*rep78 mpg*rep78"
assert "`r(newlist)'"   == "priceXmpg priceXrep78 mpgXrep78"


//   error if -generate- with default -gendelimiter- previously issued;
//   don't return anything before aborting
rcof "noisily: varcomblist price mpg rep78, generate" == 110
assert "`r(k)'"       == ""
assert "`r(varlist)'" == ""


//   alternative -gendelimiter- & leading/trailing space (-pairdel()-) in r(comblist)
varcomblist price mpg rep78, generate gendelimiter(TIMES) pairdelf pairdell
return list
assert "`r(varlist)'"   == "price mpg rep78"
assert "`r(comblist)'"  == " price*mpg price*rep78 mpg*rep78 "
assert "`r(newlist)'"   == "priceTIMESmpg priceTIMESrep78 mpgTIMESrep78"




// Test 5
//   (Undocumented) Shorthands for options.


//   leading & trailing pairdelimiter
varcomblist price mpg rep78, pairdel(";") pdf pdl
return list
assert "`r(varlist)'"   == "price mpg rep78"
assert "`r(comblist)'"  == ";price*mpg;price*rep78;mpg*rep78;"
assert "`r(newlist)'"   == ""


//   shorthand for leading & trailing pairdelimiter
varcomblist price mpg rep78, pairdel(";") pda
return list
assert "`r(varlist)'"   == "price mpg rep78"
assert "`r(comblist)'"  == ";price*mpg;price*rep78;mpg*rep78;"
assert "`r(newlist)'"   == ""




log close test
translate "./.logs/test-varcomblist.smcl"  "./.logs/test-varcomblist.pdf"
exit
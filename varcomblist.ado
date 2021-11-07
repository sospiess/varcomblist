*! version 1.0.0  07nov2021  Sven O. Spieß

/* 
Create formatted list of all pairwise combinations of varlist.

External dependencies: none
*/


program define varcomblist, rclass
    version 13
    syntax varlist(min=2) [, Generate GENDELimiter(name) Local(name local) ///
                             VARPREfix(string) VARSUFfix(string)  ///
                             VARDELimiter(string)  ///
                             PAIRPREfix(string) PAIRSUFfix(string)  ///
                             PAIRDELimiter(string)  ///
                             PAIRDELFirst PDFirst  PAIRDELLast PDLast  ///
                             PAIRDELAll PDAll]

        if "`pairdelfirst'" == "pairdelfirst" local pdfirst "pdfirst"
        if "`pairdellast'"  == "pairdellast"  local pdlast  "pdlast"
        if "`pairdelall'"   == "pairdelall"  |  "`pdall'"  == "pdall" {
            local pdfirst "pdfirst"
            local pdlast  "pdlast"
        }




    /* ----- process & set variable strings -----*/
    if "`generate'" == "generate" {
        confirm numeric variable `varlist'

        if ("`gendelimiter'"  == "") {
            local gendelimiter "X"
        }
    }


    local vpwords : word count `varprefix'
    local vswords : word count `varsuffix'

    if `vpwords' > 2 {
        di "{err}option {bf:varprefix} incorrectly specified; max. 2 prefixes"
        exit 198
    }

    if `vswords' > 2 {
        di "{err}option {bf:varsuffix} incorrectly specified; max. 2 suffixes"
        exit 198
    }


    if (`"`vardelimiter'"' == "") {
        local vdel "*"      // default value
    }
    else local vdel : copy local vardelimiter


    if `vpwords' == 2 {
        local vp1 : word 1 of `varprefix'
        local vp2 : word 2 of `varprefix'
    }
    else{   // fine no matter whether one string or empty
        local vp1 : copy local varprefix
        local vp2 : copy local varprefix
    }


    if `vswords' == 2 {
        local vs1 : word 1 of `varsuffix'
        local vs2 : word 2 of `varsuffix'
    }
    else{   // fine no matter whether one string or empty
        local vs1 : copy local varsuffix
        local vs2 : copy local varsuffix
    }




    /* ----- process & set strings for combinations -----*/    
    if (`"`pairdelimiter'"' == "") {
        local pdel " "      // default value
    }
    else local pdel : copy local pairdelimiter

    local pp : copy local pairprefix
    local ps : copy local pairsuffix




    /* ----- construct pairs -----*/ 
    local vars : word count `varlist'       // number of variables (k)
    local combinations = comb(`vars', 2)    // number of pairs     (pr)

    
    if "`pdfirst'" != "" local plist `"`pdel'"'


    local i = 1    
    local worklist : copy local varlist
    while "`worklist'" != "" {
        gettoken var1 worklist: worklist

        foreach var2 of local worklist {

            if `i' < `combinations' | "`pdlast'" != "" {
                local plist = `"`plist'"' +  ///  list from prev. iterations
                    `"`pp'"' +  ///  pair prefix
                    `"`vp1'"' + `"`var1'"' + `"`vs1'"' +  ///  affixed var_1
                    `"`vdel'"' +  ///  variable delimiter
                    `"`vp2'"' + `"`var2'"' + `"`vs2'"' +  ///  affixed var_2
                    `"`ps'"' + `"`pdel'"'  //  pair suffix + pair delimiter
            }

            else {  // no pairdelimiter after last pair; unless option -pairdellast-
                local plist = `"`plist'"' +  ///  list from prev. iterations
                    `"`pp'"' +  ///  pair prefix
                    `"`vp1'"' + `"`var1'"' + `"`vs1'"' +  ///  affixed var_1
                    `"`vdel'"' +  ///  variable delimiter
                    `"`vp2'"' + `"`var2'"' + `"`vs2'"' +  ///  affixed var_2
                    `"`ps'"'  //  pair suffix only
             }

            if "`generate'" != "" {
                confirm new variable `var1'`gendelimiter'`var2'
                local v1list    = `"`v1list'"'    + `"`var1'  "'
                local v2list    = `"`v2list'"'    + `"`var2'  "'
                local newlist   = `"`newlist'"'   + `"`var1'`gendelimiter'`var2' "'
                local interlist = `"`interlist'"' + `"`var1'*`var2' "'
            }
            local ++i
        }
    }




    /* ----- return results -----*/    
    return scalar n_pr = `combinations'
    return scalar k = `vars'
    if "`generate'" != "" return local newlist = ustrtrim("`newlist'")
    return local comblist `"`plist'"'  // NB: no trim to letz users to potz around w/ del's
    return local varlist  "`varlist'"


    if ("`local'" != "") {
        c_local `local' `"`plist'"'
    }


    if "`generate'" != "" {
        forvalues i = 1/`combinations' {
            local var1   : word `i' of `v1list'
            local var2   : word `i' of `v2list'
            local newvar : word `i' of `newlist'
            local term   : word `i' of `interlist'

            generate `newvar' = `term'
            label variable `newvar' "interaction term of variables `var1' * `var2'"
        }
    }


end

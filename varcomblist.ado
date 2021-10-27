*! version 1.0.0-rc  $TS$  Sven O. Spieß


/* 
generates list of all pairwise combinations of varlist,
e.g. to create interaction terms or conveniently issue covariances across error 
terms in SEM, etc.

External dependencies:
    none

Help:
    doedit "./varcomblist.sthlp"
*/


program define varcomblist, rclass
    version 13
    syntax varlist(min=2) [, Generate interaction(name) Local(name local) ///
                             VARDELimiters(str) VARPREfix(str) VARSUFfix(str)  ///
                             PAIRDELimiters(str) PAIRPREfix(str) PAIRSUFfix(str)  ///
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

        if ("`interaction'"  == "") {
            local interaction "X"
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


    if (`"`vardelimiters'"' == "") {
        local vdel "*"      // default value
    }
    else local vdel `"`vardelimiters'"'


    if `vpwords' == 2 {
        loval vp1 : word 1 of `varprefix'
        loval vp2 : word 2 of `varprefix'
    }
    else{   // fine no matter whether one string or empty
        local vp1 `"`varprefix'"'
        local vp2 `"`varprefix'"'
    }


    if `vswords' == 2 {
        loval vs1 : word 1 of `varsuffix'
        loval vs2 : word 2 of `varsuffix'
    }
    else{   // fine no matter whether one string or empty
        local vs1 `"`varsuffix'"'
        local vs2 `"`varsuffix'"'
    }




    /* ----- process & set strings for combinations -----*/    
    if (`"`pairdelimiters'"' == "") {
        local pdel " "      // default value
    }
    else local pdel `"`pairdelimiters'"'

    local pp `"`pairprefix'"'
    local ps `"`pairsuffix'"'




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
                local plist = `"`plist'"' + `"`pp'"' ///
                    + `"`vp1'`var1'`vs1'`vdel'`vp2'`var2'`vs2'"'  ///
                    + `"`ps'`pdel'"'
            }

            else {  // no pairdelimiters after last pair; unless option -psmax-
                local plist = `"`plist'"' + `"`pp'"' ///
                    + `"`vp1'`var1'`vs1'`vdel'`vp2'`var2'`vs2'"'  ///
                    + `"`ps'"'
            }

            if "`generate'" != "" {
                confirm new variable `var1'`interaction'`var2'
                local v1list    = `"`v1list'"'    + `"`var1'  "'
                local v2list    = `"`v2list'"'    + `"`var2'  "'
                local newlist   = `"`newlist'"'   + `"`var1'`interaction'`var2' "'
                local interlist = `"`interlist'"' + `"`var1'*`var2' "'
            }
            local ++i
        }
    }




    /* ----- return results -----*/    
    return scalar pr = `combinations'
    return scalar k = `vars'
    if "`generate'" != "" return local newlist "`newlist'"
    return local comblist `"`plist'"'
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

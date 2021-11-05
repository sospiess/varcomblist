{smcl}
{* *! version 1.0.0-rc  $TS$  Sven O. Spieß}{...}
{...}
{vieweralsosee "[FN] Mathematical functions" "mansection FN Mathematicalfunctions"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[U] 11.4 varname and varlists" "help varlist"}{...}
{vieweralsosee "help functions" "help functions"}{...}
{vieweralsosee "help comb()" "help comb()"}{...}
{vieweralsosee "help sem model options" "sem_model_options"}{...}
{...}
{viewerjumpto "Syntax" "varcomblist##syntax"}{...}
{viewerjumpto "Description" "varcomblist##description"}{...}
{viewerjumpto "Options" "varcomblist##options"}{...}
{viewerjumpto "Examples" "varcomblist##examples"}{...}
{viewerjumpto "Stored results" "varcomblist##results"}{...}
{viewerjumpto "Author" "varcomblist##author"}{...}
{...}
{...}
{...}
{bf:varcomblist} {hline 2} Create pairwise combinations of variables
               (community-contributed, {browse "https://github.com/sospiess/varcomblist":view GitHub repository})


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmdab:varcomblist}
{varlist}
[{cmd:,} {it:options}]

{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt g:enerate}}generate variables for interactions of variable pairs; if specified {varlist} must contain only numeric variables{p_end}
{synopt:{opt gendel:imiter(string)}}use {it:string} as delimiter between original variable names when option {opt generate} is specified; default is "X"{p_end}

{synopt:{opt l:ocal(macname)}}insert the list of variable pairs in the local 
macro {it:macname}{p_end}

{syntab:Variables}
{synopt:{opt vardel:imiter(string)}}use {it:string} as delimiter between variables within pair; default is "*"{p_end}
{synopt:{opt varpre:fix(stub1 [stub2])}}prefix first variable in pair with {it:stub1}, second with {it:stub1} or optionally {it:stub2}{p_end}
{synopt:{opt varsuf:fix(stub1 [stub2])}}suffix first variable in pair with {it:stub1}, second with {it:stub1} or optionally {it:stub2}{p_end}

{syntab:Pairs/combinations}
{synopt:{opt pairdel:imiter(string)}}use {it:string} as delimiter between pairs; default is " " (space){p_end}
{synopt:{opt pairpre:fix(stub)}}prefix each pair with {it:stub}{p_end}
{synopt:{opt pairsuf:fix(stub)}}suffix each pair with {it:stub}{p_end}

{synopt:{opt pairdelf:irst}}add {opt pairdelimiter} before first pair{p_end}
{synopt:{opt pairdell:ast}}add {opt pairdelimiter} after last pair{p_end}
{synopt:{opt pairdela:ll}}shorthand; implies options {opt pairdelfirst} and 
{opt pairdellast}{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}{cmd:varcomblist} creates a formatted list of all pairwise combinations 
of the variables in {varlist}.  For k variables there will accordingly be 
{it:k!/{2!(k - 2)!}} pairs.

{pstd}The command allows to specifiy how variables within pairs are delimited 
as well as how pairs are delimited from one another.  In addition, variables 
and pairs can be prefixed/suffixed as appropriate.  Thus {cmd:varcomblist} can 
be useful to create multiple interaction terms for commands not supporting 
{help fvvarlist:factor variables} or to specify multiple (error) covariances in 
{help sem_model_options:SEM}, etc.{p_end}


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}{opt generate} specifies that in addtion to creating a formatted list 
of variable pairs, {cmd:varcomblist} also generates new variables containing 
the product or "interaction" of the variables in each pair.  The generated 
variables are not affected by any formatting (i.e., delimiters and affixes) 
applied to the variables or pairs.  If specified, all variables must be 
{help data_types:numeric}.

{phang}{opt gendelimiter(string)} specifies the characters to be used as 
delimiter between the original variable names in the newly generated variables 
if option {cmd: generate} is also specified.  Accordingly, {it:string} may only 
contain characters valid in {mansection U 11.3Namingconventions:variable names}.
  {it:string} defaults to "X".

{phang}{opt local(macname)} inserts the formatted list of pairs in local macro 
{it:macname} within the calling program's space.  Hence, that macro will be 
accessible after {cmd:varcomblist} has finished.  This is helpful for 
subsequent use, e.g., with {help foreach} or {cmd: sem {it:paths} ..., covariance(`{it:macname}')}.

{dlgtab:Variables}

{phang}
{opt vardelimiter(string)} specifies how variables within pairs are delimited.  
{it:string} defaults to asterisk "*", e.g.: {it:var1}{bf:*}{it:var2}.{break}
Useful alternatives might be hyphen ("-"), single space (" "), or comma and 
space (", ").

{phang}
{opt varprefix(stub1 [stub2])} specifies string(s) to be placed in front of 
variables.  If one stub is specified, it is placed in front of both variables 
of the pair; if two stubs are specified, {it:stub1} prefixes the first variable 
and {it:stub2} prefixes the second variable of each pair.  For instance, use 
{cmd:varprefix("e.")} to refer to error terms of variables in {help sem:SEM}.

{phang}
{opt varsuffix(stub1 [stub2])} as above but placed after variables.

{dlgtab:Pairs/combinations}

{phang}
{opt pairdelimiter(string)} specifies how pairs of variables are delimited.  
{it:string} defaults to single space " ", e.g.: {it:var1*var2 var1*var3 var2*var3}{break}
Useful alternatives might be semicolon and space ("; "), or pipe surrounded by
spaces (" | ").

{phang}
{opt pairprefix(stub)} specifies characters to be placed in front of 
variable pairs.  For instance, use {cmd:pairprefix("(")} to prefix each pair with 
opening parenthesis.

{phang}
{opt pairsuffix(stub)} as above but placed after pairs.

{phang}
{opt pairdelfirst} specifies that {it: string} of option 
{opt pairdelimiter(string)} is also inserted before the first variable pair.  
By default pairdelimiters are only placed between pairs but omitted at the 
beginning and the end of the list.

{phang}
{opt pairdellast} as above but insert {it:string} after the last pair.

{phang}
{opt pairdelall} is for convenience to easliy specifiy both options 
{opt pairdelfirst} and {opt pairdellast}.{break}
For instance, use {cmd:pairdelimit("|") pairdelall} to get a list with all 
pairs surrounded by pipes: {it:|var1*var2|var1*var3|var2*var3|}


{marker examples}{...}
{title:Examples}

{pstd}Iterate over pairs of variables of interest:{break}
{cmd:. sysuse auto}

{pstd}{cmd:. varcomblist price-mpg t* length, pairprefix(`""("') pairsuffix(`")" "')}{break} 
{cmd:{space 4}vardelimit(", ") local(list)}

{pstd}{cmd:. local i = 1}{break}
{cmd:. foreach pair of local list {c -(}}{break}
{cmd:.{space 8}di "-> pair `i' = `pair'"}{break}
{cmd:.{space 8}local ++i}{break}
{cmd:. {c )-}}


{pstd}Estimate the covariance between errors of {it:mpg} and {it:trunk} in {cmd:sem}:{p_end}
{pstd}{cmd:. sem (mpg <- turn trunk price) (trunk <- length)}{p_end}

{phang}{cmd:. varcomblist mpg trunk, varprefix("e.") local(errcov_endog)}{p_end}
{phang}{cmd:. sem (mpg <- turn trunk price) (trunk <- length),}{break}
       {cmd:covariance(`errcov_endog')}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:varcomblist} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(k)}}number of variables in varlist{p_end}
{synopt:{cmd:r(n_pr)}}number of pairwise combinations of variables in varlist{p_end}
{p2colreset}{...}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(varlist)}}variables in varlist{p_end}
{synopt:{cmd:r(comblist)}}formatted list of pairwise combinations of variables in varlist{p_end}
{synopt:{cmd:r(newlist)}}names of newly created variables (if {opt generate} 
specified){p_end}
{p2colreset}{...}


{marker author}{...}
{title:Author}

{pstd}Sven O. Spieß, s[dot]spiess[at]omegasieben[dot]de{break}
Omegasieben {c -} Ω7, Augsburg, Germany{p_end}

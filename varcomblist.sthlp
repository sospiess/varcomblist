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
{bf:varcomblist} {hline 2} Create pairwise combinations of (affixed) variable lists
               (community-contributed, see also {browse "https://github.com/sospiess/varcomblist":GitHub repository})


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
{synopt:{opt g:enerate}}create interaction variables for pairs formed by 
varlist; if specified varlist must contain only numeric variables{p_end}
{synopt:{opt interact:ion(string)}}specify interaction operator in names of 
generated variables; default is "X"{p_end}

{synopt:{opt l:ocal(macname)}}insert the list of pairs in the local macro 
{it:macname}{p_end}

{syntab:Variables}
{synopt:{opt varsep:arator(string)}}insert specified string between variables; default is asterisk "*"{p_end}
{synopt:{opt varpre:fix(stub1 [stub2])}}prefix first variable in pair with {it:stub1}; second with {it:stub1} or optionally {it:stub2}{p_end}
{synopt:{opt varsuf:fix(stub1 [stub2])}}suffix first variable in pair with {it:stub1}; second with {it:stub1} or optionally {it:stub2}{p_end}

{syntab:Pairs/combinations}
{synopt:{opt pairsep:arator(string)}}insert specified string between pairs; default is single space " "{p_end}
{synopt:{opt pairpre:fix(stub)}}prefix pairs with {it:stub}{p_end}
{synopt:{opt pairsuf:fix(stub)}}suffix pairs with {it:stub}{p_end}

{synopt:{opt pairsepa:ll}}shorthand; implies options {opt pairsepfirst} and 
{opt pairseplast}{p_end}
{synopt:{opt pairsepf:irst}}add pairseparator before first pair{p_end}
{synopt:{opt pairsepl:ast}}add pairseparator after last pair{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}{cmd:varcomblist} creates a formatted list of all pairwise combinations 
of the variables in {varlist}.  For k variables there will accordingly be 
{it:k!/{2!(k - 2)!}} pairs.

{pstd}The command allows to specifiy how variables within pairs are 
separated/hyphenated as well as how pairs are separated from one another.  In 
addition, variables and pairs can be prefixed/suffixed as appropriate.  Thus 
{cmd:varcomblist} can be useful to create multiple interaction terms for 
commands not supporting {help fvvarlist:factor variables} or to specify 
multiple (error) covariances in {help sem_model_options:SEM}, etc.{p_end}


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}{opt generate} specifies that in addtion to creating a formatted list 
of variable pairs, {cmd varcomblist} is to generate all multiplicative 
interactions formed by the pairs in {varlist}.  Interaction terms are not
affected by the formatting (i.e. separators and affixes) applied to the list 
of variable pairs.  If specified, all variables must be 
{help data_types:numeric}.

{phang}{opt interaction(string)} specifies the string to be used as delimiter 
for the generated interaction variables.  {it:string} defaults to "X".

{phang}{opt local(macname)} inserts the list of pairs in local macro {it:macname} 
within the calling program's space. Hence, that macro will be accessible after 
{cmd:varcomblist} has finished.  This is helpful for subsequent use, e.g. with 
{help foreach} or {cmd: sem {it:paths} ..., covariance(`{it:macname}')}.

{dlgtab:Variables}

{phang}
{opt varseparator(string)} specifies characters between the variables in each 
pair.  {it:string} defaults to asterisk, e.g.: {it:var_1}{bf:*}{it:var_2}.{break}
Useful alternatives might be hyphen ("-"), comma and space (", "), or space (" ").

{phang}
{opt varprefix(stub1 [stub2])} specifies characters to be placed in front of 
variables.  If one stub is specified, it is placed in front of both variables 
of the pair; if two stubs are specified, {it:stub1} prefixes the first variable 
and {it:stub2} prefixes the second variable of each pair.  For instance, use 
{cmd:varprefix("e.")} to refer to error terms of variables in {cmd:sem} 
contexts.

{phang}
{opt varsuffix(stub1 [stub2])} as above but placed after variables.

{dlgtab:Pairs/combinations}

{phang}
{opt pairseparator(string)} specifies characters to be inserted between pairs
of variables.  {it:string} defaults to single space, e.g.: {it:var_1*var_2 var_1*var_3 ... var_1*var_k}{break}
Useful alternatives might be semicolon and space ("; "), or pipe surrounded by
spaces (" | ").

{phang}
{opt pairprefix(stub)} specifies characters to be placed in front of 
variable pairs.  For instance, use {cmd:pairprefix("(")} to prefix each pair with 
opening parenthesis.

{phang}
{opt pairsuffix(stub)} as above but placed after pairs.


{marker examples}{...}
{title:Examples}

{pstd}Display pairs of variables of interest:{break}
{cmd:. sysuse auto}

{pstd}{cmd:. varcomblist price-rep78 trunk-length, pairprefix(`""("') pairsuffix(`")" "')}{break} 
{cmd:{space 4}varseparator(", ") local(list)}

{pstd}{cmd:. local i = 1}{break}
{cmd:. foreach pair of local list {c -(}}{break}
{cmd:.{space 8}di "-> pair`i' = `pair'"}{break}
{cmd:.{space 8}local ++i}{break}
{cmd:. {c )-}}


{pstd}Estimate the covariance between errors of {it:mpg} and {it:trunk} in {cmd:sem}:{p_end}
{pstd}{cmd:. sem (mpg <- turn trunk price) (trunk <- length)}{p_end}

{phang}{cmd:. varcomblist mpg trunk, varprefix("e.") local(errcov)}{p_end}
{phang}{cmd:. sem (mpg <- turn trunk price) (trunk <- length),}{break}
       {cmd:covariance(`errcov')}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:varcomblist} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(k)}}number of variables in varlist{p_end}
{synopt:{cmd:r(pr)}}number of pairwise combinations of variables in varlist{p_end}
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

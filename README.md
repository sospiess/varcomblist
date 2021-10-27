# varcomblist
Stata package to create pairwise combinations of (affixed) variable lists


## Description
**varcomblist** is a Stata package which provides the `varcomblist` command 
and related materials to create formatted lists of all pairwise combinations of 
variables in _varlist_.  For _k_ variables there will accordingly be 
_k!/{2!(k - 2)!}_ pairs.

The command allows to specifiy how variables within pairs are 
delimited/hyphenated as well as how pairs are delimited from one another.  In 
addition, variables and pairs can be prefixed/suffixed as appropriate.  Thus 
**varcomblist** can be useful to create multiple interaction terms for commands 
not supporting factor variables or to specify multiple (error) covariances in 
SEM, etc.


After installing type:

    . help varcomblist

to get additional usage information and examples.


## Requires
Stata 13 or higher


## Changelog
_n/a_

---
<small>Sven O. Spieﬂ, $TS$ </small>
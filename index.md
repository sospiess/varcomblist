# VARCOMBLIST
a Stata module to create formatted list of pairwise combinations of variables in Stata


## Description
This repository provides the Stata package for the `varcomblist` command 
and related material to create a formatted (i.e. affixed and delimited) list of 
all pairwise combinations of variables in a _varlist_.  
For _k_ variables there 
will accordingly be _k!/{2!(k - 2)!}_ pairs.

The command allows to specifiy how variables within pairs are 
delimited/hyphenated as well as how pairs are delimited from one another.  In 
addition, individual variables or pairs as a whole can be prefixed/suffixed as appropriate.  Thus 
_varcomblist_ can be useful, e.g., to create multiple interaction terms for 
commands not supporting factor variables or to specify multiple (error) 
covariances in structural equation modelling applications.

To install from within Stata type:

    . net from https://sospiess.github.io/varcomblist/
    . net install varcomblist

After installing type:

    . help varcomblist

to get additional usage information and examples.


## Requires
Stata 13 or higher  
Dependencies: _none_


## Changelog
Notable changes to this project.  
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

### [Unreleased]
-/-

### [1.0.0] - 2021-11-07
- first release of varcomblist package with command, help, and certification 
script

---

<small>Sven O. Spieß, 7 Nov 2021</small>

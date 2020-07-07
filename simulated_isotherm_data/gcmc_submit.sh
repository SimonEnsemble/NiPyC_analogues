#!/bin/bash
# print date and time
date
~/julia-1.3.0/bin/julia -p 4 adsorption_isotherm_script.jl $xtal $gas $FField

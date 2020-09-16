#!/bin/bash
# print date and time
date
~/julia-1.4.2/bin/julia -p 8 adsorption_isotherm_script.jl $xtal $gas $ljff

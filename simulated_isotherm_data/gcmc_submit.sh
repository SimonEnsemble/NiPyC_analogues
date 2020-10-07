#!/bin/bash
# print date and time
date
julia -p 4 adsorption_isotherm_script.jl $xtal $gas $ljff

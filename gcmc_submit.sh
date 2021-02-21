#!/bin/bash
# print date and time
date
julia -p 16 adsorption_isotherm_script.jl $xtal $gas $ljff

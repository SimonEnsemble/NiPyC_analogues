#!/bin/bash
# print date and time
echo "BEGIN \n" `date`
julia -p 16 adsorption_isotherm_script.jl $xtal $gas $ljff
date "END \n" `date`

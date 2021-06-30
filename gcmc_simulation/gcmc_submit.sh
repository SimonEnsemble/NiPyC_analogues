#!/bin/bash
date
julia -p 8 adsorption_isotherm_script.jl $xtal $gas $ljff

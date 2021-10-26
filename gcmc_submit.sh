#!/bin/bash
date
julia -p 16 adsorption_isotherm_script.jl $xtal $gas $ljff

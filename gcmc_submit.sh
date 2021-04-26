#!/bin/bash
date
julia -p 32 adsorption_isotherm_script.jl $xtal $gas $ljff

#! /bin/bash

# This script will install the supplied scriptis to the 
# users bin directory.

## to print statements to screen
#exe() { echo '$' "${@:q}" ; "$@" ; }
exe() { echo ' ' "${@:q}"; }

## first, make sure it exists
mkdir -pv ${HOME}/bin

# then we add symlinks
ln -fvs $(pwd)/bin/tcf ${HOME}/bin/tcf
ln -fvs $(pwd)/python/solve_msd ${HOME}/bin/solve_msd
ln -fvs $(pwd)/python/solve_msd2 ${HOME}/bin/solve_msd2

## then we try and hash it, if we cannot do that, we have to add the binary
# directory to path
if hash tcf 2>/dev/null; then
        echo "Ready to calculate time-correlation functions!"
else
        exe 'Add the following line to your .bashrc:'
        exe 'export PATH=$PATH:${HOME}/bin'
fi

if hash solve_msd 2>/dev/null; then
        echo "Ready to calculate diffusion coefficients!"
else
        exe 'Add the following line to your .bashrc:'
        exe 'export PATH=$PATH:${HOME}/bin'
fi


exit 0

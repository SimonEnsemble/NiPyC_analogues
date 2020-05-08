#!/bin/bash

# use current working directory for input and output
# default is to use the users home directory
#$ -cwd

#$ -pe thread 4 # use 4 threads/cores

 # COMMENT OUT b/c we will pass these into `qsub`.
 # # name this job
 # #$ -N cof_103
 # 
 # # send stdout and stderror to this file
 # #$ -o cof_103.o
 # #$ -e cof_103.e

# select queue - if needed; mime5 is SimonEnsemble priority queue but is restrictive.
#$ -q mime5

# print date and time
date
~/julia-1.3.0/bin/julia -p 4 isotherm_sim.jl $xtal $gas $FField

#!/bin/bash
###
# for QE only use MPI, just keep the "proc" and "OMP_NUM_THREAD" values set at 1, 
# and if you adjust "--ntasks" just make sure you also adjust the "-np" in mpiexec 
# to the same value.
###

module load intel/19
module load qe/6.5
which mpiexec
which pw.x
export OMP_NUM_THREADS=1 
echo "starting QE" `date`
mpiexec -mca btl tcp,self -mca orte_base_help_aggregate 0 -np 32 pw.x -procs 1 -npool 2 -in ./QE_input_scripts/$pw_input_filename
echo "QE finished" `date`

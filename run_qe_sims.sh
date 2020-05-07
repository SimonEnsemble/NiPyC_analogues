#!/bin/bash
###
# for QE only use MPI, just keep the “proc” and “OMP_NUM_THREAD" values set at 1, 
# and if you adjust “—-ntasks” just make sure you also adjust the “-np” in mpiexec 
# to the same value (e.g. 4 in this case)
###
#SBATCH -J qe_ex1_benzene
#SBATCH -A simoncor
#SBATCH -p mime5
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=1
#SBATCH -o qe_ex1_benzene.out
#SBATCH -e qe_ex1_benzene.err

module load intel/19
module load qe
which mpiexec
# which pw.x
export OMP_NUM_THREADS=1 
echo "starting QE" `date`
mpiexec -mca btl tcp,self -mca orte_base_help_aggregate 0 -np 4 ~/qe-6.5/bin/pw.x -procs 1 -in pw.benzene.scf.in
echo "QE finished" `date`

#!/bin/bash
###
# for QE only use MPI, just keep the "proc" and "OMP_NUM_THREAD" values set at 1, 
# and if you adjust "--ntasks" just make sure you also adjust the "-np" in mpiexec 
# to the same value (e.g. 4 in this case)
###
#SBATCH -J pw_NiPyC2_P1_relax
#SBATCH -A simoncor
#SBATCH -p mime5
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=1
#SBATCH -o pw.NiPyC2_P1.relax.out
#SBATCH -e pw.NiPyC2_P1.relax.err
module load slurm
qe_output_loc = "../structural_relaxation"
sbatch -J pw.NiPyC2_sc211.relax -A simoncor -p mime5 --ntasks=8 --cpus-per-task=1 -o $qe_output_loc/pw.NiPyC2_sc211.relax.out -e $qe_output_loc/pw.NiPyC2_sc211.relax.err qe_sims_submit.sh 


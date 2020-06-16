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

# module load slurm
# sbatch -J pw.NiPyC2_P1.vc-relax.in -A simoncor -p mime5 --ntasks=16 --cpus-per-task=1 -o pw.NiPyC2_P1.vc-relax.out -e pw.NiPyC2_P1.vc-relax.err qe_sims_submit.sh 

module load slurm
for xtal in $(cat ./AA_mofs_to_relax.txt)
do 
   sbatch -J $xtal -A simoncor -p mime5 --ntasks=32 --cpus-per-task=1 --time=72:00:00 \
         -o QE_relaxation_results/VDW_relax/NiPyC2_relax_sc211/"$xtal.out" \
         -e QE_relaxation_results/VDW_relax/NiPyC2_relax_sc211/"$xtal.err" \
         --export=xtal="$xtal" qe_sims_submit.sh
done

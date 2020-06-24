#!/bin/bash
###
# for QE only use MPI, just keep the "proc" and "OMP_NUM_THREAD" values set at 1, 
# and if you adjust "--ntasks" just make sure you also adjust the "-np" in mpiexec 
# to the same value (e.g. 4 in this case)
###
##SBATCH -J pw_NiPyC2_P1_relax
##SBATCH -A simoncor
##SBATCH -p mime5
##SBATCH --ntasks=4
##SBATCH --cpus-per-task=1
##SBATCH -o pw.NiPyC2_P1.relax.out
##SBATCH -e pw.NiPyC2_P1.relax.err

# module load slurm
# sbatch -J pw.NiPyC2_P1.vc-relax.in -A simoncor -p mime5 --ntasks=16 --cpus-per-task=1 -o pw.NiPyC2_P1.vc-relax.out -e pw.NiPyC2_P1.vc-relax.err qe_sims_submit.sh 

module load slurm
for pw_input_filename in $(cat ./AA_mofs_to_relax.txt)
do
   ## create the name that will be used for output and job names
   split_filename=(${pw_input_filename//./ })
   pw_sim_name=${split_filename[1]}

   ## submit the simulation
   sbatch -J $pw_sim_name -A simoncor -p mime5 --ntasks=32 --cpus-per-task=1 --time=72:00:00 \
         -o QE_relaxation_results/pbesol_relax/"$pw_sim_name.out" \
         -e QE_relaxation_results/pbesol_relax/"$pw_sim_name.err" \
         --export=pw_input_filename="$pw_input_filename" qe_sims_submit.sh
  
   ## after the simlation finishes, we delete the large, unwanted data files
   rm -rf QE_relaxation_results/pbesol_relax/"$pw_sim_name.save"
done

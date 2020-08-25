#!/bin/bash
###
# for QE only use MPI, just keep the "proc" and "OMP_NUM_THREAD" values set at 1, 
# and if you adjust "--ntasks" just make sure you also adjust the "-np" in mpiexec 
# to the same value.
###

module load slurm

for pw_input_filename in $(cat ./AA_mofs_to_relax.txt)
do
    # create the name that will be used for output and job names
    split_filename=(${pw_input_filename//./ })
    pw_sim_name=${split_filename[1]}

    ## submit the simulation
    sbatch -J $pw_sim_name -A simon-grp -p mime5 --ntasks=64 --cpus-per-task=1 --time=7-00:00:00 \
           --mail-type=ALL --mail-user=gantzlen \
           -o /nfs/hpc/share/gantzlen/"$pw_sim_name.out" \
           -e /nfs/hpc/share/gantzlen/"$pw_sim_name.err" \
           --export=pw_input_filename="$pw_input_filename" qe_sims_submit.sh
done

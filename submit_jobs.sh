#!/bin/bash
## we need to load Slurm so we can submit our jobs with sbatch
module load slurm

for xtal in   NiPyC2_vc-relax.cif 
do
    echo "submitting job for $xtal"
    sbatch -J $xtal -A simoncor -p mime5 -n 4 -o "$xtal.o" -e "$xtal.e" --export xtal="$xtal" gcmc_submit.sh
done

###
# for QE only use MPI, just keep the “proc” and “OMP_NUM_THREAD" values set at 1, 
# and if you adjust “—-ntasks” just make sure you also adjust the “-np” in mpiexec 
# to the same value (e.g. 4 in this case)
###

# NOTE: sbatch does not launch tasks, it requests an allocation of resources and submits a batch script
# optional arguements can be found at https://slurm.schedmd.com/sbatch.html

## SBATCH -J job_name # name that will apprear with id upon query
## SBATCH -A simoncor # sponsored acount = research group
## SBATCH -p mime5 # name of queue or partition to run on
## SBATCH -n 4 # (--ntasks) how many job steps run within the allocated resources   
## SBATCH --cpus-per-task=1 # how many processors per task | default=1) 
##     arguement is set in julia submission as the "-p" flag, so this can be left as default.
## SBATCH -o filename.out # output file
## SBATCH -e filename.err # error file
## SBATCH --mail-type=BEGIN,END,FAIL # event for mailing user
## SBATCH --mail-user=myONID@oregonstate.edu # who will receive the email for the specified events

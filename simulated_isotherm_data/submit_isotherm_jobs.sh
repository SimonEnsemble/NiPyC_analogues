#!/bin/bash
## we need to load Slurm so we can submit our jobs with sbatch
module load slurm

# NiPyC2_relax_meta_functonalized_OH.cif
# NiPyC2_experiment.cif NiPyC2_relax.cif NiPyC2_vc-relax.cif
for xtal in $(cat ./AA_mofs_to_sim.txt)
do
    if [ ! -d ./$xtal ]; then
	mkdir ./$xtal
    fi
    for gas in Xe Kr Ar
    do 
        for FField in UFF.csv # Dreiding.csv
        do 
            echo "submitting job for $xtal with $gas using $FField"
            sbatch -J $xtal$gas$FField -A simoncor -p mime5 -n 16 \
            --mail-type=ALL --mail-user=gantzlen \
            -o ./$xtal/"$xtal-$gas-$FField.o" \
            -e ./$xtal/"$xtal-$gas-$FField.e" \
             --export=xtal="$xtal",gas="$gas",FField="$FField" gcmc_submit.sh
        done
    done
done

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

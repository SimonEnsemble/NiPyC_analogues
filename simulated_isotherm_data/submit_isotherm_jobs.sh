#!/bin/bash
# we need to load Slurm so we can submit our jobs with sbatch
module load slurm
# loop over the xtal names in AA_mofs_to_sim.txt
for xtal in $(cat ./AA_mofs_to_sim.txt)
do
    # make output directory if it doesn't exist
    if [ ! -d ./$xtal ]; then
	    mkdir ./simulated_isotherm_data/$xtal
    fi
    # loop over adsorbates
    for gas in Xe #Kr Ar Xe
    do 
        # loop over forcefields
        for ljff in UFF # Dreiding
        do 
            echo "submitting job for $xtal with $gas using $ljff"
            sbatch -J "$xtal-$gas-$ljff" -A simon-grp -p mime5 -n 16 \
                   -o ./simulated_isotherm_data/$xtal/"$xtal-$gas-$ljff.o" \
                   -e ./simulated_isotherm_data/$xtal/"$xtal-$gas-$ljff.e" \
                   --export=xtal="$xtal",gas="$gas",ljff="$ljff" gcmc_submit.sh
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

#!/bin/bash
echo "#### START #### " `date`

probe_radius=1.55 # atomic radius of N2 probe in Angstroms
num_samples=5000  # number of Monte Carlo integration samples
crystals_loc=../data/crystals

output_loc=./zeo_outputs
mkdir -p $output_loc

for xtal in $(cat ./AA_mofs_to_sim.txt)
do
    ~/zeo++-0.3/network -stripatomnames -ha -res $output_loc/$xtal.res \
                        -vol $probe_radius $probe_radius 10*$num_samples $output_loc/$xtal.vol \
                        -sa $probe_radius $probe_radius 100*$num_samples $output_loc/$xtal.sa \
                        $crystals_loc/$xtal
done

# compile results into summary files
cat ./$output_loc/*.res > ./summary_pore_diameters.txt
grep "@" ./$output_loc/*.vol > ./summary_void_fractions.txt
grep "@" ./$output_loc/*.sa > ./summary_surface_areas.txt

echo "#### END ####" `date`


# run julia script to compile desired quantities into CSV
julia compile_zeo_results.jl

In order to run `muVT_sim` (Grand Canonical Monte Carlo) 
1. make sure the crystals filenames are in `AA_mofs_to_sim.txt`
2. run the `submit_isotherm_job.sh`

Simulation logs are printed to the `simulation_logs` subdirectory, named by corresponding crystal and adsorbate.
Simulation outputs (results dictionary) are located in `../data/simulations` as `.jld2` files.

In order to run `henry_coefficient` edit `submit_isotherm_sim.sh` to:
1. call the `henry_submit.sh` script and 
2. ouput `simulation_log` file path to `./simulation_log/henry_calc/$xtal`.

using PorousMaterials
###
#  Define paths
###
set_paths(joinpath("/nfs/stak/users/gantzlen/DTRA/data"))

# post QE relaxation .cif file location
#rc[:paths][:crystals] = joinpath("/nfs/stak/users/gantzlen/DTRA/structural_relaxation/post-relaxation_cifs")
@info rc[:paths]

###
#  Read command line arguments: name of - crystal structure, adsorbate, and forcefield
###
if length(ARGS) != 3
    error("pass the crystal structure name as a command line argument followed by the adsorbate then the forcefield,
 	such as: julia cof_isotherm_sim.jl COF-102.cif Xe UFF.csv")
end
crystal   = ARGS[1]
adsorbate = ARGS[2]
ffield    = ARGS[3]
println("running mol sim in ", crystal, " with ", adsorbate, " and ", ffield)

###
#  Set Simulation Parameters and keyword arguments
###
sim_params = Dict("xtal"        => Crystal(crystal, remove_duplicates=true),
                  "molecule"    => Molecule(adsorbate),
                  "temperature" => 298.0,
                  "ljff"        => LJForceField(ffield)
                 )

strip_numbers_from_atom_labels!(sim_params["xtal"])

kwargs = Dict(:insertions_per_volume => 500)

###
#  Run simulation
###
results = henry_coefficient(sim_params["xtal"],
                            sim_params["molecule"],
                            sim_params["temperature"],
                            sim_params["ljff"]; 
                            kwargs...)

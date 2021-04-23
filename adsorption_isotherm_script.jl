using PorousMaterials
###
#  Define paths
###
@eval PorousMaterials PATH_TO_DATA = joinpath("/nfs/stak/users/gantzlen/DTRA/data")
@info PorousMaterials.PATH_TO_DATA

## post QE relaxation .cif file location
# @eval PorousMaterials PATH_TO_CRYSTALS = joinpath("/nfs/stak/users/gantzlen/DTRA/structural_relaxation/post-relaxation_cifs")
# @eval PorousMaterials PATH_TO_CRYSTALS = joinpath("..", "structural_relaxation", "post-relaxation_cifs")
# @eval PorousMaterials PATH_TO_CRYSTALS = joinpath(PorousMaterials.PATH_TO_DATA, "crystals", "tmp_xtal")
@info PorousMaterials.PATH_TO_CRYSTALS

###
#  Read command line arguments: name of - crystal structure, adsorbate, and forcefield
###
if length(ARGS) != 3
    error("pass the crystal structure name as a command line argument followed by the adsorbate then the forcefield,
 	such as: julia cof_isotherm_sim.jl COF-102.cif Xe UFF.csv")
end
crystal = ARGS[1]
adsorbate = ARGS[2]
ffield = ARGS[3]
println("running mol sim in ", crystal, " with ", adsorbate, " and ", ffield)

###
#  Set Simulation Parameters and keyword arguments
###
pmin   = -3   # in log10, units: bar
pmax   = 1.0  # value of max pressure (actual value), units: bar
nsteps = 25   # number of pressure intervals to split range

sim_params = Dict("xtal"        => Crystal(crystal, remove_duplicates=true),
                  "molecule"    => Molecule(adsorbate),
                  "temperature" => 298.0,
                  "pressures"   => 10 .^ range(pmin, stop=pmax, length=nsteps),
                  "ljff"        => LJForceField(ffield)
                 )

strip_numbers_from_atom_labels!(sim_params["xtal"])

kwargs = Dict(:n_burn_cycles   => 50000, 
              :n_sample_cycles => 50000
             )

###
#  Run simulation
###
results = adsorption_isotherm(sim_params["xtal"],
                              sim_params["molecule"],
                              sim_params["temperature"],
                              sim_params["pressures"],
                              sim_params["ljff"];
                              kwargs...
                             )

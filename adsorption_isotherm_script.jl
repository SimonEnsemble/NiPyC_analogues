using PorousMaterials
## define path to data folder (absolute path on hpc)
@eval PorousMaterials PATH_TO_DATA = joinpath("/nfs/stak/users/gantzlen/DTRA/data")
@info PorousMaterials.PATH_TO_DATA

## post QE relaxation .cif file location
@eval PorousMaterials PATH_TO_CRYSTALS = joinpath("/nfs/stak/users/gantzlen/DTRA/structural_relaxation/post-relaxation_cifs")
# @eval PorousMaterials PATH_TO_CRYSTALS = joinpath("..", "structural_relaxation", "post-relaxation_cifs")
#@eval PorousMaterials PATH_TO_CRYSTALS = joinpath(PorousMaterials.PATH_TO_DATA, "crystals", "tmp_xtal")
@info PorousMaterials.PATH_TO_CRYSTALS



# read in name of crystal structure, adsorbate, and forcefield from command line arguments
if length(ARGS) != 3
    error("pass the crystal structure name as a command line argument followed by the adsorbate then the forcefield,
 	such as: julia cof_isotherm_sim.jl COF-102.cif Xe UFF.csv")
end
crystal = ARGS[1]
adsorbate = ARGS[2]
ffield = ARGS[3]
println("running mol sim in ", crystal, " with ", adsorbate, " and ", ffield)

# read in crystal structure
xtal = Crystal(crystal)
strip_numbers_from_atom_labels!(xtal)

## define simulation parameters
mol  = Molecule(adsorbate)
ljff = LJForceField(ffield, mixing_rules="Lorentz-Berthelot")
temp =  298.0 # K

pmin   = -2   # in log10, units: bar
pmax   = 1.1  # value of max pressure (actual value), units: bar
nsteps = 25 # number of pressure intervals to split range
pressures = 10 .^ range(pmin, stop=log10(pmax), length=nsteps) # bar

n_sample_cycles = 50000 
n_burn_cycles   = 50000

# for low pressure ranges we can get away with using the ideal gas
# equation of state (default), for high pressures use eos=:PengRobinson.
# equation_of_state = :PengRobinson

## assign sim output to a variable
adsorption_data = adsorption_isotherm(xtal, mol, temp, pressures, ljff, 
                                      n_burn_cycles=n_burn_cycles, 
                                      n_sample_cycles=n_sample_cycles,
                                      calculate_density_grid=false)


# henry_result = henry_coefficient(xtal, mol, temp, ljff; insertions_per_volume=500)

##  run density grid calculations over the xtal unit cell
#n_sample_cycles = 25000
#n_burn_cycles = 25000

#press = 0.01 # bar [0.01, 0.10, 1.1]
#gcmc_results = μVT_sim(xtal, mol, temp, press, ljff, 
#                 n_burn_cycles=n_burn_cycles,
#                 n_sample_cycles=n_sample_cycles,
#                 calculate_density_grid=true,
#                 density_grid_dx=0.2,
#                 density_grid_sim_box=false) 

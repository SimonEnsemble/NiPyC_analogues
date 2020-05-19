using PorousMaterials
# run using master branch

# read in crystal structure name from command line arguments
if length(ARGS) != 3
    error("pass the crystal structure name as a command line argument followed by the adsorbate then the forcefield,
 	such as: julia cof_isotherm_sim.jl COF-102.cif Xe")
end
crystal = ARGS[1]
adsorbate = ARGS[2]
ffield = ARGS[3]
println("running mol sim in ", crystal, "with ", adsorbate, "and ", ffield)

frame = Framework(crystal)
strip_numbers_from_atom_labels!(frame)

mol = Molecule(adsorbate)
forcefield = LJForceField(ffield, mixing_rules="Lorentz-Berthelot")
temp =  298.0 # K

# Pressures
pmin = -2 # in log10, units: bar
pmax = 1.2 # value of max pressure (actual value), units: bar
nsteps = 5 #15 # number of pressure intervals to split range
pressures = 10 .^ range(pmin, stop=log10(pmax), length=nsteps) # bar

n_sample_cycles = 5 #50000
n_burn_cycles = 5 #50000

# for low pressure ranges we can get away with using the ideal gas
# equation of state (default), for high pressures use eos=:PengRobinson.
# EOS = :PengRobinson

adsorption_data = adsorption_isotherm(frame, mol, temp, pressures, forcefield,
                    n_burn_cycles=n_burn_cycles, n_sample_cycles=n_sample_cycles)

using PorousMaterials

# read in crystal structure name from command line arguments
if length(ARGS) != 1
    error("pass the crystal structure name as a command line argument, such as:
    julia cof_isotherm_sim.jl COF-102.cif")
end
crystal = ARGS[1]
println("running mol sim in ", crystal)

frame = Framework(crystal)
# frame = Crystal(crystal)
strip_numbers_from_atom_labels!(frame)

temp =  298.0 # K
# forcefield = LJForceField("Dreiding.csv", mixing_rules="Lorentz-Berthelot")
forcefield = LJForceField("UFF.csv", mixing_rules="Lorentz-Berthelot")
mol = Molecule("Xe")

pressures = 10 .^ range(-2, stop=log10(1.2), length=15) # bar

n_sample_cycles = 50000 #25000
n_burn_cycles = 50000 #25000

# for low pressure ranges we can get away with using the ideal gas 
# equation of state (default), for high pressures use eos=:PengRobinson. 

adsorption_data = adsorption_isotherm(frame, mol, temp, pressures, forcefield,
		    n_burn_cycles=n_burn_cycles, n_sample_cycles=n_sample_cycles)

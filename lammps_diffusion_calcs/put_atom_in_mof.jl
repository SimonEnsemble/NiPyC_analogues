using PorousMaterials

xtal        = Crystal("Pn_Ni-PyC-NH2.cif") # ("NiPyC2_experiment.cif") 
adsorbate   = Molecule("Ar") # Ar, Kr, or Xe
temperature = 298.0 # unit: K
pressure    = 1.0   # unit: bar
ljff        = LJForceField("UFF") # default: r_cutoff=14.0, mixing_rules="Lorentz-Berthelot"
n_cpv       = 10    # cycles per volume
fraction_burn_cycles = 0.5

###
#  rum a quick sim to put atom in xtal
###
res, mol = μVT_sim(xtal, adsorbate, temperature, pressure, ljff, n_cycles_per_volume=n_cpv)

###
#  get adsorbates present in the original unit cell of the xtal
###
n = rand(1:length(mol[1])) # pick a random atom from list of atoms in mof
reps = replication_factors(xtal.box, ljff) # number of replications in each direction needed for sim box
rep_xtal = replicate(xtal, reps) # replicate xtal to simulation size

frac_mol = Frac.(mol[1], rep_xtal.box) # put molecules in fractional coordinates
mol_inside = frac_mol[inside.(mol[1][:], rep_xtal.box)] # get molecules in original xtal unit cell

# create a new array of atoms (xtal atoms) + (adsorbate atoms in box)
atoms = rep_xtal.atoms + mol_inside[n].atoms # original: n=1 to get first atom in array

# create a name for the new xtal to be writen
name  = split(xtal.name, ".cif")[1] * "_with_" * String(adsorbate.species)

# construct a new crystal which contains the original frameworks atoms and the adsorbates
xtal_with_gas = Crystal(name, rep_xtal.box, atoms, rep_xtal.charges)

# write cif
write_cif(xtal_with_gas)




###
#  Strategy:
#
# 1. standard setup for GCMC sim using xtal, mol, UFF, temp etc.
# 2. run a short GCMC simulation to put molecules (Xe or Kr) into extal 
#    be sure to store results and molecule outputs
# 3. randomly select a sindle molecule that is inside the replicated xtal
#    (this one will serve as the MD diffusion probe)
# 4. assert that it is inside of the simulation box
# 5. write a new xtal which includes the probe molecule inside the fully replicated xtal
# 6. This new system (replicated xtal with adsorbate) will then be passed to lammps-interface
#    so that a data.filename and in.filename will be generated
# 7. The lammps-interface generated input script will then be taken and used as a template for 
#    a script that will be writen to run the diffusion calculations
#       - informatin that we need from this is the grouping indecies
###

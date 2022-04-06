using PorousMaterials

xtal        = Crystal("NiPyC2_experiment.cif")
xenon       = Molecule("Xe") # Kr
temperature = 298.0
pressure    = 1.0
ljff        = LJForceField("UFF")
n_cpv       = 10
fraction_burn_cycles = 0.5

# res, mol = μVT_sim(xtal, xenon, temperature, pressure, ljff, n_cycles_per_volume=n_cpv, write_adsorbate_snapshots=true)
res, mol = μVT_sim(xtal, xenon, temperature, pressure, ljff, n_cycles_per_volume=n_cpv)


# get adsorbates present in the original unit cell of the xtal
frac_mol = Frac.(mol[1], xtal.box)
mol_inside = frac_mol[inside.(mol[1][:], xtal.box)]

# create a new array of atoms (xtal atoms) + (adsorbate atoms in box)
atoms = xtal.atoms + mol_inside[1].atoms

# create a name for the new xtal to be writen
name  = split(xtal.name, ".cif")[1] * "_with_" * String(xenon.species)

# construct a new crystal which contains the original frameworks atoms and the adsorbates
xtal_with_gas = Crystal(name, xtal.box, atoms, xtal.charges)

# write cif
write_cif(xtal_with_gas)





# calculate the number of MC cycles
# separate total number of cycles evenly into burn_cycles and sample_cycles
#nb_cycles = max(5, ceil(Int, n_cpv * xtal.box.Ω))
#@assert (0.0 < fraction_burn_cycles) && (fraction_burn_cycles < 1.0) 
#n_burn_cycles   = ceil(Int, nb_cycles * fraction_burn_cycles)
#n_sample_cycles = ceil(Int, nb_cycles * (1 - fraction_burn_cycles))
#filename = μVT_output_filename(xtal, xenon, temperature, pressure, ljff, n_burn_cycles, n_sample_cycles)
#xyz_file = split(filename, ".jld2")[1]
#print(xyz_file)
#write_xyz(mol, xtal.box)

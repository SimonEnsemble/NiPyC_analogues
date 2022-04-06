using PorousMaterials

xtal        = Crystal("Pn_Ni-PyC-NH2.cif") # "NiPyC2_experiment.cif"
xenon       = Molecule("Xe") # Kr
temperature = 298.0 # unit: K
pressure    = 1.0   # unit: bar
ljff        = LJForceField("UFF")
n_cpv       = 10 # cycles per volume
fraction_burn_cycles = 0.5

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


using PorousMaterials
using LightGraphs
using Printf
@eval PorousMaterials PATH_TO_CRYSTALS = pwd()

# for viz
f=Framework("NiPyC2.cif")
strip_numbers_from_atom_labels!(f)
f = replicate(f, (3,3,3))
write_xyz(f)

# for bonds
f=Framework("NiPyC2.cif")
strip_numbers_from_atom_labels!(f)
write_xyz(f)
infer_bonds!(f, false)
write_bond_information(f, "NiPyC2_bonds.vtk")

# iterate thru grpahs
for ed in edges(f.bonds)
    @printf("bond between atom %d (%s) and atom %d (%s)\n",
        ed.src,
        f.atoms.species[ed.src],
        ed.dst,
        f.atoms.species[ed.dst])
end

# get ids of N atoms
ids_N = [i for i = 1:f.atoms.n_atoms][f.atoms.species .== :N]
# find carbon's attached to the Ns. these are the "ortho" carbons
ids_C_aro_ortho = []
for id_N in ids_N
    # get the neighbors of these N's
    ids_neighbors = neighbors(f.bonds, id_N)
    for id in ids_neighbors
        @assert f.atoms.species[id] == :C
    end
end


using PorousMaterials
using LightGraphs
using Printf
@eval PorousMaterials PATH_TO_CRYSTALS = pwd()

# for viz
f = Framework("NiPyC2.cif")
strip_numbers_from_atom_labels!(f)
f = replicate(f, (3,3,3))
write_xyz(f, "NiPyC2_supercell.xyz")

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


# find carbon's attached to the N's (these are the "ortho" carbons)
ids_neighbors = []
ids_C_aro_ortho = []
ids_C_aro_meta = [] 

# look at a particular N
# look at each C in its neighbors
# look at all of the bonds in the grapph
# determine wich C's are bonded to which N's
# store them as a  [N,[C_ortho_1,C_ortho_2]]

# get ids of N atoms
ids_N = [i for i = 1:f.atoms.n_atoms][f.atoms.species .== :N]
# find carbon's attached to the Ns. these are the "ortho" carbons
ids_C_aro_ortho = []
for id_N in ids_N
    # get the neighbors of these N's
    ids_neighbors = neighbors(f.bonds, id_N)
    for id in ids_neighbors
        @assert f.atoms.species[id] == :C 
	ids_meta_n = neighbors(f.bonds, id)
        for id_meta in ids_meta_n
		if f.atoms.species[id_meta] == :C
                print(id, " -> ", id_meta, "\n")
		end
	end
    end
    push!(ids_C_aro_ortho,[id_N, ids_neighbors])
end

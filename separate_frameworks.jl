using PorousMaterials
using LightGraphs
@eval PorousMaterials PATH_TO_CRYSTALS = pwd()

filename = "NiPyC2.cif"
structure_name = split(filename, ".")[1]
f = Framework(filename)
strip_numbers_from_atom_labels!(f)
wrap_atoms_to_unit_cell!(f)

bonding_rules = [BondingRule(:H, :*, 0.4, 1.2),
                 BondingRule(:N, :Ni, 0.4, 2.5),
                 BondingRule(:O, :Ni, 0.4, 2.5),
                 BondingRule(:*, :*, 0.4, 1.9)]

rep_factors = (2, 2, 2)

f_222 = replicate(f, rep_factors)

infer_bonds!(f_222, true, bonding_rules)
write_xyz(f_222, "rep_NiPyC2_atoms.xyz")
write_bond_information(f_222, "rep_NiPyC2_bonds.vtk")

conn_comps = connected_components(f_222.bonds)

@printf("The (%d, %d, %d) replication of %s has %d connected components\n", rep_factors..., filename, length(conn_comps))

for (comp_num, component) in enumerate(conn_comps)
    atoms_xf = fill(0.0, 3, length(component))
    charges_xf = fill(0.0, 3, length(component))
    atoms_species = fill(:*, length(component))
    charges_q = fill(0.0, length(component))
    for i in 1:length(component)
        atoms_xf[:, i] .= f_222.atoms.xf[:, component[i]]
        atoms_species[i] = f_222.atoms.species[component[i]]
        if f_222.charges.n_charges > 0
            charges_q[i] = f_222.charges.q[component[i]]
            charges_xf[:, i] .= f_222.charges.xf[:, component[i]]
        end
    end
    if f_222.charges.n_charges > 0
        charges_xf = Array{Float64, 2}(undef, 3, 0)
        charges_q = Array{Float64, 1}(undef, 0)
    end
    comp_name = @sprintf("%s_comp%d", structure_name, comp_num)
    comp_f = Framework(comp_name, f_222.box, Atoms(atoms_species, atoms_xf),
                       Charges(charges_q, charges_xf))
    infer_bonds!(comp_f, true, bonding_rules)
    write_xyz(comp_f, joinpath("component_frameworks", comp_name * "_atoms.xyz"))
    write_bond_information(comp_f, joinpath("component_frameworks", comp_name * "_bonds.vtk"))
end

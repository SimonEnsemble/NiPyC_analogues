using PorousMaterials
using LightGraphs
using Printf
# @eval PorousMaterials PATH_TO_CRYSTALS = pwd()

filename = "NiPyC2.cif"
structure_name = split(filename, ".")[1]
f = Crystal(filename)
strip_numbers_from_atom_labels!(f)
wrap!(f)

bonding_rules = [BondingRule(:H, :*, 0.4, 1.2),
                 BondingRule(:N, :Ni, 0.4, 2.5),
                 BondingRule(:O, :Ni, 0.4, 2.5),
                 BondingRule(:*, :*, 0.4, 1.9)]

rep_factors = (4, 4, 4)

f_replicated = replicate(f, rep_factors)

infer_bonds!(f_replicated, false, bonding_rules)
write_xyz(Cart(f_replicated.atoms, f_replicated.box), "rep_NiPyC2_atoms.xyz") # Cart(atoms_f, box)
write_bond_information(f_replicated, "rep_NiPyC2_bonds.vtk")

conn_comps = connected_components(f_replicated.bonds)

@printf("The (%d, %d, %d) replication of %s has %d connected components\n", rep_factors..., filename, length(conn_comps))

for (comp_num, component) in enumerate(conn_comps)
    atoms_xf = fill(0.0, 3, length(component))
    charges_xf = fill(0.0, 3, length(component))
    atoms_species = fill(:*, length(component))
    charges_q = fill(0.0, length(component))
    
    for i in 1:length(component)
        atoms_xf[:, i]  .= f_replicated.atoms.coords.xf[:, component[i]]
        atoms_species[i] = f_replicated.atoms.species[component[i]]
        if f_replicated.charges.n > 0
            charges_q[i] = f_replicated.charges.q[component[i]]
            charges_xf[:, i] .= f_replicated.charges.coords.xf[:, component[i]]
        end
    end
    
    if f_replicated.charges.n == 0
        charges_xf = Array{Float64, 2}(undef, 3, 0)
        charges_q = Array{Float64, 1}(undef, 0)
    end
    
    atoms_xf   = Frac(atoms_xf)   # turn atom Array into type Frac 
    charges_xf = Frac(charges_xf) # turn charge Array into type Frac
    
    comp_name = @sprintf("%s_comp%d", structure_name, comp_num)
    comp_f = Crystal(comp_name, f_replicated.box, Atoms(atoms_species, atoms_xf),
                       Charges(charges_q, charges_xf))
    comp_f # write component xtal to screen

    # not bonding across periodic boundaries so it is easier to see
    infer_bonds!(comp_f, false, bonding_rules)
    write_xyz(Cart(comp_f.atoms, comp_f.box), joinpath("component_frameworks", comp_name * "_atoms.xyz"))
    write_bond_information(comp_f, joinpath("component_frameworks", comp_name * "_bonds.vtk"))
    write_cif(comp_f, comp_name)
end

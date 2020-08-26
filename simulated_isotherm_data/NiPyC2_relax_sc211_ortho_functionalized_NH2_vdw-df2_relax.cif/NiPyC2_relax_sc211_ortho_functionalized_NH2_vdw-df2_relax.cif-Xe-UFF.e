ERROR: LoadError: SystemError: opening file "/nfs/stak/users/gantzlen/DTRA/data/crystals/NiPyC2_relax_sc211_ortho_functionalized_NH2_vdw-df2_relax.cif": No such file or directory
Stacktrace:
 [1] systemerror(::String, ::Int32; extrainfo::Nothing) at ./error.jl:168
 [2] #systemerror#50 at ./error.jl:167 [inlined]
 [3] systemerror at ./error.jl:167 [inlined]
 [4] open(::String; read::Bool, write::Nothing, create::Nothing, truncate::Nothing, append::Nothing) at ./iostream.jl:254
 [5] open(::String, ::String) at ./iostream.jl:310
 [6] Crystal(::String; check_neutrality::Bool, net_charge_tol::Float64, check_overlap::Bool, overlap_tol::Float64, convert_to_p1::Bool, read_bonds_from_file::Bool, wrap_coords::Bool, include_zero_charges::Bool, remove_duplicates::Bool, species_col::Array{String,1}) at /nfs/stak/users/gantzlen/.julia/dev/PorousMaterials/src/crystal.jl:97
 [7] Crystal(::String) at /nfs/stak/users/gantzlen/.julia/dev/PorousMaterials/src/crystal.jl:91
 [8] top-level scope at /nfs/stak/users/gantzlen/DTRA/adsorption_isotherm_script.jl:22
 [9] include(::Module, ::String) at ./Base.jl:377
 [10] exec_options(::Base.JLOptions) at ./client.jl:288
 [11] _start() at ./client.jl:484
in expression starting at /nfs/stak/users/gantzlen/DTRA/adsorption_isotherm_script.jl:22

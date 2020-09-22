[ Info: /nfs/stak/users/gantzlen/DTRA/data
[ Info: /nfs/stak/users/gantzlen/DTRA/data/crystals
ERROR: LoadError: SystemError: opening file "/nfs/stak/users/gantzlen/DTRA/data/crystals/NiPyC2_relax_sc211_meta_functionalized_NH2_pbesol_relax.cif": No such file or directory
Stacktrace:
 [1] systemerror(::String, ::Int32; extrainfo::Nothing) at ./error.jl:168
 [2] #systemerror#48 at ./error.jl:167 [inlined]
 [3] systemerror at ./error.jl:167 [inlined]
 [4] open(::String; lock::Bool, read::Bool, write::Nothing, create::Nothing, truncate::Nothing, append::Nothing) at ./iostream.jl:284
 [5] open(::String, ::String; lock::Bool) at ./iostream.jl:346
 [6] open(::String, ::String) at ./iostream.jl:346
 [7] Crystal(::String; check_neutrality::Bool, net_charge_tol::Float64, check_overlap::Bool, overlap_tol::Float64, convert_to_p1::Bool, read_bonds_from_file::Bool, wrap_coords::Bool, include_zero_charges::Bool, remove_duplicates::Bool, species_col::Array{String,1}) at /nfs/stak/users/gantzlen/.julia/dev/PorousMaterials/src/crystal.jl:97
 [8] Crystal(::String) at /nfs/stak/users/gantzlen/.julia/dev/PorousMaterials/src/crystal.jl:91
 [9] top-level scope at /nfs/stak/users/gantzlen/DTRA/adsorption_isotherm_script.jl:22
 [10] include(::Function, ::Module, ::String) at ./Base.jl:380
 [11] include(::Module, ::String) at ./Base.jl:368
 [12] exec_options(::Base.JLOptions) at ./client.jl:296
 [13] _start() at ./client.jl:506
in expression starting at /nfs/stak/users/gantzlen/DTRA/adsorption_isotherm_script.jl:22

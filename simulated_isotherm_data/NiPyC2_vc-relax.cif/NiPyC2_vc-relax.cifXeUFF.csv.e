ERROR: LoadError: On worker 2:
Cannot find atomicmasses.csv file in your data folder

error at ./error.jl:33
read_atomic_masses at /nfs/stak/users/gantzlen/.julia/dev/PorousMaterials/src/Misc.jl:126
molecular_weight at /nfs/stak/users/gantzlen/.julia/dev/PorousMaterials/src/Crystal.jl:833 [inlined]
crystal_density at /nfs/stak/users/gantzlen/.julia/dev/PorousMaterials/src/Crystal.jl:855
#gcmc_simulation#145 at /nfs/stak/users/gantzlen/.julia/dev/PorousMaterials/src/GCMC.jl:431
#gcmc_simulation at ./none:0 [inlined]
run_pressure at /nfs/stak/users/gantzlen/.julia/dev/PorousMaterials/src/GCMC.jl:231
#108 at /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.3/Distributed/src/process_messages.jl:294
run_work_thunk at /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.3/Distributed/src/process_messages.jl:79
macro expansion at /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.3/Distributed/src/process_messages.jl:294 [inlined]
#107 at ./task.jl:333
Stacktrace:
 [1] (::Base.var"#732#734")(::Task) at ./asyncmap.jl:178
 [2] foreach(::Base.var"#732#734", ::Array{Any,1}) at ./abstractarray.jl:1920
 [3] maptwice(::Function, ::Channel{Any}, ::Array{Any,1}, ::Array{Float64,1}) at ./asyncmap.jl:178
 [4] wrap_n_exec_twice(::Channel{Any}, ::Array{Any,1}, ::Distributed.var"#208#211"{WorkerPool}, ::Function, ::Array{Float64,1}) at ./asyncmap.jl:154
 [5] #async_usemap#717(::Function, ::Nothing, ::typeof(Base.async_usemap), ::Distributed.var"#192#194"{Distributed.var"#192#193#195"{WorkerPool,PorousMaterials.var"#run_pressure#142"{Int64,Int64,Int64,Bool,Float64,Symbol,Bool,Dict{Any,Any},Int64,Bool,Bool,Bool,Int64,Bool,Float64,Nothing,String,Framework,Molecule,Float64,LJForceField}}}, ::Array{Float64,1}) at ./asyncmap.jl:103
 [6] (::Base.var"#kw##async_usemap")(::NamedTuple{(:ntasks, :batch_size),Tuple{Distributed.var"#208#211"{WorkerPool},Nothing}}, ::typeof(Base.async_usemap), ::Function, ::Array{Float64,1}) at ./none:0
 [7] #asyncmap#716 at ./asyncmap.jl:81 [inlined]
 [8] #asyncmap at ./none:0 [inlined]
 [9] #pmap#207(::Bool, ::Int64, ::Nothing, ::Array{Any,1}, ::Nothing, ::typeof(pmap), ::Function, ::WorkerPool, ::Array{Float64,1}) at /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.3/Distributed/src/pmap.jl:126
 [10] pmap(::Function, ::WorkerPool, ::Array{Float64,1}) at /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.3/Distributed/src/pmap.jl:101
 [11] #pmap#217(::Base.Iterators.Pairs{Union{},Union{},Tuple{},NamedTuple{(),Tuple{}}}, ::typeof(pmap), ::Function, ::Array{Float64,1}) at /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.3/Distributed/src/pmap.jl:156
 [12] pmap at /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.3/Distributed/src/pmap.jl:156 [inlined]
 [13] #adsorption_isotherm#139(::Int64, ::Int64, ::Int64, ::Bool, ::Float64, ::Symbol, ::Bool, ::Dict{Any,Any}, ::Int64, ::Bool, ::Bool, ::Bool, ::Int64, ::Bool, ::Float64, ::Nothing, ::String, ::typeof(adsorption_isotherm), ::Framework, ::Molecule, ::Float64, ::Array{Float64,1}, ::LJForceField) at /nfs/stak/users/gantzlen/.julia/dev/PorousMaterials/src/GCMC.jl:253
 [14] (::PorousMaterials.var"#kw##adsorption_isotherm")(::NamedTuple{(:n_burn_cycles, :n_sample_cycles),Tuple{Int64,Int64}}, ::typeof(adsorption_isotherm), ::Framework, ::Molecule, ::Float64, ::Array{Float64,1}, ::LJForceField) at ./none:0
 [15] top-level scope at /nfs/stak/users/gantzlen/DTRA/simulated_isotherm_data/isotherm_sim.jl:35
 [16] include at ./boot.jl:328 [inlined]
 [17] include_relative(::Module, ::String) at ./loading.jl:1105
 [18] include(::Module, ::String) at ./Base.jl:31
 [19] exec_options(::Base.JLOptions) at ./client.jl:287
 [20] _start() at ./client.jl:460
in expression starting at /nfs/stak/users/gantzlen/DTRA/simulated_isotherm_data/isotherm_sim.jl:35

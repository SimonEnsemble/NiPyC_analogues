[ Info: /nfs/stak/users/gantzlen/DTRA/data
[ Info: /nfs/stak/users/gantzlen/DTRA/structural_relaxation/post-relaxation_cifs
Worker 8 terminated.
Worker 7 terminated.
Worker 10 terminated.
Worker 2 terminated.
ERROR: LoadError: ProcessExitedException(2)
Stacktrace:
 [1] (::Base.var"#770#772")(::Task) at ./asyncmap.jl:178
 [2] foreach(::Base.var"#770#772", ::Array{Any,1}) at ./abstractarray.jl:2009
 [3] maptwice(::Function, ::Channel{Any}, ::Array{Any,1}, ::Array{Array{Float64,1},1}) at ./asyncmap.jl:178
 [4] wrap_n_exec_twice(::Channel{Any}, ::Array{Any,1}, ::Distributed.var"#206#209"{WorkerPool}, ::Function, ::Array{Array{Float64,1},1}) at ./asyncmap.jl:154
 [5] async_usemap(::Distributed.var"#190#192"{Distributed.var"#190#191#193"{WorkerPool,PorousMaterials.var"#run_pressure#184"{Base.Iterators.Pairs{Symbol,Integer,Tuple{Symbol,Symbol,Symbol},NamedTuple{(:n_burn_cycles, :n_sample_cycles, :calculate_density_grid),Tuple{Int64,Int64,Bool}}},Crystal,Array{Molecule{Cart},1},Float64,LJForceField}}}, ::Array{Array{Float64,1},1}; ntasks::Function, batch_size::Nothing) at ./asyncmap.jl:103
 [6] #asyncmap#754 at ./asyncmap.jl:81 [inlined]
 [7] pmap(::Function, ::WorkerPool, ::Array{Array{Float64,1},1}; distributed::Bool, batch_size::Int64, on_error::Nothing, retry_delays::Array{Any,1}, retry_check::Nothing) at /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.5/Distributed/src/pmap.jl:126
 [8] pmap(::Function, ::WorkerPool, ::Array{Array{Float64,1},1}) at /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.5/Distributed/src/pmap.jl:101
 [9] pmap(::Function, ::Array{Array{Float64,1},1}; kwargs::Base.Iterators.Pairs{Union{},Union{},Tuple{},NamedTuple{(),Tuple{}}}) at /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.5/Distributed/src/pmap.jl:156
 [10] pmap at /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.5/Distributed/src/pmap.jl:156 [inlined]
 [11] adsorption_isotherm(::Crystal, ::Array{Molecule{Cart},1}, ::Float64, ::Array{Array{Float64,1},1}, ::LJForceField; kwargs::Base.Iterators.Pairs{Symbol,Integer,Tuple{Symbol,Symbol,Symbol},NamedTuple{(:n_burn_cycles, :n_sample_cycles, :calculate_density_grid),Tuple{Int64,Int64,Bool}}}) at /nfs/stak/users/gantzlen/.julia/dev/PorousMaterials/src/gcmc.jl:1008
 [12] #adsorption_isotherm#187 at /nfs/stak/users/gantzlen/.julia/dev/PorousMaterials/src/gcmc.jl:1017 [inlined]
 [13] top-level scope at /nfs/stak/users/gantzlen/DTRA/adsorption_isotherm_script.jl:46
 [14] include(::Function, ::Module, ::String) at ./Base.jl:380
 [15] include(::Module, ::String) at ./Base.jl:368
 [16] exec_options(::Base.JLOptions) at ./client.jl:296
 [17] _start() at ./client.jl:506
in expression starting at /nfs/stak/users/gantzlen/DTRA/adsorption_isotherm_script.jl:46
┌ Warning: Forcibly interrupting busy workers
│   exception = rmprocs: pids [3, 4, 5, 6, 9, 12, 13, 14, 15, 16, 17] not terminated after 5.0 seconds.
└ @ Distributed /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.5/Distributed/src/cluster.jl:1234
┌ Warning: rmprocs: process 1 not removed
└ @ Distributed /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.5/Distributed/src/cluster.jl:1030
slurmstepd: error: Detected 4 oom-kill event(s) in step 258902.batch cgroup. Some of your processes may have been killed by the cgroup out-of-memory handler.

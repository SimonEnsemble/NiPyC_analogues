[ Info: /nfs/stak/users/gantzlen/DTRA/data
[ Info: /nfs/stak/users/gantzlen/DTRA/structural_relaxation/post-relaxation_cifs
Worker 4 terminated.
ERROR: LoadError: ProcessExitedException(4)
Stacktrace:
 [1] (::Base.var"#770#772")(::Task) at ./asyncmap.jl:178
 [2] foreach(::Base.var"#770#772", ::Array{Any,1}) at ./abstractarray.jl:2009
 [3] maptwice(::Function, ::Channel{Any}, ::Array{Any,1}, ::Array{Float64,1}) at ./asyncmap.jl:178
 [4] wrap_n_exec_twice(::Channel{Any}, ::Array{Any,1}, ::Distributed.var"#206#209"{WorkerPool}, ::Function, ::Array{Float64,1}) at ./asyncmap.jl:154
 [5] async_usemap(::Distributed.var"#190#192"{Distributed.var"#190#191#193"{WorkerPool,PorousMaterials.var"#run_pressure#135"{Int64,Int64,Int64,Bool,Float64,Symbol,Bool,Bool,Int64,Bool,Float64,Nothing,String,Crystal,Molecule{Cart},Float64,LJForceField}}}, ::Array{Float64,1}; ntasks::Function, batch_size::Nothing) at ./asyncmap.jl:103
 [6] #asyncmap#754 at ./asyncmap.jl:81 [inlined]
 [7] pmap(::Function, ::WorkerPool, ::Array{Float64,1}; distributed::Bool, batch_size::Int64, on_error::Nothing, retry_delays::Array{Any,1}, retry_check::Nothing) at /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.5/Distributed/src/pmap.jl:126
 [8] pmap(::Function, ::WorkerPool, ::Array{Float64,1}) at /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.5/Distributed/src/pmap.jl:101
 [9] pmap(::Function, ::Array{Float64,1}; kwargs::Base.Iterators.Pairs{Union{},Union{},Tuple{},NamedTuple{(),Tuple{}}}) at /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.5/Distributed/src/pmap.jl:156
 [10] pmap at /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.5/Distributed/src/pmap.jl:156 [inlined]
 [11] adsorption_isotherm(::Crystal, ::Molecule{Cart}, ::Float64, ::Array{Float64,1}, ::LJForceField; n_burn_cycles::Int64, n_sample_cycles::Int64, sample_frequency::Int64, verbose::Bool, ewald_precision::Float64, eos::Symbol, show_progress_bar::Bool, write_adsorbate_snapshots::Bool, snapshot_frequency::Int64, calculate_density_grid::Bool, density_grid_dx::Float64, density_grid_species::Nothing, results_filename_comment::String) at /nfs/stak/users/gantzlen/.julia/dev/PorousMaterials/src/gcmc.jl:849
 [12] top-level scope at /nfs/stak/users/gantzlen/DTRA/adsorption_isotherm_script.jl:43
 [13] include(::Function, ::Module, ::String) at ./Base.jl:380
 [14] include(::Module, ::String) at ./Base.jl:368
 [15] exec_options(::Base.JLOptions) at ./client.jl:296
 [16] _start() at ./client.jl:506
in expression starting at /nfs/stak/users/gantzlen/DTRA/adsorption_isotherm_script.jl:43
┌ Warning: Forcibly interrupting busy workers
│   exception = rmprocs: pids [3, 5] not terminated after 5.0 seconds.
└ @ Distributed /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.5/Distributed/src/cluster.jl:1234
┌ Warning: rmprocs: process 1 not removed
└ @ Distributed /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.5/Distributed/src/cluster.jl:1030
slurmstepd: error: Detected 1 oom-kill event(s) in step 108058.batch cgroup. Some of your processes may have been killed by the cgroup out-of-memory handler.

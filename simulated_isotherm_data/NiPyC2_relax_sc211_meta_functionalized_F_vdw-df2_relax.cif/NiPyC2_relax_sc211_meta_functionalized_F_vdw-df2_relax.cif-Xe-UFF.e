[ Info: /nfs/stak/users/gantzlen/DTRA/data
[ Info: /nfs/stak/users/gantzlen/DTRA/structural_relaxation/post-relaxation_cifs
Worker 3 terminated.
ERROR: LoadError: ProcessExitedException(3)
Stacktrace:
 [1] (::Base.var"#726#728")(::Task) at ./asyncmap.jl:178
 [2] foreach(::Base.var"#726#728", ::Array{Any,1}) at ./abstractarray.jl:1919
 [3] maptwice(::Function, ::Channel{Any}, ::Array{Any,1}, ::Array{Float64,1}) at ./asyncmap.jl:178
 [4] wrap_n_exec_twice(::Channel{Any}, ::Array{Any,1}, ::Distributed.var"#204#207"{WorkerPool}, ::Function, ::Array{Float64,1}) at ./asyncmap.jl:154
 [5] async_usemap(::Distributed.var"#188#190"{Distributed.var"#188#189#191"{WorkerPool,PorousMaterials.var"#run_pressure#139"{Int64,Int64,Int64,Bool,Float64,Symbol,Bool,Bool,Int64,Bool,Float64,Nothing,String,Crystal,Molecule{Cart},Float64,LJForceField}}}, ::Array{Float64,1}; ntasks::Function, batch_size::Nothing) at ./asyncmap.jl:103
 [6] #asyncmap#710 at ./asyncmap.jl:81 [inlined]
 [7] pmap(::Function, ::WorkerPool, ::Array{Float64,1}; distributed::Bool, batch_size::Int64, on_error::Nothing, retry_delays::Array{Any,1}, retry_check::Nothing) at /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.4/Distributed/src/pmap.jl:126
 [8] pmap(::Function, ::WorkerPool, ::Array{Float64,1}) at /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.4/Distributed/src/pmap.jl:101
 [9] pmap(::Function, ::Array{Float64,1}; kwargs::Base.Iterators.Pairs{Union{},Union{},Tuple{},NamedTuple{(),Tuple{}}}) at /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.4/Distributed/src/pmap.jl:156
 [10] pmap at /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.4/Distributed/src/pmap.jl:156 [inlined]
 [11] adsorption_isotherm(::Crystal, ::Molecule{Cart}, ::Float64, ::Array{Float64,1}, ::LJForceField; n_burn_cycles::Int64, n_sample_cycles::Int64, sample_frequency::Int64, verbose::Bool, ewald_precision::Float64, eos::Symbol, show_progress_bar::Bool, write_adsorbate_snapshots::Bool, snapshot_frequency::Int64, calculate_density_grid::Bool, density_grid_dx::Float64, density_grid_species::Nothing, results_filename_comment::String) at /nfs/stak/users/gantzlen/.julia/dev/PorousMaterials/src/gcmc.jl:849
 [12] top-level scope at /nfs/stak/users/gantzlen/DTRA/adsorption_isotherm_script.jl:45
 [13] include(::Module, ::String) at ./Base.jl:377
 [14] exec_options(::Base.JLOptions) at ./client.jl:288
 [15] _start() at ./client.jl:484
in expression starting at /nfs/stak/users/gantzlen/DTRA/adsorption_isotherm_script.jl:45
slurmstepd: error: Detected 2 oom-kill event(s) in step 50832.batch cgroup. Some of your processes may have been killed by the cgroup out-of-memory handler.

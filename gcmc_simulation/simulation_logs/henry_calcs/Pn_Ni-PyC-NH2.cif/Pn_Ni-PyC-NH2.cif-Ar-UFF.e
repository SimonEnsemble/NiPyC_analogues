┌ Warning: Error requiring `OffsetArrays` from `ArrayInterface`
│   exception =
│    UndefVarError: IdOffsetRange not defined
│    Stacktrace:
│      [1] getproperty(x::Module, f::Symbol)
│        @ Base ./Base.jl:26
│      [2] top-level scope
│        @ ~/.julia/packages/ArrayInterface/FSyre/src/ArrayInterface.jl:919
│      [3] eval
│        @ ./boot.jl:360 [inlined]
│      [4] eval
│        @ ~/.julia/packages/ArrayInterface/FSyre/src/ArrayInterface.jl:1 [inlined]
│      [5] (::ArrayInterface.var"#81#108")()
│        @ ArrayInterface ~/.julia/packages/Requires/7Ncym/src/require.jl:99
│      [6] err(f::Any, listener::Module, modname::String)
│        @ Requires ~/.julia/packages/Requires/7Ncym/src/require.jl:47
│      [7] (::ArrayInterface.var"#80#107")()
│        @ ArrayInterface ~/.julia/packages/Requires/7Ncym/src/require.jl:98
│      [8] withpath(f::Any, path::String)
│        @ Requires ~/.julia/packages/Requires/7Ncym/src/require.jl:37
│      [9] (::ArrayInterface.var"#79#106")()
│        @ ArrayInterface ~/.julia/packages/Requires/7Ncym/src/require.jl:97
│     [10] #invokelatest#2
│        @ ./essentials.jl:708 [inlined]
│     [11] invokelatest
│        @ ./essentials.jl:706 [inlined]
│     [12] foreach(f::typeof(Base.invokelatest), itr::Vector{Function})
│        @ Base ./abstractarray.jl:2141
│     [13] loadpkg(pkg::Base.PkgId)
│        @ Requires ~/.julia/packages/Requires/7Ncym/src/require.jl:27
│     [14] #invokelatest#2
│        @ ./essentials.jl:708 [inlined]
│     [15] invokelatest
│        @ ./essentials.jl:706 [inlined]
│     [16] _tryrequire_from_serialized(modkey::Base.PkgId, build_id::UInt64, modpath::String)
│        @ Base ./loading.jl:693
│     [17] _require_search_from_serialized(pkg::Base.PkgId, sourcepath::String)
│        @ Base ./loading.jl:749
│     [18] _require(pkg::Base.PkgId)
│        @ Base ./loading.jl:998
│     [19] require(uuidkey::Base.PkgId)
│        @ Base ./loading.jl:914
│     [20] (::Distributed.var"#1#2"{Base.PkgId})()
│        @ Distributed /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.6/Distributed/src/Distributed.jl:79
│     [21] (::Distributed.var"#103#104"{Distributed.CallMsg{:call}})()
│        @ Distributed /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.6/Distributed/src/process_messages.jl:274
│     [22] run_work_thunk(thunk::Distributed.var"#103#104"{Distributed.CallMsg{:call}}, print_error::Bool)
│        @ Distributed /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.6/Distributed/src/process_messages.jl:63
│     [23] run_work_thunk(rv::Distributed.RemoteValue, thunk::Function)
│        @ Distributed /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.6/Distributed/src/process_messages.jl:72
│     [24] (::Distributed.var"#96#98"{Distributed.RemoteValue, Distributed.var"#103#104"{Distributed.CallMsg{:call}}})()
│        @ Distributed ./task.jl:411
└ @ Requires ~/.julia/packages/Requires/7Ncym/src/require.jl:49
┌ Warning: crystals path directory not found
│   path = "/nfs/stak/users/gantzlen/DTRA/gcmc_simulation/data/crystals"
└ @ Xtals ~/.julia/dev/Xtals/src/misc.jl:181
┌ Warning: data path directory not found
│   path = "/nfs/stak/users/gantzlen/DTRA/gcmc_simulation/data"
└ @ Xtals ~/.julia/dev/Xtals/src/misc.jl:181
┌ Warning: forcefields path directory not found
│   path = "/nfs/stak/users/gantzlen/DTRA/gcmc_simulation/data/forcefields"
└ @ Xtals ~/.julia/dev/Xtals/src/misc.jl:181
┌ Warning: grids path directory not found
│   path = "/nfs/stak/users/gantzlen/DTRA/gcmc_simulation/data/grids"
└ @ Xtals ~/.julia/dev/Xtals/src/misc.jl:181
┌ Warning: molecules path directory not found
│   path = "/nfs/stak/users/gantzlen/DTRA/gcmc_simulation/data/molecules"
└ @ Xtals ~/.julia/dev/Xtals/src/misc.jl:181
┌ Warning: crystals path directory not found
│   path = "/nfs/stak/users/gantzlen/DTRA/gcmc_simulation/data/crystals"
└ @ Xtals ~/.julia/dev/Xtals/src/misc.jl:181
┌ Warning: data path directory not found
│   path = "/nfs/stak/users/gantzlen/DTRA/gcmc_simulation/data"
└ @ Xtals ~/.julia/dev/Xtals/src/misc.jl:181
┌ Warning: simulations path directory not found
│   path = "/nfs/stak/users/gantzlen/DTRA/gcmc_simulation/data/simulations"
└ @ Xtals ~/.julia/dev/Xtals/src/misc.jl:181
┌ Warning: Error requiring `OffsetArrays` from `ArrayInterface`
│   exception =
│    UndefVarError: IdOffsetRange not defined
│    Stacktrace:
│      [1] getproperty(x::Module, f::Symbol)
│        @ Base ./Base.jl:26
│      [2] top-level scope
│        @ ~/.julia/packages/ArrayInterface/FSyre/src/ArrayInterface.jl:919
│      [3] eval
│        @ ./boot.jl:360 [inlined]
│      [4] eval
│        @ ~/.julia/packages/ArrayInterface/FSyre/src/ArrayInterface.jl:1 [inlined]
│      [5] (::ArrayInterface.var"#81#108")()
│        @ ArrayInterface ~/.julia/packages/Requires/7Ncym/src/require.jl:99
│      [6] err(f::Any, listener::Module, modname::String)
│        @ Requires ~/.julia/packages/Requires/7Ncym/src/require.jl:47
│      [7] (::ArrayInterface.var"#80#107")()
│        @ ArrayInterface ~/.julia/packages/Requires/7Ncym/src/require.jl:98
│      [8] withpath(f::Any, path::String)
│        @ Requires ~/.julia/packages/Requires/7Ncym/src/require.jl:37
│      [9] (::ArrayInterface.var"#79#106")()
│        @ ArrayInterface ~/.julia/packages/Requires/7Ncym/src/require.jl:97
│     [10] #invokelatest#2
│        @ ./essentials.jl:708 [inlined]
│     [11] invokelatest
│        @ ./essentials.jl:706 [inlined]
│     [12] foreach(f::typeof(Base.invokelatest), itr::Vector{Function})
│        @ Base ./abstractarray.jl:2141
│     [13] loadpkg(pkg::Base.PkgId)
│        @ Requires ~/.julia/packages/Requires/7Ncym/src/require.jl:27
│     [14] #invokelatest#2
│        @ ./essentials.jl:708 [inlined]
│     [15] invokelatest
│        @ ./essentials.jl:706 [inlined]
│     [16] _tryrequire_from_serialized(modkey::Base.PkgId, build_id::UInt64, modpath::String)
│        @ Base ./loading.jl:693
│     [17] _require_search_from_serialized(pkg::Base.PkgId, sourcepath::String)
│        @ Base ./loading.jl:749
│     [18] _require(pkg::Base.PkgId)
│        @ Base ./loading.jl:998
│     [19] require(uuidkey::Base.PkgId)
│        @ Base ./loading.jl:914
│     [20] require(into::Module, mod::Symbol)
│        @ Base ./loading.jl:901
│     [21] include(mod::Module, _path::String)
│        @ Base ./Base.jl:386
│     [22] exec_options(opts::Base.JLOptions)
│        @ Base ./client.jl:285
│     [23] _start()
│        @ Base ./client.jl:485
└ @ Requires ~/.julia/packages/Requires/7Ncym/src/require.jl:49
┌ Warning: crystals path directory not found
│   path = "/nfs/stak/users/gantzlen/DTRA/gcmc_simulation/data/crystals"
└ @ Xtals ~/.julia/dev/Xtals/src/misc.jl:181
┌ Warning: data path directory not found
│   path = "/nfs/stak/users/gantzlen/DTRA/gcmc_simulation/data"
└ @ Xtals ~/.julia/dev/Xtals/src/misc.jl:181
┌ Warning: forcefields path directory not found
│   path = "/nfs/stak/users/gantzlen/DTRA/gcmc_simulation/data/forcefields"
└ @ Xtals ~/.julia/dev/Xtals/src/misc.jl:181
┌ Warning: grids path directory not found
│   path = "/nfs/stak/users/gantzlen/DTRA/gcmc_simulation/data/grids"
└ @ Xtals ~/.julia/dev/Xtals/src/misc.jl:181
┌ Warning: molecules path directory not found
│   path = "/nfs/stak/users/gantzlen/DTRA/gcmc_simulation/data/molecules"
└ @ Xtals ~/.julia/dev/Xtals/src/misc.jl:181
┌ Warning: crystals path directory not found
│   path = "/nfs/stak/users/gantzlen/DTRA/gcmc_simulation/data/crystals"
└ @ Xtals ~/.julia/dev/Xtals/src/misc.jl:181
┌ Warning: data path directory not found
│   path = "/nfs/stak/users/gantzlen/DTRA/gcmc_simulation/data"
└ @ Xtals ~/.julia/dev/Xtals/src/misc.jl:181
┌ Warning: simulations path directory not found
│   path = "/nfs/stak/users/gantzlen/DTRA/gcmc_simulation/data/simulations"
└ @ Xtals ~/.julia/dev/Xtals/src/misc.jl:181
[ Info: Dict(:forcefields => "/nfs/stak/users/gantzlen/DTRA/data/forcefields", :grids => "/nfs/stak/users/gantzlen/DTRA/data/grids", :molecules => "/nfs/stak/users/gantzlen/DTRA/data/molecules", :crystals => "/nfs/stak/users/gantzlen/DTRA/data/crystals", :data => "/nfs/stak/users/gantzlen/DTRA/data", :simulations => "/nfs/stak/users/gantzlen/DTRA/data/simulations")
┌ Info: Crystal Pn_Ni-PyC-NH2.cif has Pn space group. I am converting it to P1 symmetry.
└         To prevent this, pass `convert_to_p1=false` to the `Crystal` constructor.

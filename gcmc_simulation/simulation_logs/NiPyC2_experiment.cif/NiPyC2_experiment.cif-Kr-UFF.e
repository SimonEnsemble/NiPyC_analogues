┌ Error: Exception while generating log record in module Main at /nfs/stak/users/gantzlen/DTRA/adsorption_isotherm_script.jl:12
│   exception =
│    UndefVarError: PATH_TO_CRYSTALS not defined
│    Stacktrace:
│     [1] getproperty(x::Module, f::Symbol)
│       @ Base ./Base.jl:26
│     [2] top-level scope
│       @ logging.jl:340
│     [3] include(mod::Module, _path::String)
│       @ Base ./Base.jl:386
│     [4] exec_options(opts::Base.JLOptions)
│       @ Base ./client.jl:285
│     [5] _start()
│       @ Base ./client.jl:485
└ @ Main ~/DTRA/adsorption_isotherm_script.jl:12
┌ Info: Crystal NiPyC2_experiment.cif has Pn space group. I am converting it to P1 symmetry.
└         To prevent this, pass `convert_to_p1=false` to the `Crystal` constructor.
┌ Warning: density grid being calculated over a 2x2x2 cell for plotting convenience
└ @ Main ~/DTRA/adsorption_isotherm_script.jl:52

This directory contains the input scripts for the QuantumESPRESSO v6.5 (QE) DFT calculations. Input file nameing convention is as follows:
`pw.parent-structure_substitution-position_functional-group_density-functional_calculation-type.in`

The subdirectory `./benchmarks` contains the input and output files of QE simulations used to tune the convergence criteria of DFT calculations during initial tests.

The subdirectory `./example_files` contains input and output files used as a reference when performig the initial configuration of QE and generation of input scripts. 

The subdirectory `./frozen_parent_atoms` contains the QE input files for structures where the atoms of the parent MOF are held fixed during the calculation whiie the atoms of the functional group are allowed to relax. You can identify atoms being held fixed in the input script as those in the `ATOMIC_POSITIONS {crystal}` card with a `0 0 0` force multiplier. This "freezes" those atoms in place during the calculation.


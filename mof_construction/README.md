


Directories for the functionalized mofs are names as follows:
`parent-MOF_replication-factors_QE-calculation-type`
crystal structures that have not been replicated will not have a "replication" section in the file name.

The MOF whose parameters are experimentally will say "experiment" in the QE section. "relax" refers to fixed lattice constants during structural relaxation and "vc-relax" is variable cell relaxation (i.e. specified parameters may change).

Example: `NiPyC2_relax_sc211` contains `.cif`,`.xyz`, and `.vtk` files for functionalized versions of the NiPyC2 which has been relaxed via DFT calculations then replicated with replication factors (2, 1, 1).

**NOTE:** `.cif` files under this directory are only functionalized versions of the QE relaxed parent MOF and have not been run through DFT-based geometry optimization themselves.



Subdirectories and files:
component_frameworks
fragments
functonal_linkers
MOF_Functionalizer_Module.ipynb
NiPyC2_relax_sc211
NiPyC2_relax_sc211.cif
separate_frameworks.jl

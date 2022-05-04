This directory contains the `.cif` files of both experimental and predicted MOFs used in the study.

## Experimental structures
`NiPyC2.cif` # obtained from: https://doi.org/10.1021/jacs.6b10455
`NiPyC2_experiment.cif` # copy of `NiPyC2.cif` with solvent manually removed

#### possible topologies of Ni(PyC-m-NH2)2 
`P21-n_Ni-PyC-NH2.cif` # trans config of PyC ligand
`Pn_Ni-PyC-NH2.cif`    # cis config of PyC ligand (same as parent MOF)

#### MOF used as compeatative benchmark 
`SBMOF-1.cif` # obtained from: 

`NiPyC2_P1_pbesol_vc-relax.cif`    # Ni(PyC)2 converted to P1 symmetry then used in benchmarking vc-relax DFT structure prediction
`NiPyC2_pbesol-angle-vc-relax.cif` # used in benchmarking vc-relax DFT structure prediction

## DFT predicted structures
NiPyC2_relax.cif       # DFT-based geometry optimized Ni(PyC)2 using pbesol density functional and relaxation with constant lattice parameters.
NiPyC2_relax_sc211.cif # 2x1x1 supercell of the `NiPyC2_relax.cif` which is used to generate library of crystal structure models.

### Note:
**The following structures are COPPIES of their origional in the structure optimization directory and are only here for the convenience of file path manipulation when running analysis/ making plots.**
NiPyC2_relax_sc211_meta_functionalized_CH3_pbesol_relax.cif
NiPyC2_relax_sc211_meta_functionalized_N-C-O_pbesol_relax.cif
NiPyC2_relax_sc211_meta_functionalized_NH2_pbesol_relax.cif

NiPyC2_vc-relax.cif
NiPyC2_vdw-df2_relax.cif
NiPyC2_vdw-df2_vc-relax.cif

**This is a COPY of the file located in the MOF construction directory and is only here for the convenience of file path manipulation when running analysis/ making plots.**
NiPyC2_relax_sc211_meta_functionalized_CH3.cif
NiPyC2_relax_sc211_meta_functionalized_NH2_pbesol_relax_comp1.cif


As promised, here are the files to make the experimental density maps for the gas adsorption. To make the map, you need to import two files into VESTA: 1. the .cif file is the structure file of the empty framework, and 2. the .fcf file, which has difference between experimental and simulated structure factors (this carries the information of where the density is with respect to the structure file). If you want to know a bit more about how this information is obtained from the refinements, I am happy to chat and explain.

In the compressed folder are these two files for a variety of cases, e.g.:
- Kr and Xe loading at different pressures in Ni-PyC-NH2, (100, 500, 1000, 1700 milibar)
- Xe loading in Ni-PyC at 1000 milibar, and,
- Xe loading in both structures from the synchrotron measurements ( I don't know what the pressure is for these measurements)

# Instructions to make the hypersurface images in VESTA:
------------------------------------------------------------
1. File --> Open --> *_empty.cif
2. Choose axis to view along [a], [b], or [c]
3. You can expand the structure using Objects --> Boundary --> Ranges of fractional coordinates
4. Utilities --> Fourier Synthesis --> Import .fcf file
5. Calculate Fo-Fc with F_000 = 0

To Edit Hypersurface:
1. Objects --> Properties --> Isosurfaces

To draw a cross-sectional slice through the structure:
1. Edit --> Lattice Planes --> Add lattice plane
2. Objects --> Properties --> Isosurfaces --> click on and delete isosurface
3. Objects --> Properties --> Sections -->
------------------------------------------------------------



axis => c == z, b == x, a == y

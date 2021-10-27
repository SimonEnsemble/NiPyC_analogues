Here are the files to make the experimental density maps for the gas adsorption. 
To make the map, you need to import two files into VESTA: 
	1. the .cif file is the structure file of the empty framework, and 
	2. the .fcf file, which has difference between experimental and simulated structure factors (this carries the information of where the density is with respect to the structure file). 

In the compressed folder are these two files for a variety of cases, e.g.:
- Kr and Xe loading at different pressures in Ni-PyC-NH2, (100, 500, 1000, 1700 milibar)
- Xe loading in Ni-PyC at 1000 milibar, and,
- Xe loading in both structures from the synchrotron measurements (unknown: what the pressure is for these measurements)

## Instructions to make the hypersurface images in VESTA:
--------------------------------------------------------------------
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
--------------------------------------------------------------------


### Commentary:
--------------------------------------------------------------------
1. The measured diffraction intensities basically tell us how much electron density sits on sets of planes with a spacing given by the diffraction momentum transfer (2*pi/Q). However, we do not necessarily know where the electron density on those planes are with respect to densities on other planes (the so-called phase problem). The way the Fourier difference map works is that we use the 'empty pore' framework structure as a reference for the phase information. This allows us, as you said, to see where electron density is missing with respect to the density of the structure model, based on the discrepancies of the diffraction intensities between experiment and simulation from empty model.

In theory, negative intensities in the map tell you where the electron density in your model is overpredicted, i.e. you might see negative intensities if you had <100% occupancy of atoms on a certain site in the real material, versus the model, or if there was a modification in the site position due to adsorption that is not included in the model.

In practice, we extract the best possible Fourier map by fitting the model to the data including some "electron density" to account for the pore content, and then calculate the Fourier map by referencing the empty part of the framework after refinement. Unfortunately, a perfect extraction would rely on us finding the exact distribution of missing density, which is probably not satisfied. Also, we never get a perfect fit. Therefore, the 'negative intensities' may also reflect some errors in the fit, that may or may not reflect real structural effects, but we cannot be totally sure.

2. Yes, the .fcf files give the relative changes in the diffraction intensities for each pressure. I observed that the magnitude of the missing intensity increases with increasing pressure, i.e. more gas is adsorbed. I calculated how much gas is in the pore as a function of pressure from the amount of missing electrons -- see SI Figure S33 (you can compare this for instance to the figure with the number of adsorbates in the paper).  I did not see a major change in the shape of the distribution as a function of pressure or gas composition. However, it can still be nice to show the changes in the maps for different pressures or for Xe versus Kr, if there is space in the figure.


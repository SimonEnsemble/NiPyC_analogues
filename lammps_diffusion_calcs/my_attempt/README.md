I created these scripts using the lammps-interface command.
I don't remember the exact command sequence, but I know that I had to set nvt to true.
I'll see if I can reproduce it by checking the docs.

lammps-interface --outputcif --nvt true --cutoff 14.0 --xyz 10000 path-to-xtal.cif 

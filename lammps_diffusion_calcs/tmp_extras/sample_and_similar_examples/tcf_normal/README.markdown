### TCF ###

Program to study time-correlation functions. 

We focus first on Mean-Squared Displacement functions.

# Dump center of mass for the particles.

Using lammps we can dump the center of mass position for the particles using the following command:

"fix # molecule ave/time 1 1 100 f_1[1] f_1[2] f_1[3] f_1[13] f_1[14] f_1[15] file outputfile.com mode vector"

where the data in column 13, 14, and 15 allows us to put the particles in their real position.


# we need to change the sampling for vacf. This can be done even if dt == 0

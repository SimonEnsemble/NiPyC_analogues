A sample command to generate the LAMMPS input using lammps-interface in order to do minimization is:
lammps-interface -o --minimize --replication 1x1x1 --xyz 20000 --lammpstrj 20000 --restart xtal_name.cif

The possible command line options can be found by running lammps-interface --help
Read LAMMPS dump files: https://lammps.sandia.gov/doc/read_dump.html
Convert LAMMPS box to f_to_c: https://lammps.sandia.gov/threads/msg10124.html

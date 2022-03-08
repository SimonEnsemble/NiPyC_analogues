#ifndef READINPUT_H
#define READINPUT_H

/* Read and store all input-data to calculate a correlation function
 */

// the different types of files we have
enum {NONE,COM,COW,COMW};


typedef struct
{
  int CorrectDrift;       // if we correct for drift, we have to calculate the center of mass for the whole system. this should be zero.
  int SaveIndividual;      // calculate the msd for individual particles. this can be really time and memory consuming. Will also produce many output-files
  int SavePositions;       // calculate collective diffusion. if more than one comp, we must define the mass, this has to be done using a input-file
  int SaveCollective;      // sample msd, require positions
  int SaveVelocity;        // sample vacf, requires velocities
} SWITCHES;

typedef struct
{
  size_t MaxBlocks;
  size_t MaxElements;
  size_t ParticleTypes;
  size_t *NumberOfParticles;
  double *Mass;
  double Timestep;
  double SampleTimestep;
} PARAMS;


typedef struct
{
  // Array of file-types. We open the files already while reading in the data. No point in storing the file-name.
  FILE **FileHandles;
  // File types. Necessary for reading the trajectory file.
  int *FileType;
  // Times between steps that are sampled.
  int *StepsBetweenSamples;
  // the timestep. In [ps]
  double Timestep;
  // box dimentions
  double xlo;
  double xhi;
  double ylo;
  double yhi;
  double zlo;
  double zhi;
  // the tilt factors
  double xy;
  double xz;
  double yz; 
  // define the box-matrix. if orthogonal, box-lengths are just the diagonal. otherwise, we use the upper triangle
  double box[3][3];
  // here we set some logical switches. 
  SWITCHES *Switch;
  PARAMS *CorrParam;
} INPUT_DATA;


INPUT_DATA *ReadInput(int, int, double, char *);
void ReleaseInput(INPUT_DATA *);

#endif

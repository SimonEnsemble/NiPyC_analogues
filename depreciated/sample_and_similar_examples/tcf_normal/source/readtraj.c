
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <limits.h>


#include "readinput.h"
#include "readtraj.h"
#include "utils.h"
#include "readinput.h"


/*
 * This function reads the first two snapshots. This will give us: 
 *  -the number of steps between everytime a snapshot is taken
 *  -the number of atoms of this type.
 *
 * The first snapshot is stored in the appropriate arrays, to make the
 * sampling correct.
 *
 */
void GetSnapshotData(INPUT_DATA *Input)
{
  int MaxLineLength=2048;
  char line[MaxLineLength];
  size_t chars_read;
  int dummy_int;
  int dummy_int2;
  int this_snap;

  printf("Getting additional information from the input-files ...");

  for (size_t comp=0;comp<Input->CorrParam->ParticleTypes;comp++)
  {
    if((Input->FileType[comp]==COM)||(Input->FileType[comp]==COW)||(Input->FileType[comp]==COMW))
    {
      // read com or comw file
      // first, read the three first lines, and 
      // discard them, these contain random information
      for (size_t i=0;i<3;i++) 
      {
        chars_read = ReadNewLine(line,MaxLineLength,Input->FileHandles[comp]);
        if(chars_read == 0) 
        {
          printf("\nFound premature EOF trying to read header of first file\n");
          exit(1);
        }
      }

      // now we have the actual file, let's see if we can do something
      chars_read = ReadNewLine(line,MaxLineLength,Input->FileHandles[comp]);
      if(chars_read == 0) 
      {
        printf("\nFound premature EOF while reading first snapshot\n");
        exit(1);
      }
      sscanf(line,"%i%i",&dummy_int,&dummy_int2);

      if(dummy_int2<1)
      {
        printf("\nWe tried to read the number header of a snapshot to find number of particles.\n");
        printf("There seems to be zero particles in this system.\n");
        exit(1);
      }
      
      this_snap = dummy_int;
      Input->CorrParam->NumberOfParticles[comp] = dummy_int2;

      // then, read in all the particles.
      for (size_t part=0;part<Input->CorrParam->NumberOfParticles[comp];part++)
      {
        chars_read = ReadNewLine(line,MaxLineLength,Input->FileHandles[comp]);
        if(chars_read == 0) 
        {
          printf("\nFound premature EOF while reading first snapshot\n");
          exit(1);
        }
      }

      // try to read in the next header.
      chars_read = ReadNewLine(line,MaxLineLength,Input->FileHandles[comp]);
      if(chars_read == 0) 
      {
        printf("\nFound premature EOF while reading first snapshot\n");
        exit(1);
      }
      sscanf(line,"%i%i",&dummy_int,&dummy_int2);

      // if the number of particles have changed, we exit. we cannot deal with that.
      if(Input->CorrParam->NumberOfParticles[comp] != (size_t)dummy_int2)
      {
        printf("\nThe number of particles changed between snapshots\n");
        exit(1);
      }

      if((dummy_int - this_snap)<1)
      {
        printf("\nSomething wrong with the snapshot-distance. Are the snapshots obtained\n");
        printf("in the right direction in time?\n");
        exit(1);

      }

      Input->StepsBetweenSamples[comp] = (size_t)(dummy_int - this_snap);

      // the, rewind the snapshot, and read the three first lines again. 
      rewind(Input->FileHandles[comp]);
      for (size_t i=0;i<3;i++) 
      {
        chars_read = ReadNewLine(line,MaxLineLength,Input->FileHandles[comp]);
        if(chars_read == 0) 
        {
          printf("\nFound premature EOF trying to read header of first file\n");
          exit(1);
        }
      }
      // now we should be ready for reading the first snapshot.
    }
    else
    {
      printf("\nWe found a strange filetype. Check that this is correct.\n");
      exit(1);
    }
  } 

  printf(" done \n\n");
        
  for (size_t comp=0;comp<Input->CorrParam->ParticleTypes;comp++)
  {
    printf("\t Component %zu has a total of %zu particles and %i steps between each sample.\n",
        (comp+1),
        Input->CorrParam->NumberOfParticles[comp],
        Input->StepsBetweenSamples[comp]
        );
  }

  Input->CorrParam->SampleTimestep = Input->StepsBetweenSamples[0] * Input->CorrParam->Timestep;
  printf("\t This set of data has a timestep of %g [ps] between every time a sample is writen to file.\n\n",
      Input->CorrParam->SampleTimestep);


  // print the blocks. 
  for(size_t i=0;i<Input->CorrParam->MaxBlocks;i++)
  {
    double inf = Input->CorrParam->SampleTimestep * pow((double)Input->CorrParam->MaxElements,i);
    double sup = inf * Input->CorrParam->MaxElements;
    printf("\t Block %3zu: Start  %20.4f -- %20.4f [ps]\n",(i+1),inf,sup);
  }
  printf("\n");
}

/* 
 * Allocate snapshot memory. This will be arrays containing the
 * com-possition for molecules, as well as the com possition for 
 * types of molecules.
 */

SNAPSHOT *AllocateSnapshotMemory(INPUT_DATA *Input)
{

  SNAPSHOT *Snap = NULL;

  Snap = (SNAPSHOT *) calloc(1,sizeof(SNAPSHOT));

  size_t ParticleTypes = Input->CorrParam->ParticleTypes;
  size_t *NumberOfParticles = Input->CorrParam->NumberOfParticles;
  
  Snap->Switch = Input->Switch;
  Snap->CorrParam = Input->CorrParam;
  
  printf("\t Reserving memory for snapshots ...");

  if(Snap->Switch->SavePositions)
  {
    Snap->PosX = (double**)calloc(ParticleTypes,sizeof(double*));
    Snap->PosY = (double**)calloc(ParticleTypes,sizeof(double*));
    Snap->PosZ = (double**)calloc(ParticleTypes,sizeof(double*));

    for(size_t i=0;i<ParticleTypes;i++)
    {
      Snap->PosX[i] = (double*)calloc(NumberOfParticles[i],sizeof(double));
      Snap->PosY[i] = (double*)calloc(NumberOfParticles[i],sizeof(double));
      Snap->PosZ[i] = (double*)calloc(NumberOfParticles[i],sizeof(double));
    }
  }
  
  if(Snap->Switch->SaveVelocity)
  {
    Snap->VelocityX = (double**)calloc(ParticleTypes,sizeof(double*));
    Snap->VelocityY = (double**)calloc(ParticleTypes,sizeof(double*));
    Snap->VelocityZ = (double**)calloc(ParticleTypes,sizeof(double*));

    for(size_t i=0;i<ParticleTypes;i++)
    {
      Snap->VelocityX[i] = (double*)calloc(NumberOfParticles[i],sizeof(double));
      Snap->VelocityY[i] = (double*)calloc(NumberOfParticles[i],sizeof(double));
      Snap->VelocityZ[i] = (double*)calloc(NumberOfParticles[i],sizeof(double));
    }
  }

  Snap->CentreOfMassX = (double*)calloc(ParticleTypes,sizeof(double));
  Snap->CentreOfMassY = (double*)calloc(ParticleTypes,sizeof(double));
  Snap->CentreOfMassZ = (double*)calloc(ParticleTypes,sizeof(double));

  printf(" done\n");

  return Snap;
}


/*
 * Read a snapshot.
 * This can contain both positons, velocities, and the center of mass for a group of 
 * particles. How the reading is done varies a bit depending on the type of particle
 * we are looking at, and what data we want.
 *
 */

int ReadSnap(INPUT_DATA *Input, SNAPSHOT *Snap)
{
  
  int MaxLineLength=2048;
  char line[MaxLineLength];
  int int_step,atoms;


  // iterate over all the particle types we have (implicitly the number of files)
  for (size_t comp=0;comp<Input->CorrParam->ParticleTypes;comp++)
  {
    size_t chars_read;
  
    // If we set the switch SaveCollective, we need the center of mass of a component
    // Here we reset this for counting.
    if(Input->Switch->SaveCollective)
    {
      Snap->CentreOfMassX[comp] = 0.0;
      Snap->CentreOfMassY[comp] = 0.0;
      Snap->CentreOfMassZ[comp] = 0.0;
    }

    if(Input->FileType[comp]==COM)
    {
      /* this filetype has only stored the center of mass of each molecule, as well as the times it has crossed 
       * the periodic boundaries. 
       */
      
      // if we are not sampling msd, why do this at all?
      if((Input->Switch->SavePositions==0)&&(Input->Switch->SaveCollective==0))
      {
        printf("Why read a file with positions and not calculate MSD?\n");
        exit(1);
      }

      chars_read = ReadNewLine(line,MaxLineLength,Input->FileHandles[comp]);
      
      if(chars_read == 0) return 0;   // we have reached the end of the file.

      // Read the header. If we have unexpeded number of atoms, we quit.
      sscanf(line,"%i%i",&int_step,&atoms);
      if((size_t)atoms!=Input->CorrParam->NumberOfParticles[comp])
      {
        printf("The number of particles in this simulation has changed\n");
        printf("We are not prepared for that.\n");
        exit(1);
      }

      // here we read the actual snapshot
      for (size_t part=0;part<Input->CorrParam->NumberOfParticles[comp];part++)
      {
        double rx,ry,rz;
        int lx,ly,lz;
        int dummy;

        chars_read = ReadNewLine(line,MaxLineLength,Input->FileHandles[comp]);

        if (chars_read == 0) return 0;

        sscanf(line,"%i%lf%lf%lf%i%i%i",&dummy,&rx,&ry,&rz,&lx,&ly,&lz);
      
        // fixme: here we have to take into account the triclinic cell. 
        //rx += (double)lx * Input->box[0][0]; 
        //ry += (double)ly * Input->box[1][1]; 
        //rz += (double)lz * Input->box[2][2]; 
        
        rx += (double)lx * Input->box[0][0] + (double)ly * Input->box[0][1] + (double)lz * Input->box[0][2];
        ry += (double)ly * Input->box[1][1] + (double)lz * Input->box[1][2];
        rz += (double)lz * Input->box[2][2];
        
        Snap->PosX[comp][part] = rx;
        Snap->PosY[comp][part] = ry;
        Snap->PosZ[comp][part] = rz;

        if(Input->Switch->SaveCollective)
        {
          Snap->CentreOfMassX[comp] += rx;
          Snap->CentreOfMassY[comp] += ry;
          Snap->CentreOfMassZ[comp] += rz;
        }
      }

      // find the actual center of mass
      if(Input->Switch->SaveCollective)
      {
        Snap->CentreOfMassX[comp] /= Snap->CorrParam->NumberOfParticles[comp];
        Snap->CentreOfMassY[comp] /= Snap->CorrParam->NumberOfParticles[comp];
        Snap->CentreOfMassZ[comp] /= Snap->CorrParam->NumberOfParticles[comp];
      }
    }
    else if(Input->FileType[comp]==COW)
    {
      printf("We cannot do this filetype yet. (COW)\n");
      exit(1);
    }
    else if(Input->FileType[comp]==COMW)
    {
      printf("We cannot do this filetype yet. (COMW)\n");
      exit(1);
    }
    else 
    {
      printf("Not specified filetype reading snapshot.\n");
      exit(1);
    }
  } // loop over all components

  return 1;

}



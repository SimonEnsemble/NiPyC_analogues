
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <math.h>
#include <stdbool.h>

#include "readinput.h"
#include "utils.h"

void ReleaseInput(INPUT_DATA *Input)
{

  printf("\t Releasing input-data ...");

  // close the files 
  for(size_t i=0;i<Input->CorrParam->ParticleTypes;i++)
    fclose(Input->FileHandles[i]);

  free(Input->FileHandles);
  free(Input->FileType);
  free(Input->StepsBetweenSamples);

  free(Input->Switch);

  free(Input->CorrParam->NumberOfParticles);
  free(Input->CorrParam->Mass);
  free(Input->CorrParam);
  free(Input);


  printf(" done \n");
}


INPUT_DATA *ReadInput(int Blocks, int Elements, double tstep, char *Fname)
{
  FILE *fileptr=NULL;
  int MaxLineLength=2048;
  char line[MaxLineLength];
  int dummy_int;

  INPUT_DATA *Input = (INPUT_DATA *) calloc(1,sizeof(INPUT_DATA));

  // Allocate memory to switches, and set them
  Input->Switch = (SWITCHES *)calloc(1,sizeof(SWITCHES));
  Input->Switch->CorrectDrift = 0;
  Input->Switch->SaveIndividual = 0;
  Input->Switch->SaveCollective = 1;
  Input->Switch->SavePositions = 1;
  Input->Switch->SaveVelocity = 0;

  // Allocate memory to the correlation parameters
  Input->CorrParam = (PARAMS *)calloc(1,sizeof(PARAMS));

  // check the timestep
  if(tstep>0.0)
  {
    Input->CorrParam->Timestep = tstep;
    Input->CorrParam->SampleTimestep = 0.0;   // the distance between timesteps. must check the step-length
  }
  else
  {
    printf("We cannot use nagative timesteps.\n");
    exit(1);
  }

  if(Blocks>0) Input->CorrParam->MaxBlocks = (size_t)Blocks;
  else 
  {
    printf("We cannot use negative blocks.\n");
    exit(1);
  }
  
  if(Elements>0) Input->CorrParam->MaxElements = (size_t)Elements;
  else 
  {
    printf("We cannot use negative elements.\n");
    exit(1);
  }


  if(strcmp(Fname,"empty") == 0)
  {
    printf("No input-file specified\n");
    printf("Cannot do anything\n");
    exit(1);
  }


  if(!(fileptr=fopen(Fname,"r")))
  {
    printf("ReadInput: Input-file not opened correctly.\n");
    printf("Tried to open file: '%s'.\n",Fname);
    exit(1);
  }
  
  // parse input-file   
  ReadNewLine(line,MaxLineLength,fileptr);

  // now, read the box.
  ReadNewLine(line,MaxLineLength,fileptr);
  sscanf(line,"%lf%lf",&Input->xlo,&Input->xhi);
  
  ReadNewLine(line,MaxLineLength,fileptr);
  sscanf(line,"%lf%lf",&Input->ylo,&Input->yhi);
  
  ReadNewLine(line,MaxLineLength,fileptr);
  sscanf(line,"%lf%lf",&Input->zlo,&Input->zhi);

  // read the triclinic parameters
  ReadNewLine(line,MaxLineLength,fileptr);    // empty line
  ReadNewLine(line,MaxLineLength,fileptr);
  sscanf(line,"%lf%lf%lf",&Input->xy,&Input->xz,&Input->yz);

  // Put this into the box-matrix
  Input->box[0][0] = Input->xhi - Input->xlo;
  Input->box[1][0] = 0.0;
  Input->box[2][0] = 0.0;

  Input->box[0][1] = Input->xy;
  Input->box[1][1] = Input->yhi - Input->ylo;
  Input->box[2][1] = 0.0;

  Input->box[0][2] = Input->xz;
  Input->box[1][2] = Input->yz;
  Input->box[2][2] = Input->zhi - Input->zlo;


  // Print back the box-matrix:
  
  printf("\n\t We are working with the following box:\n");
  for (size_t i=0;i<3;i++)
  {
    for (size_t j=0;j<3;j++) printf("\t %g ",Input->box[i][j]);
    printf("\n");
  }

  printf("\n");

  // read the switches
  ReadNewLine(line,MaxLineLength,fileptr);
  ReadNewLine(line,MaxLineLength,fileptr);
  sscanf(line,"%i%i%i%i%i",
      &Input->Switch->CorrectDrift,
      &Input->Switch->SaveIndividual,
      &Input->Switch->SaveCollective,
      &Input->Switch->SavePositions,
      &Input->Switch->SaveVelocity
      );


  printf("\n\t We have the following configuration:\n");

  printf("Correcting for drift:                 ");
  if(Input->Switch->CorrectDrift) printf("YES \n");
  else printf("NO \n");
  
  printf("Print individual particles:           ");
  if(Input->Switch->SaveIndividual) printf("YES \n");
  else printf("NO \n");
  
  printf("Calculate collective diffusion:       ");
  if(Input->Switch->SaveCollective) printf("YES \n");
  else printf("NO \n");

  printf("Calculate self diffusion:             ");
  if(Input->Switch->SavePositions) printf("YES \n");
  else printf("NO \n");

  printf("Calculate VACF:                       ");
  if(Input->Switch->SaveVelocity) printf("YES \n");
  else printf("NO \n");

  // read the number of components
  ReadNewLine(line,MaxLineLength,fileptr);  // empty line
  ReadNewLine(line,MaxLineLength,fileptr);
  sscanf(line,"%i",&dummy_int);

  if(dummy_int <= 0)
  {
    printf("We cannot have zero or negative number of components. Break ... \n");
  }
  else
  {
    Input->CorrParam->ParticleTypes = (size_t)dummy_int;
    printf("The number of particel types:         %zu\n\n",Input->CorrParam->ParticleTypes);
  }

  // then we can allocate some memory.
  Input->CorrParam->NumberOfParticles = (size_t *)calloc(Input->CorrParam->ParticleTypes,sizeof(size_t));
  Input->CorrParam->Mass = (double *)calloc(Input->CorrParam->ParticleTypes,sizeof(double));

  Input->FileHandles = (FILE **)calloc(Input->CorrParam->ParticleTypes,sizeof(FILE*));
  Input->FileType = (int *)calloc(Input->CorrParam->ParticleTypes,sizeof(int));
  Input->StepsBetweenSamples = (int *)calloc(Input->CorrParam->ParticleTypes,sizeof(int));

  // discard empty line
  ReadNewLine(line,MaxLineLength,fileptr);

  // then, we start reading the actual components.
  for (size_t i=0;i<Input->CorrParam->ParticleTypes;i++)
  {
    double mass;
    char keyword[256];
    char keyword2[256];
    strcpy(keyword,"keyword");
    strcpy(keyword2,"keyword");
  
    ReadNewLine(line,MaxLineLength,fileptr);

    sscanf(line,"%lf%s%s",&mass,keyword,keyword2);

    printf("Trying to read file of component:     %zu\n",(i+1));
    printf("                       File name:     %s\n",keyword);
    printf("                       File type:     %s\n\n",keyword2);

    // try opening the files, and storing the data
    if(!(Input->FileHandles[i]=fopen(keyword,"r")))
    {
      printf("ReadInput: Trajectory-file not opened correctly, from input.\n");
      printf("Tried to open file: '%s'.\n",keyword);
      exit(1);
    }

    // check what type the input-file is.
    if(strcasecmp(keyword2,"keyword")==0)
    {
      printf("We have not read filetype correctly.\n");
      printf("We can use several different filetypes:\n");
      printf("com:  center of mass of each molecule + times crossed pbc\n");
      printf("comw: center of mass of each molecule, in real coordinates \n");
      printf("comv:  center of mass of each molecule + times crossed pbc + velocity information\n");
      printf("comwv: center of mass of each molecule, in real coordinates + velocity information\n");
      exit(1);
    }
    else if(strcasecmp(keyword2,"com")==0) 
    {
      Input->FileType[i] = COM;
      printf("Filetype COM\n");
    }
    else if(strcasecmp(keyword2,"cow")==0) 
    {
      Input->FileType[i] = COW;
      printf("Filetype COW\n");
    }
    else if(strcasecmp(keyword2,"comw")==0) 
    {
      Input->FileType[i] = COMW;
      printf("Filetype COMW\n");
    }
    else
    {
      printf("Unknown filetype: %s\n",keyword2);
      printf("Exit now.");
      exit(1);
    }

    if(mass<0.01) mass = 1.0;
    Input->CorrParam->Mass[i] = mass;
  }
  
  fclose(fileptr);

  return Input;
}


#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

#include "utils.h"
#include "readinput.h"
#include "corrdata.h"


STATE_BLOCK *ReserveMemoryStateBlock(INPUT_DATA *Input)
{

  STATE_BLOCK *State = NULL;
  
  State = (STATE_BLOCK *)malloc(1*sizeof(STATE_BLOCK));

  size_t Blocks = Input->CorrParam->MaxBlocks;
  size_t Elements = Input->CorrParam->MaxElements;
  size_t ParticleTypes = Input->CorrParam->ParticleTypes;
  size_t *NumberOfParticles = Input->CorrParam->NumberOfParticles;
  
  State->Switch = Input->Switch;
  State->CorrParam = Input->CorrParam;
  
  printf("\t Reserving memory for stateblock ...");

  if(State->Switch->SavePositions)
  {
    State->ParticleX = (double****)calloc(Blocks,sizeof(double***));
    State->ParticleY = (double****)calloc(Blocks,sizeof(double***));
    State->ParticleZ = (double****)calloc(Blocks,sizeof(double***));

    for (size_t i=0;i<Blocks;i++)
    {
      State->ParticleX[i] = (double***)calloc(Elements,sizeof(double**));
      State->ParticleY[i] = (double***)calloc(Elements,sizeof(double**));
      State->ParticleZ[i] = (double***)calloc(Elements,sizeof(double**));
    

      for (size_t j=0;j<Elements;j++)
      {
        State->ParticleX[i][j] = (double**)calloc(ParticleTypes,sizeof(double*));
        State->ParticleY[i][j] = (double**)calloc(ParticleTypes,sizeof(double*));
        State->ParticleZ[i][j] = (double**)calloc(ParticleTypes,sizeof(double*));
      
        for (size_t k=0;k<ParticleTypes;k++)
        {
          State->ParticleX[i][j][k] = (double*)calloc(NumberOfParticles[k],sizeof(double));
          State->ParticleY[i][j][k] = (double*)calloc(NumberOfParticles[k],sizeof(double));
          State->ParticleZ[i][j][k] = (double*)calloc(NumberOfParticles[k],sizeof(double));
        }
      }
    }
  }

  if(State->Switch->SaveCollective)
  {
    State->CenterOfMassX = (double***)calloc(Blocks,sizeof(double**));
    State->CenterOfMassY = (double***)calloc(Blocks,sizeof(double**));
    State->CenterOfMassZ = (double***)calloc(Blocks,sizeof(double**));


    for(size_t i=0;i<Blocks;i++)
    {
      State->CenterOfMassX[i] = (double**)calloc(Elements,sizeof(double*));
      State->CenterOfMassY[i] = (double**)calloc(Elements,sizeof(double*));
      State->CenterOfMassZ[i] = (double**)calloc(Elements,sizeof(double*));

      for (size_t j=0;j<Elements;j++)
      {
        State->CenterOfMassX[i][j] = (double*)calloc(ParticleTypes,sizeof(double));
        State->CenterOfMassY[i][j] = (double*)calloc(ParticleTypes,sizeof(double));
        State->CenterOfMassZ[i][j] = (double*)calloc(ParticleTypes,sizeof(double));
      }
    }
  }
  
  if(State->Switch->SaveVelocity)
  {
    State->VelocityX = (double****)calloc(Blocks,sizeof(double***));
    State->VelocityY = (double****)calloc(Blocks,sizeof(double***));
    State->VelocityZ = (double****)calloc(Blocks,sizeof(double***));

    for (size_t i=0;i<Blocks;i++)
    {
      State->VelocityX[i] = (double***)calloc(Elements,sizeof(double**));
      State->VelocityY[i] = (double***)calloc(Elements,sizeof(double**));
      State->VelocityZ[i] = (double***)calloc(Elements,sizeof(double**));
    

      for (size_t j=0;j<Elements;j++)
      {
        State->VelocityX[i][j] = (double**)calloc(ParticleTypes,sizeof(double*));
        State->VelocityY[i][j] = (double**)calloc(ParticleTypes,sizeof(double*));
        State->VelocityZ[i][j] = (double**)calloc(ParticleTypes,sizeof(double*));
      
        for (size_t k=0;k<ParticleTypes;k++)
        {
          State->VelocityX[i][j][k] = (double*)calloc(NumberOfParticles[k],sizeof(double));
          State->VelocityY[i][j][k] = (double*)calloc(NumberOfParticles[k],sizeof(double));
          State->VelocityZ[i][j][k] = (double*)calloc(NumberOfParticles[k],sizeof(double));
        }
      }
    }
  }

  printf(" done\n");

  return State;
}

void ReleaseMemoryStateBlock(STATE_BLOCK *State)
{
  
  printf("\t Releasing memory for stateblock ...");

  if(State->Switch->SavePositions)
  {
    for(size_t i=0;i<State->CorrParam->MaxBlocks;i++)
    {
      for(size_t j=0;j<State->CorrParam->MaxElements;j++)
      {
        for(size_t k=0;k<State->CorrParam->ParticleTypes;k++)
        {
          free(State->ParticleX[i][j][k]);
          free(State->ParticleY[i][j][k]);
          free(State->ParticleZ[i][j][k]);
        }
        free(State->ParticleX[i][j]);
        free(State->ParticleY[i][j]);
        free(State->ParticleZ[i][j]);
      }
      free(State->ParticleX[i]);
      free(State->ParticleY[i]);
      free(State->ParticleZ[i]);
    }
    free(State->ParticleX);
    free(State->ParticleY);
    free(State->ParticleZ);
  }

  if(State->Switch->SaveCollective)
  {
    for(size_t i=0;i<State->CorrParam->MaxBlocks;i++)
    {
      for (size_t j=0;j<State->CorrParam->MaxElements;j++)
      {
        free(State->CenterOfMassX[i][j]);
        free(State->CenterOfMassY[i][j]);
        free(State->CenterOfMassZ[i][j]);
      }
      free(State->CenterOfMassX[i]);
      free(State->CenterOfMassY[i]);
      free(State->CenterOfMassZ[i]);
    }
    free(State->CenterOfMassX);
    free(State->CenterOfMassY);
    free(State->CenterOfMassZ);
  }
  
  if(State->Switch->SaveVelocity)
  {
    for (size_t i=0;i<State->CorrParam->MaxBlocks;i++)
    {
      for (size_t j=0;j<State->CorrParam->MaxElements;j++)
      {
        for (size_t k=0;k<State->CorrParam->ParticleTypes;k++)
        {
          free(State->VelocityX[i][j][k]);
          free(State->VelocityY[i][j][k]);
          free(State->VelocityZ[i][j][k]);
        }
        free(State->VelocityX[i][j]);
        free(State->VelocityY[i][j]);
        free(State->VelocityZ[i][j]);
      }
      free(State->VelocityX[i]);
      free(State->VelocityY[i]);
      free(State->VelocityZ[i]);
    }
    free(State->VelocityX);
    free(State->VelocityY);
    free(State->VelocityZ);
  }

  printf(" done\n");
  
}


CORRDATA *ReserveMemoryCorrData(INPUT_DATA *Input)
{

  CORRDATA *Data = NULL;
  
  Data = (CORRDATA *)calloc(1,sizeof(CORRDATA));

  size_t Blocks = Input->CorrParam->MaxBlocks;
  size_t Elements = Input->CorrParam->MaxElements;
  size_t ParticleTypes = Input->CorrParam->ParticleTypes;
  
  Data->Switch = Input->Switch;
  Data->CorrParam = Input->CorrParam;
  
  printf("\t Reserving memory for correlation data ...");

  if(Data->Switch->SavePositions)
  {
    Data->SelfX = (double***)calloc(Blocks,sizeof(double**));
    Data->SelfY = (double***)calloc(Blocks,sizeof(double**));
    Data->SelfZ = (double***)calloc(Blocks,sizeof(double**));
    Data->SelfAvg = (double***)calloc(Blocks,sizeof(double**));
    Data->SelfCounter = (double***)calloc(Blocks,sizeof(double**));

    for (size_t i=0;i<Blocks;i++)
    {
      Data->SelfX[i] = (double**)calloc(Elements,sizeof(double*));
      Data->SelfY[i] = (double**)calloc(Elements,sizeof(double*));
      Data->SelfZ[i] = (double**)calloc(Elements,sizeof(double*));
      Data->SelfAvg[i] = (double**)calloc(Elements,sizeof(double*));
      Data->SelfCounter[i] = (double**)calloc(Elements,sizeof(double*));
    
      for (size_t j=0;j<Elements;j++)
      {
        Data->SelfX[i][j] = (double*)calloc(ParticleTypes,sizeof(double));
        Data->SelfY[i][j] = (double*)calloc(ParticleTypes,sizeof(double));
        Data->SelfZ[i][j] = (double*)calloc(ParticleTypes,sizeof(double));
        Data->SelfAvg[i][j] = (double*)calloc(ParticleTypes,sizeof(double));
        Data->SelfCounter[i][j] = (double*)calloc(ParticleTypes,sizeof(double));
      }
    }
  }

  if(Data->Switch->SaveCollective)
  {
    Data->CrossX = (double****)calloc(Blocks,sizeof(double***));
    Data->CrossY = (double****)calloc(Blocks,sizeof(double***));
    Data->CrossZ = (double****)calloc(Blocks,sizeof(double***));
    Data->CrossAvg = (double****)calloc(Blocks,sizeof(double***));
    Data->CrossCounter = (double****)calloc(Blocks,sizeof(double***));
    
    for(size_t i=0;i<Blocks;i++)
    {
      Data->CrossX[i] = (double***)calloc(Elements,sizeof(double**));
      Data->CrossY[i] = (double***)calloc(Elements,sizeof(double**));
      Data->CrossZ[i] = (double***)calloc(Elements,sizeof(double**));
      Data->CrossAvg[i] = (double***)calloc(Elements,sizeof(double**));
      Data->CrossCounter[i] = (double***)calloc(Elements,sizeof(double**));
      
      for(size_t j=0;j<Elements;j++)
      {
        Data->CrossX[i][j] = (double**)calloc(ParticleTypes,sizeof(double*));
        Data->CrossY[i][j] = (double**)calloc(ParticleTypes,sizeof(double*));
        Data->CrossZ[i][j] = (double**)calloc(ParticleTypes,sizeof(double*));
        Data->CrossAvg[i][j] = (double**)calloc(ParticleTypes,sizeof(double*));
        Data->CrossCounter[i][j] = (double**)calloc(ParticleTypes,sizeof(double*));

        for (size_t k=0;k<ParticleTypes;k++)
        {
          Data->CrossX[i][j][k] = (double*)calloc(ParticleTypes,sizeof(double));
          Data->CrossY[i][j][k] = (double*)calloc(ParticleTypes,sizeof(double));
          Data->CrossZ[i][j][k] = (double*)calloc(ParticleTypes,sizeof(double));
          Data->CrossAvg[i][j][k] = (double*)calloc(ParticleTypes,sizeof(double));
          Data->CrossCounter[i][j][k] = (double*)calloc(ParticleTypes,sizeof(double));
        }
      }
    }
  }
  
  /*
  if(Data->SaveVelocity)
  {
    Data->SelfX = (double***)calloc(Data->MaxBlocks,sizeof(double**));
    Data->SelfY = (double***)calloc(Data->MaxBlocks,sizeof(double**));
    Data->SelfZ = (double***)calloc(Data->MaxBlocks,sizeof(double**));
    Data->SelfAvg = (double***)calloc(Data->MaxBlocks,sizeof(double**));
    Data->SelfCounter = (double***)calloc(Data->MaxBlocks,sizeof(double**));

    for (size_t i=0;i<Data->MaxBlocks;i++)
    {
    
      Data->SelfX[i] = (double**)calloc(Data->MaxElements,sizeof(double*));
      Data->SelfY[i] = (double**)calloc(Data->MaxElements,sizeof(double*));
      Data->SelfZ[i] = (double**)calloc(Data->MaxElements,sizeof(double*));
      Data->SelfAvg[i] = (double**)calloc(Data->MaxElements,sizeof(double*));
      Data->SelfCounter[i] = (double**)calloc(Data->MaxElements,sizeof(double*));
    
      for (size_t j=0;j<Data->MaxElements;j++)
      {
    
        Data->SelfX[i][j] = (double*)calloc(Data->ParticleTypes,sizeof(double));
        Data->SelfY[i][j] = (double*)calloc(Data->ParticleTypes,sizeof(double));
        Data->SelfZ[i][j] = (double*)calloc(Data->ParticleTypes,sizeof(double));
        Data->SelfAvg[i][j] = (double*)calloc(Data->ParticleTypes,sizeof(double));
        Data->SelfCounter[i][j] = (double*)calloc(Data->ParticleTypes,sizeof(double));
      }
    }
  }

  */

  printf(" done\n");

  return Data;
}


void ReleaseMemoryCorrData(CORRDATA *data)
{

  printf("\t Releasing memory Correlation data ...");

  for (size_t i=0;i<data->CorrParam->MaxBlocks;i++)
  {
    for (size_t j=0;j<data->CorrParam->MaxElements;j++)
    {
      for (size_t k=0;k<data->CorrParam->ParticleTypes;k++)
      {
        free(data->CrossX[i][j][k]);
        free(data->CrossY[i][j][k]);
        free(data->CrossZ[i][j][k]);
        free(data->CrossAvg[i][j][k]);
        free(data->CrossCounter[i][j][k]);
      }
    
      free(data->SelfX[i][j]);
      free(data->SelfY[i][j]);
      free(data->SelfZ[i][j]);
      free(data->SelfAvg[i][j]);
      free(data->SelfCounter[i][j]);

      free(data->CrossX[i][j]);
      free(data->CrossY[i][j]);
      free(data->CrossZ[i][j]);
      free(data->CrossAvg[i][j]);
      free(data->CrossCounter[i][j]);
    }
      
    free(data->SelfX[i]);
    free(data->SelfY[i]);
    free(data->SelfZ[i]);
    free(data->SelfAvg[i]);
    free(data->SelfCounter[i]);

    free(data->CrossX[i]);
    free(data->CrossY[i]);
    free(data->CrossZ[i]);
    free(data->CrossAvg[i]);
    free(data->CrossCounter[i]);
  }

  free(data->SelfX);
  free(data->SelfY);
  free(data->SelfZ);
  free(data->SelfAvg);
  free(data->SelfCounter);

  free(data->CrossX);
  free(data->CrossY);
  free(data->CrossZ);
  free(data->CrossAvg);
  free(data->CrossCounter);
  
  printf(" done \n");

}


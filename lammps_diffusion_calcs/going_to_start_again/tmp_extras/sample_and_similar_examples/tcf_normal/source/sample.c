
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <math.h>
#include <limits.h>


#include "utils.h"
#include "readinput.h"
#include "corrdata.h"
#include "readtraj.h"
#include "sample.h"

int ReadSnap(INPUT_DATA *, SNAPSHOT *);
void PrintData(CORRDATA *, size_t, size_t *);
void StoreBlockData(SNAPSHOT *, STATE_BLOCK *, size_t, size_t * );
void CalculateCorrelation(STATE_BLOCK *, CORRDATA *, size_t, size_t *);

void Sample(INPUT_DATA *Input)
{
  size_t SampleTimes = 0;

  SNAPSHOT *Snapshot = AllocateSnapshotMemory(Input);
  STATE_BLOCK *State = ReserveMemoryStateBlock(Input);  
  CORRDATA *SampleData = ReserveMemoryCorrData(Input);

  // allocate memory for length of block
  size_t *BlockLength = (size_t *) calloc(Input->CorrParam->MaxBlocks,sizeof(size_t));

  // read the first snapshot
  printf("\t Reading first snapshot ...");
  ReadSnap(Input, Snapshot);
  printf(" done\n");

  StoreBlockData(Snapshot,State,SampleTimes,BlockLength);

  SampleTimes++;

  //printf("\n\t Sampling ...\n");
  while(ReadSnap(Input,Snapshot))
  {
    if((SampleTimes%1000)==0)
    {
      printf(" \t \t Sampling snapshot %zu ",SampleTimes);
      printf("\r"); 
      fflush(stdout);
    }

    StoreBlockData(Snapshot,State,SampleTimes,BlockLength);
    CalculateCorrelation(State,SampleData,SampleTimes,BlockLength);
    SampleTimes++;

  }
  printf(" \t \t Sampling snapshots --- done\n");

  PrintData(SampleData,SampleTimes,BlockLength);
  
  //ReleaseMemorySnapshot(Input,Snapshot);
  //ReleaseMemoryStateBlock(Input,State);

}



/* 
 * This function stores the current data in the snapshot. This involves shifting the positions
 * of the snapshot data, and putting the current snapshot in the right position for those 
 * blocks where it is is relevant.
 */

void StoreBlockData(SNAPSHOT *Snapshot, STATE_BLOCK *State, size_t TimesSampled, size_t *BlockLength)
{

  size_t Blocks = State->CorrParam->MaxBlocks;
  size_t Elements = State->CorrParam->MaxElements;
  size_t ParticleTypes = State->CorrParam->ParticleTypes;
  size_t *NumberOfParticles = State->CorrParam->NumberOfParticles;

  //printf("Blocks: %zu\n",Blocks);
  //printf("Elements: %zu\n",Elements);
  //printf("ParticleTypes: %zu\n",ParticleTypes);

  // if we are doing this for the first timestep, we have to fill in data
  // in all the blocks. This to take full advantage of all the possible 
  // correlation times.
  if(TimesSampled==0)
  {
    printf("\t Storing first snapshot ...");
    
    for(size_t block=0;block<Blocks;block++)
    {
      BlockLength[block]++;

      // if we are calculating MSDs (self-diffusion)
      if(State->Switch->SavePositions)
      {
        for(size_t comp=0;comp<ParticleTypes;comp++)
        {
          for(size_t part=0;part<NumberOfParticles[comp];part++)
          {
            State->ParticleX[block][0][comp][part] = Snapshot->PosX[comp][part];
            State->ParticleY[block][0][comp][part] = Snapshot->PosY[comp][part];
            State->ParticleZ[block][0][comp][part] = Snapshot->PosZ[comp][part];
          }
        }
      }
      
      // if we are collective MSDs (collective diffusion)
      if(State->Switch->SaveCollective)
      {
        for(size_t comp=0;comp<ParticleTypes;comp++)
        {

          State->CenterOfMassX[block][0][comp] = Snapshot->CentreOfMassX[comp];
          State->CenterOfMassY[block][0][comp] = Snapshot->CentreOfMassY[comp];
          State->CenterOfMassZ[block][0][comp] = Snapshot->CentreOfMassZ[comp];
        }
      }

      // if we are collecting velocities as well
      if(State->Switch->SaveVelocity)
      {
        for(size_t comp=0;comp<ParticleTypes;comp++)
        {
          for(size_t part=0;part<NumberOfParticles[comp];part++)
          {
            State->VelocityX[block][0][comp][part] = Snapshot->VelocityX[comp][part];
            State->VelocityY[block][0][comp][part] = Snapshot->VelocityY[comp][part];
            State->VelocityZ[block][0][comp][part] = Snapshot->VelocityZ[comp][part];
          }
        }
      }
    }

    printf(" done\n");
  }
  else
  {
    /* 
     * We have stored the first snapshot. Now, lets work with the rest.
     */

    size_t NumberOfBlocks=FindCurrentNumberOfBlocks(TimesSampled,Elements,Blocks);

    // loop over all the current blocks
    for(size_t CurrBlock=0;CurrBlock<NumberOfBlocks;CurrBlock++)
    {
      // if the current snapshot is divisable by the elements**block
      // it means that we can store information from this snapshot in that block
      if((TimesSampled)%((int)pow((double)Elements,CurrBlock))==0)
      {
        
        // find the length of the current block
        size_t CurrBlockLength = MIN2(BlockLength[CurrBlock]+1,Elements);

        // we store data, increment the length of the current block
        BlockLength[CurrBlock]++;

        // loop over all components and particles..
        for(size_t comp=0;comp<ParticleTypes;comp++)
        {
          for(size_t part=0;part<NumberOfParticles[comp];part++)
          {
            // move the elements one step over
            
            if(State->Switch->SavePositions)
            {
              for (size_t elem=CurrBlockLength-1;elem>0;elem--)
              {
                State->ParticleX[CurrBlock][elem][comp][part] = State->ParticleX[CurrBlock][elem-1][comp][part];
                State->ParticleY[CurrBlock][elem][comp][part] = State->ParticleY[CurrBlock][elem-1][comp][part];
                State->ParticleZ[CurrBlock][elem][comp][part] = State->ParticleZ[CurrBlock][elem-1][comp][part];
              }

              State->ParticleX[CurrBlock][0][comp][part] = Snapshot->PosX[comp][part];
              State->ParticleY[CurrBlock][0][comp][part] = Snapshot->PosY[comp][part];
              State->ParticleZ[CurrBlock][0][comp][part] = Snapshot->PosZ[comp][part];
            }
            
            if(State->Switch->SaveVelocity)
            {
              for (size_t elem=CurrBlockLength-1;elem>0;elem--)
              {
                State->VelocityX[CurrBlock][elem][comp][part] = State->VelocityX[CurrBlock][elem-1][comp][part];
                State->VelocityY[CurrBlock][elem][comp][part] = State->VelocityY[CurrBlock][elem-1][comp][part];
                State->VelocityZ[CurrBlock][elem][comp][part] = State->VelocityZ[CurrBlock][elem-1][comp][part];
              }

              State->VelocityX[CurrBlock][0][comp][part] = Snapshot->VelocityX[comp][part];
              State->VelocityY[CurrBlock][0][comp][part] = Snapshot->VelocityY[comp][part];
              State->VelocityZ[CurrBlock][0][comp][part] = Snapshot->VelocityZ[comp][part];
            }


          } // end of loop over individual particles

          if(State->Switch->SaveCollective)
          {
            for(size_t elem=CurrBlockLength-1;elem>0;elem--)
            {
              State->CenterOfMassX[CurrBlock][elem][comp] = State->CenterOfMassX[CurrBlock][elem-1][comp];
              State->CenterOfMassY[CurrBlock][elem][comp] = State->CenterOfMassY[CurrBlock][elem-1][comp];
              State->CenterOfMassZ[CurrBlock][elem][comp] = State->CenterOfMassZ[CurrBlock][elem-1][comp];
            }
            
            State->CenterOfMassX[CurrBlock][0][comp] = Snapshot->CentreOfMassX[comp];
            State->CenterOfMassY[CurrBlock][0][comp] = Snapshot->CentreOfMassY[comp];
            State->CenterOfMassZ[CurrBlock][0][comp] = Snapshot->CentreOfMassZ[comp];
          }

        } // end loop over all components
      }
    }
  }
}

/*
 * Calculate the correlation functions. We can do this for several different methods.
 */

void CalculateCorrelation(STATE_BLOCK *State, CORRDATA *Correlation, size_t TimesSampled, size_t *BlockLength)
{
  
  size_t Blocks = State->CorrParam->MaxBlocks;
  size_t Elements = State->CorrParam->MaxElements;
  size_t ParticleTypes = State->CorrParam->ParticleTypes;
  size_t *NumberOfParticles = State->CorrParam->NumberOfParticles;

  size_t NumberOfBlocks=FindCurrentNumberOfBlocks(TimesSampled,Elements,Blocks);

  // loop over all the current blocks
  for(size_t CurrBlock=0;CurrBlock<NumberOfBlocks;CurrBlock++)
  {
    // if this is true, we have should calculate the correlation
    if((TimesSampled)%((int)pow((double)Elements,CurrBlock))==0)
    {

      // how long is the current block, i.e. how many elements do we have here?
      size_t CurrBlockLength = MIN2(BlockLength[CurrBlock],Elements);

      for(size_t comp=0;comp<ParticleTypes;comp++)
      {

        /* Calculate the MSD for individual particles.
         * If we are storing the Correlation for each individual particle, we should do that here.
         */

        if(State->Switch->SavePositions)
        {
          for(size_t part=0;part<NumberOfParticles[comp];part++)
          {
            for(size_t elem=0;elem<CurrBlockLength;elem++)
            {

              double msdx = SQR(State->ParticleX[CurrBlock][elem][comp][part]-State->ParticleX[CurrBlock][0][comp][part]);
              double msdy = SQR(State->ParticleY[CurrBlock][elem][comp][part]-State->ParticleY[CurrBlock][0][comp][part]);
              double msdz = SQR(State->ParticleZ[CurrBlock][elem][comp][part]-State->ParticleZ[CurrBlock][0][comp][part]);
              
              Correlation->SelfCounter[CurrBlock][elem][comp]+=1.0;

              Correlation->SelfX[CurrBlock][elem][comp]+=msdx;
              Correlation->SelfY[CurrBlock][elem][comp]+=msdy;
              Correlation->SelfZ[CurrBlock][elem][comp]+=msdz;
              
              Correlation->SelfAvg[CurrBlock][elem][comp]+=(msdx + msdy + msdz);
            }
          } // end of loop over individual particles
        }

        /* Calculate MSD for com for species. This gives us the cross-terms
         */
        if(State->Switch->SaveCollective)
        {
          for(size_t elem=0;elem<CurrBlockLength;elem++)
          {
            for(size_t comp2=0;comp2<ParticleTypes;comp2++)
            {
              double blcx = ((State->CenterOfMassX[CurrBlock][elem][comp] -State->CenterOfMassX[CurrBlock][0][comp])*
                             (State->CenterOfMassX[CurrBlock][elem][comp2]-State->CenterOfMassX[CurrBlock][0][comp2]));
              
              double blcy = ((State->CenterOfMassY[CurrBlock][elem][comp] -State->CenterOfMassY[CurrBlock][0][comp])*
                             (State->CenterOfMassY[CurrBlock][elem][comp2]-State->CenterOfMassY[CurrBlock][0][comp2]));
              
              double blcz = ((State->CenterOfMassZ[CurrBlock][elem][comp] -State->CenterOfMassZ[CurrBlock][0][comp])*
                             (State->CenterOfMassZ[CurrBlock][elem][comp2]-State->CenterOfMassZ[CurrBlock][0][comp2]));

              Correlation->CrossCounter[CurrBlock][elem][comp][comp2]+=1.0;

              Correlation->CrossX[CurrBlock][elem][comp][comp2]+=blcx;
              Correlation->CrossY[CurrBlock][elem][comp][comp2]+=blcy;
              Correlation->CrossZ[CurrBlock][elem][comp][comp2]+=blcz;
              Correlation->CrossAvg[CurrBlock][elem][comp][comp2]+=(blcx + blcy + blcz);
                                                               
            }
          }
        }
      } // loop over all components
    }
  }
}


void PrintData(CORRDATA *Sample, size_t TimesSampled, size_t *BlockLength)
{

  size_t Blocks = Sample->CorrParam->MaxBlocks;
  size_t Elements = Sample->CorrParam->MaxElements;
  size_t ParticleTypes = Sample->CorrParam->ParticleTypes;

  double ReadTimestep = Sample->CorrParam->SampleTimestep;

  size_t NumberOfBlocks=FindCurrentNumberOfBlocks(TimesSampled,Elements,Blocks);
  

  

  /*
   * Print the MSD for type of particle
   */
  
  if(Sample->Switch->SavePositions)
  {

    // here we print the number of times this has been sampled.
    FILE *pfileptr=NULL;

    if(!(pfileptr=fopen("msd_sample_stats","w")))
    {
      printf("\n\tUnable to open file msd_sample_stats\n");
      printf("Check that we have write access to disk\n");
      exit(1);
    }
    fprintf(pfileptr,"# Times each delta_t has been sampled.\n");

    for(size_t CurrBlock=0;CurrBlock<NumberOfBlocks;CurrBlock++)
    {

      size_t CurrentBlockLength = MIN2(BlockLength[CurrBlock],Elements);
      double dt = ReadTimestep*pow((double)Elements,CurrBlock);

      for(size_t elem=1;elem<CurrentBlockLength;elem++)
      {
        fprintf(pfileptr,"%10.3f   ", ((double)elem*dt));
        for (size_t comp=0;comp<ParticleTypes;comp++)
        {
          fprintf(pfileptr,"%zu ",(size_t)(Sample->SelfCounter[CurrBlock][elem][comp]/Sample->CorrParam->NumberOfParticles[comp]));
        }
        fprintf(pfileptr,"\n");
      }
    }
    fclose(pfileptr);

    // print the actuall msd
    for (size_t comp=0;comp<ParticleTypes;comp++)
    {
      FILE *fileptr=NULL;
      char buffer[256];
      sprintf(buffer,"msd_self_comp_%zu.dat",comp+1);
      printf("\t Printing MSD for Component %zu to file %s ...",(comp+1),buffer);

      if(!(fileptr=fopen(buffer,"w")))
      {
        printf("\n\tUnable to open file %s\n",buffer);
        printf("Check that we have write access to disk\n");
        exit(1);
      }

      fprintf(fileptr,"# Mean Squared displacement\n");
      fprintf(fileptr,"# Time [ps] xdirection ydirection zdirection Average\n");

      for(size_t CurrBlock=0;CurrBlock<NumberOfBlocks;CurrBlock++)
      {
        size_t CurrentBlockLength = MIN2(BlockLength[CurrBlock],Elements);
        double dt = ReadTimestep*pow((double)Elements,CurrBlock);

        for(size_t elem=1;elem<CurrentBlockLength;elem++)
        {
          if(Sample->SelfCounter[CurrBlock][elem][comp]>0.0)
          {
            double fac = 1.0/Sample->SelfCounter[CurrBlock][elem][comp];
            fprintf(fileptr,"%10.3f \t %10.7e \t %10.7e \t %10.7e \t %10.7e\n",
                ((double)elem*dt),
                (fac*Sample->SelfX[CurrBlock][elem][comp]),
                (fac*Sample->SelfY[CurrBlock][elem][comp]),
                (fac*Sample->SelfZ[CurrBlock][elem][comp]),
                (fac*Sample->SelfAvg[CurrBlock][elem][comp]));
          }
        }
      }
      fclose(fileptr);
      printf(" done \n");
    }

    /*
     * Print the total MSD for all particle types. In the case of a
     * 1-comp system, this is the same as msd_self_comp_X.dat, so we don't print if we have less then 1-comp
     */

    if(ParticleTypes>1)
    {
      FILE *fileptr=NULL;
      char buffer[256];
      sprintf(buffer,"msd_self_total.dat");
      printf("\tPrinting total MSD to file %s ...",buffer);

      if(!(fileptr=fopen(buffer,"w")))
      {
        printf("\n\tUnable to open file %s\n",buffer);
        printf("Check that we have write access to disk\n");
        exit(1);
      }

      fprintf(fileptr,"# Total Mean Squared displacement\n");
      fprintf(fileptr,"# Time [ps] xdirection ydirection zdirection Average\n");

      for(size_t CurrBlock=0;CurrBlock<NumberOfBlocks;CurrBlock++)
      {
        size_t CurrentBlockLength = MIN2(BlockLength[CurrBlock],Elements);
        double dt = ReadTimestep*pow((double)Elements,CurrBlock);

        for(size_t elem=1;elem<CurrentBlockLength;elem++)
        {

          double val_x = 0.0;
          double val_y = 0.0;
          double val_z = 0.0;
          double val_avg = 0.0;
          size_t count = 0;

          for (size_t comp=0;comp<ParticleTypes;comp++)
          {
            val_x += Sample->SelfX[CurrBlock][elem][comp];
            val_y += Sample->SelfY[CurrBlock][elem][comp];
            val_z += Sample->SelfZ[CurrBlock][elem][comp];
            val_avg += Sample->SelfAvg[CurrBlock][elem][comp];
            count += Sample->SelfCounter[CurrBlock][elem][comp];
          }

          if(count>0)
          {
            double fac = 1.0/(double)count;
            fprintf(fileptr,"%10.3f \t %10.7e \t %10.7e \t %10.7e \t %10.7e\n",
                ((double)elem*dt),
                (fac*val_x),
                (fac*val_y),
                (fac*val_z),
                (fac*val_avg));
          }
        }
      }
      fclose(fileptr);
      printf(" done \n");
    }

  }

  /*
   * Print the MSD of the center of mass for the different components, as
   * well as their cross-terms.
   */

  if(Sample->Switch->SaveCollective)
  {
    for (size_t comp=0;comp<ParticleTypes;comp++) 
    {
      for (size_t comp2=0;comp2<ParticleTypes;comp2++)
      {
        FILE *fileptr=NULL;
        char buffer[256];
      
        sprintf(buffer,"msd_collective_comp_%zu_%zu.dat",(comp+1),(comp2+1));
      
        printf("\t Printing MSD for COM for Component %zu -- %zu to file %s ...",(comp+1),(comp2+1),buffer);

        if(!(fileptr=fopen(buffer,"w")))
        {
          printf("\n\tUnable to open file %s\n",buffer);
          printf("Check that we have write access to disk\n");
          exit(1);
        }

        fprintf(fileptr,"# Mean Squared displacement for center of mass.\n");
        fprintf(fileptr,"# Time [ps] xdirection ydirection zdirection Average\n");

        for (size_t CurrBlock=0;CurrBlock<NumberOfBlocks;CurrBlock++)
        {

          size_t CurrentBlockLength = MIN2(BlockLength[CurrBlock],Elements);
          double dt = ReadTimestep*pow((double)Elements,CurrBlock);

          for(size_t elem=1;elem<CurrentBlockLength;elem++)
          {
            if(Sample->CrossCounter[CurrBlock][elem][comp][comp2]>0.0)
            {

            double fac = 1.0/Sample->CrossCounter[CurrBlock][elem][comp][comp2];

            fprintf(fileptr,"%10.3f \t %10.7e \t %10.7e \t %10.7e \t %10.7e\n",
                ((double)elem*dt),
                (fac*Sample->CrossX[CurrBlock][elem][comp][comp2]),
                (fac*Sample->CrossY[CurrBlock][elem][comp][comp2]),
                (fac*Sample->CrossZ[CurrBlock][elem][comp][comp2]),
                (fac*Sample->CrossAvg[CurrBlock][elem][comp][comp2]));
            }
          }
        }

        fclose(fileptr);
        printf(" done\n");
      }
    }
  }
}


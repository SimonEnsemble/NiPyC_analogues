#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <getopt.h>
#include <string.h>

#include "readinput.h"
#include "readtraj.h"
#include "utils.h"
#include "corrdata.h"
#include "sample.h"



/*
 *  Main function. We read in all input from either cmd, or from the
 *  input-files we read. If we want to calculate MS-diffusion, we
 *  need to specify the mass. We make a few assumptions based on the
 *  input-files. The output is printed directly to files.
 */


int main(int argc, char **argv)
{

  int c;
  int Blocks = 10;
  int Elements = 10;
  double Timestep = 0.001;
  char Fname[256];
  
  INPUT_DATA *InputData=NULL;

  strcpy(Fname,"empty");
  
  // parse input arguments

  while((c=getopt(argc,argv,"hpvf:b:e:t:"))!=-1)
  {
    switch(c)
    {
      case 'h':
        printf("using tfc:\n");
        printf("\t -h:  Print this message.\n");
        printf("\t -p:  Print a generic input-file.\n");
        printf("\t -v:  Print version.\n");
        printf("\t -f:  Input-file.\n");
        printf("\t -b:  Blocks (default: 10).\n");
        printf("\t -e:  Elements (default: 10).\n");
        printf("\t -t:  Simulation timestep [ps] (default: 0.001)\n");
        //printf("\t \n");
        return 0;
        break;
      case 'v':
        printf("version 0.1b\n");
        return 0;
        break;
      case 'p':
        PrintDefaultInput();
        return 0;
        break;
      case 'f':
        strcpy(Fname,optarg);
        printf("Input-file set to be: '%s'\n",Fname);
        break;
      case 'b':
        Blocks = atoi(optarg);
        break;
      case 'e':
        Elements = atoi(optarg);
        break;
      case 't':
        Timestep = (double)atof(optarg);
        break;
      default:
        ;
    }
  }

  // read input
  // we pass in all the variables we have read from the cmd
  InputData = ReadInput(Blocks,Elements,Timestep,Fname);
  GetSnapshotData(InputData);

  Sample(InputData);

  // release memory
  ReleaseInput(InputData);

  printf("\t Done for now!\n");

  return 0;
}

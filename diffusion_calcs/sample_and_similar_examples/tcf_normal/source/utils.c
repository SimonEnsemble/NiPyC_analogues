
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

#include "utils.h"


void PrintDefaultInput(void)
{
  FILE *fptr;

  if(!(fptr=fopen("demo_input.msd","w")))
  {
    printf(" Problems opening file: 'demo_input.msd' \n");
    printf(" Hint: Check rights, can we write to folder?\n");
    exit(5);
  }
  else
  {
    fprintf(fptr,"# X_lo    X_hi  \n");
    fprintf(fptr,"0.0       100.0   \n");
    fprintf(fptr,"0.0       100.0   \n");
    fprintf(fptr,"0.0       100.0   \n");
    fprintf(fptr,"# Triclinic parameters xy, xz, yz \n");
    fprintf(fptr,"0.0       0.0     0.0\n");
    fprintf(fptr,"# 'correct_drift' 'individual' 'collective' 'msd'  'vacf'\n");
    fprintf(fptr,"0                 0         1   1   0\n");
    fprintf(fptr,"# particle types  \n");
    fprintf(fptr,"2                 \n");
    fprintf(fptr,"# mass  trajfile  filetype  \n");
    fprintf(fptr,"1.0     filename1.dat com\n");
    fprintf(fptr,"2.0     filename2.dat com\n");
    fclose(fptr);
  }
}



/* Read a line in to array s, return length
 * From "the C programming language"
 */

int ReadNewLine(char s[], int lim, FILE *file)
{
  int c,i;

  //for (i=0;i<lim-1 && (c=getchar())!=EOF && c!='\n'; ++i)
  for (i=0;i<lim-1 && (c=fgetc(file))!=EOF && c!='\n'; ++i)
    s[i] = c;
  if(c=='\n')
  {
    s[i] = c;
    i++;
  }
  s[i] = '\0';
  return i;
}

/*
 * Calculate the current number of Blocks we are using. 
 */
size_t FindCurrentNumberOfBlocks(size_t TimesSampled, size_t Elements, size_t Blocks)
{
  size_t NumBlocks=(size_t)1;

  size_t val=TimesSampled/Elements;

  while(val!=0)
  {
    NumBlocks++;
    val/=Elements;
  }
  NumBlocks = MIN2(NumBlocks,Blocks);
  return NumBlocks;
}


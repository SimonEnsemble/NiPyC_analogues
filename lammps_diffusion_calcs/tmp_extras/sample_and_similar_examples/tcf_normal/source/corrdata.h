#ifndef CORRDATA_H
#define CORRDATA_H 


/* 
 * Structure to hold the position position, and velocity data.
 */
typedef struct 
{
  SWITCHES *Switch;
  PARAMS *CorrParam;
  double ***CenterOfMassX;
  double ***CenterOfMassY;
  double ***CenterOfMassZ;
  double ****ParticleX;
  double ****ParticleY;
  double ****ParticleZ;
  double ****VelocityX;
  double ****VelocityY;
  double ****VelocityZ;
} STATE_BLOCK;

/*
 * Structure to hold the correlation data. 
 */
typedef struct 
{
  SWITCHES *Switch;
  PARAMS *CorrParam;
  double ***SelfX;
  double ***SelfY;
  double ***SelfZ;
  double ***SelfAvg;
  double ***SelfCounter;
  double ****CrossX;
  double ****CrossY;
  double ****CrossZ;
  double ****CrossAvg;
  double ****CrossCounter;
} CORRDATA; 


STATE_BLOCK *ReserveMemoryStateBlock(INPUT_DATA *);
void ReleaseMemoryStateBlock(STATE_BLOCK *);

CORRDATA *ReserveMemoryCorrData(INPUT_DATA *);
void ReleaseMemoryCorrData(CORRDATA *);

#endif

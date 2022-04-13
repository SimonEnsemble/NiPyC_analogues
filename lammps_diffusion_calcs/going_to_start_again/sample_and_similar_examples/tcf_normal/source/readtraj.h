#ifndef READTRAJ_H
#define READTRAJ_H 


typedef struct
{
  SWITCHES *Switch;
  PARAMS *CorrParam;
  double **PosX;
  double **PosY;
  double **PosZ;
  double **VelocityX;
  double **VelocityY;
  double **VelocityZ;
  double *CentreOfMassX;
  double *CentreOfMassY;
  double *CentreOfMassZ;
} SNAPSHOT;


int ReadSnap(INPUT_DATA *, SNAPSHOT *);
void GetSnapshotData(INPUT_DATA *);
SNAPSHOT *AllocateSnapshotMemory(INPUT_DATA *);



#endif

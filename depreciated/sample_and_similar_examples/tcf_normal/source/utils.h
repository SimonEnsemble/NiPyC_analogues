#ifndef UTILS_H
#define UTILS_H 


#ifndef MIN2
#define MIN2(n1,n2)((n1)>(n2)?(n2):(n1))
#endif

#ifndef MAX2
#define MAX2(n1,n2)((n1)>(n2)?(n1):(n2))
#endif


#ifndef SQR
#define SQR(x) ((x)*(x))
#endif

#ifndef CUBE
#define CUBE(x) ((x)*(x)*(x))
#endif

void PrintDefaultInput(void);
int ReadNewLine(char line[], int, FILE *);
size_t FindCurrentNumberOfBlocks(size_t,size_t,size_t);



#endif

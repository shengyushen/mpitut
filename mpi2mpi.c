#include <omp.h> 
#include <mpi.h> 

#include <stdlib.h> 
#include <stdio.h> 
#include <time.h> 
#include <assert.h> 
#include <ctype.h> 

int main(int argc,char * argv[]) {

  MPI_Init(NULL, NULL);
	double start=MPI_Wtime();
	if(argc !=3) {
		printf("usage : mpi2mpi.exe <iterations> <max_tag>");
		return 0;
	}

	int iterations;
	sscanf(argv[1],"%d",&iterations);
	printf("iterations is %d\n",iterations);
	int max_tag;
	sscanf(argv[2],"%d",&max_tag);
	printf("max_tag is %d\n",max_tag);
	
  // Get the rank of the process
  int world_rank;
  MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);

	int * pSend = malloc(max_tag*sizeof(int));
	for(int i =0 ;i<max_tag;i++) {
		pSend[i]=i;
	}

	MPI_Request * pReq = malloc(max_tag*sizeof(MPI_Request));
	MPI_Status status;
	int i,token;
	for( i=0;i<iterations;i++) {
			if( world_rank == 0 ) {
				//this is the root
				for(int tag=0;tag<max_tag;tag++) 
					MPI_Isend(pSend,    1,MPI_INT, // the send data size 
						1,i,MPI_COMM_WORLD,pReq+tag); // rank, tag
			} else {
				assert(world_rank == 1);
				for(int tag=0;tag<max_tag;tag++) {
					MPI_Irecv(&token,1,MPI_INT,
						0,i,MPI_COMM_WORLD, // rank , tag
						pReq+tag);
					MPI_Wait(pReq+tag,&status);
					assert(token==tag);
				}
			}
	}
	double end=MPI_Wtime();
	if(world_rank==0)
		printf("wall time %f\n",end-start);

	MPI_Finalize();
	return 0;
}

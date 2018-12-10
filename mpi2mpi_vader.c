#include <omp.h> 
#include <mpi.h> 

#include <stdlib.h> 
#include <stdio.h> 
#include <time.h> 
#include <assert.h> 
#include <ctype.h> 

int main(int argc,char * argv[]) {

  MPI_Init(NULL, NULL);
	if(argc !=3) {
		printf("usage : mpi2mpi.exe <iterations> <max_tag>");
		return 0;
	}

  // Get the rank of the process
  int world_rank;
  MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);

	int iterations;
	sscanf(argv[1],"%d",&iterations);
	if(world_rank==0)
		printf("iterations is %d\n",iterations);

	int max_tag;
	sscanf(argv[2],"%d",&max_tag);
	if(world_rank==0)
		printf("max_tag is %d\n",max_tag);
	

	int * pSend = malloc(max_tag*sizeof(int));
	for(int i =0 ;i<max_tag;i++) {
		pSend[i]=i;
	}

	MPI_Request * pReq = malloc(max_tag*sizeof(MPI_Request));
	MPI_Status status;
	int i,token;
	double start=MPI_Wtime();
	for( i=0;i<iterations;i++) {
			if( world_rank == 0 ) {
				//this is the root
					MPI_Send(&i,    1,MPI_INT, // the send data size 
						1,0,MPI_COMM_WORLD); // rank, tag
					MPI_Recv(&token,1,MPI_INT,
						1,0,MPI_COMM_WORLD,MPI_STATUS_IGNORE);
					assert(token==i);
			} else {
				assert(world_rank == 1);
					MPI_Recv(&token,1,MPI_INT,
						0,0,MPI_COMM_WORLD, // rank , tag
						MPI_STATUS_IGNORE);
					assert(token==i);
					MPI_Send(&i,    1,MPI_INT, // the send data size 
						0,0,MPI_COMM_WORLD);
			}
	}
	double end=MPI_Wtime();
	if(world_rank==0)
		printf("wall time %f\n",end-start);

	MPI_Finalize();
	return 0;
}

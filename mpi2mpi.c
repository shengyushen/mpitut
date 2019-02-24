#include <omp.h> 
#include <mpi.h> 

#include <stdlib.h> 
#include <stdio.h> 
#include <time.h> 
#include <assert.h> 
#include <ctype.h> 

int main(int argc,char * argv[]) {

  MPI_Init(NULL, NULL);
	if(argc !=4) {
		printf("usage : mpi2mpi.exe <iterations> <max_tag> <test order>\n");
		printf("<test order> : 1.in order 2.rev order 3.random order\n");
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
	
	int order;
	sscanf(argv[3],"%d",&order);
	if(world_rank==0)
		printf("order is %d\n",order);
	assert(order==1 || order==2);

	int * pSend = malloc(max_tag*sizeof(int));
	for(int i =0 ;i<max_tag;i++) {
		pSend[i]=i;
	}

	MPI_Request * pReq = malloc(max_tag*sizeof(MPI_Request));
	MPI_Status status;
	int i,token;
	double start=MPI_Wtime();
	for( i=0;i<iterations/max_tag;i++) {
		if( world_rank == 0 ) {
			//this is the root
			for(int tag=0;tag<max_tag;tag++) 
				MPI_Isend(pSend+tag,    1,MPI_INT, // the send data size 
						1,tag,MPI_COMM_WORLD,pReq+tag); // rank, tag
		} 
		
		MPI_Barrier(MPI_COMM_WORLD);
		if(world_rank != 0) {
			assert(world_rank == 1);
				if(order==1) {
					for(int tag=0;tag<max_tag;tag++) 
						MPI_Irecv(pSend+tag,1,MPI_INT,
							0,tag,MPI_COMM_WORLD, // rank , tag
							pReq+tag);
					for(int tag=0;tag<max_tag;tag++)  {
						MPI_Wait(pReq+tag,&status);
						assert(pSend[tag]==tag);
					}
				} else if(order==2) {
					for(int tag=max_tag-1;tag>=0;tag--) 
						MPI_Irecv(pSend+tag,1,MPI_INT,
							0,tag,MPI_COMM_WORLD, // rank , tag
							pReq+tag);
					for(int tag=max_tag-1;tag>=0;tag--)  {
						MPI_Wait(pReq+tag,&status);
						assert(pSend[tag]==tag);
					}
				} else {
						assert(order==3);
				}
		}
	}
	double end=MPI_Wtime();
	if(world_rank==0)
		printf("wall time at order %d and max_tag %d is %f\n",order,max_tag,end-start);

	MPI_Finalize();
	return 0;
}

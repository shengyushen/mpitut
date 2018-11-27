#include <omp.h> 
#include <mpi.h> 

#include <stdlib.h> 
#include <stdio.h> 
#include <time.h> 
#include <assert.h> 
#include <ctype.h> 

int main(int argc,char * argv[]) {

	if(argc!=3) {
		printf("usage : tagm <thread number> <iterations>\n");
		return 1;
	}
	char* thread_num_str = argv[1];
	int thread_num;
	sscanf(thread_num_str,"%d",&thread_num);

	int iterations;
	sscanf(argv[2],"%d",&iterations);

	int provided;
	MPI_Init_thread(NULL, NULL,MPI_THREAD_MULTIPLE,&provided);
	assert(MPI_THREAD_MULTIPLE==provided);

  // Get the number of processes
  int world_size;
  MPI_Comm_size(MPI_COMM_WORLD, &world_size);
	if(world_size != 2) {
		printf("Fatal : world size is not 2\n");
		MPI_Abort(MPI_COMM_WORLD ,1);
	}

  // Get the rank of the process
  int world_rank;
  MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);

	double start=MPI_Wtime();

	#pragma omp parallel num_threads(thread_num)
	{
		int tid=omp_get_thread_num();
		int i,token;
		for( i=0;i<iterations;i++)
		if( world_rank == 0) {
			//this is the root
			MPI_Send(&i,    1,MPI_INT,1-world_rank,tid,MPI_COMM_WORLD);
			if((i%10000)==0)
				printf("rank %d tid %d send token %d\n",world_rank,tid,i);
			MPI_Recv(&token,1,MPI_INT,1-world_rank,tid,MPI_COMM_WORLD,MPI_STATUS_IGNORE);
			if((i%10000)==0)
				printf("rank %d tid %d recv token %d\n",world_rank,tid,token);
		} else {
			MPI_Recv(&token,1,MPI_INT,1-world_rank,tid,MPI_COMM_WORLD,MPI_STATUS_IGNORE);
			if((i%10000)==0)
				printf("rank %d tid %d receive token %d\n",world_rank,tid,token);
			MPI_Send(&i,    1,MPI_INT,1-world_rank,tid,MPI_COMM_WORLD);
			if((i%10000)==0)
				printf("rank %d tid %d send token %d\n",world_rank,tid,i);
		}
	}
	double end=MPI_Wtime();
	if(world_rank==0)
		printf("wall time %f\n",end-start);
//	#pragma omp parallel
//	{
//		int nthread = omp_get_num_threads();
//		int tid = omp_get_thread_num();
//		printf("tid %d hello\n",tid);
//		
//	}

	MPI_Finalize();
	return 0;
}

#include <omp.h> 
#include <mpi.h> 

#include <stdlib.h> 
#include <stdio.h> 
#include <time.h> 
#include <assert.h> 
#include <ctype.h> 

int main(int argc,char * argv[]) {

	if(argc!=4) {
		printf("usage : tagm <thread number> <iterations> <gap>\n");
		return 1;
	}
	char* thread_num_str = argv[1];
	int thread_num;
	sscanf(thread_num_str,"%d",&thread_num);

	int iterations;
	sscanf(argv[2],"%d",&iterations);

	int gap;
	sscanf(argv[3],"%d",&gap);

	int provided;
	MPI_Init_thread(&argc, &argv,MPI_THREAD_MULTIPLE,&provided);
	assert(MPI_THREAD_MULTIPLE==provided);

  // Get the number of processes
  int world_size;
  MPI_Comm_size(MPI_COMM_WORLD, &world_size);
	if(world_size != 2) {
		printf("Fatal : world size is not 2 but %d\n",world_size);
		MPI_Abort(MPI_COMM_WORLD ,1);
	}

  // Get the rank of the process
  int world_rank;
  MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);

	double start=MPI_Wtime();

	#pragma omp parallel num_threads(thread_num) 
	{
		int tid;
		int i,token;
		tid=omp_get_thread_num();
		for( i=0;i<iterations;i++)
		if( world_rank == 0) {
			//this is the root
			MPI_Send(&tid,    1,MPI_INT,1-world_rank,tid,MPI_COMM_WORLD);
			if((i%gap)==0)
				printf("rank %d tid %d send token %d\n",world_rank,tid,i);
			MPI_Recv(&token,1,MPI_INT,1-world_rank,tid,MPI_COMM_WORLD,MPI_STATUS_IGNORE);
			assert(token==tid);
			if((i%gap)==0)
				printf("rank %d tid %d recv token %d\n",world_rank,tid,token);
		} else {
			assert(world_rank==1);
			MPI_Recv(&token,1,MPI_INT,1-world_rank,tid,MPI_COMM_WORLD,MPI_STATUS_IGNORE);
			assert(token==tid);
			if((i%gap)==0)
				printf("rank %d tid %d receive token %d\n",world_rank,tid,token);
			MPI_Send(&tid,    1,MPI_INT,1-world_rank,tid,MPI_COMM_WORLD);
			if((i%gap)==0)
				printf("rank %d tid %d send token %d\n",world_rank,tid,i);
		}
	}
	double end=MPI_Wtime();
	if(world_rank==0)
		printf("thread_num %d wall time %f\n", thread_num,end-start);
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

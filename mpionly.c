#include <omp.h> 
#include <mpi.h> 

#include <stdlib.h> 
#include <stdio.h> 
#include <time.h> 
#include <assert.h> 
#include <ctype.h> 
#include <string.h> 

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
	//MPI_Init_thread(NULL, NULL,MPI_THREAD_MULTIPLE,&provided);
	MPI_Init(NULL, NULL);
	//assert(MPI_THREAD_MULTIPLE==provided);

  // Get the number of processes
  int world_size;
  MPI_Comm_size(MPI_COMM_WORLD, &world_size);
	printf("world_size is %d\n",world_size);

	char procname11[MPI_MAX_PROCESSOR_NAME];
	int len;
	MPI_Get_processor_name(procname11,&len);

  // Get the rank of the process
  int world_rank;
  MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);
	printf("rankhaha %d on %s\n",world_rank,procname11);
	if(world_rank<thread_num) {
		assert(strcmp(procname11,"gpu1")==0 || strcmp(procname11,"GPU1")==0);
	} else {
		assert(strcmp(procname11,"GPU4")==0 || strcmp(procname11,"gpu4")==0);
	}

	double start=MPI_Wtime();

		int i,token;
		for( i=0;i<iterations;i++)
		if( world_rank < thread_num) {
			//this is the process on gpu1
			MPI_Send(&i,    1,MPI_INT,thread_num+world_rank,world_rank,MPI_COMM_WORLD);
			if((i%gap)==0)
				printf("rank %d send token %d\n",world_rank,i);
			MPI_Recv(&token,1,MPI_INT,thread_num+world_rank,thread_num+world_rank,MPI_COMM_WORLD,MPI_STATUS_IGNORE);
			assert(i==token);
			if((i%gap)==0)
				printf("rank %d recv token %d\n",world_rank,token);
		} else {
			assert(world_rank>=thread_num);
			MPI_Recv(&token,1,MPI_INT,world_rank-thread_num,world_rank-thread_num,MPI_COMM_WORLD,MPI_STATUS_IGNORE);
			assert(i==token);
			if((i%gap)==0)
				printf("rank %d receive token %d\n",world_rank,token);
			MPI_Send(&i,    1,MPI_INT,world_rank-thread_num,world_rank,MPI_COMM_WORLD);
			if((i%gap)==0)
				printf("rank %d send token %d\n",world_rank,i);
		}
	double end=MPI_Wtime();
	if(world_rank==0)
		printf("wall time %f\n",end-start);

	MPI_Finalize();
	return 0;
}

#include <omp.h> 
#include <mpi.h> 

#include <stdlib.h> 
#include <stdio.h> 
#include <time.h> 
#include <assert.h> 
#include <ctype.h> 

int main(int argc,char * argv[]) {

	if(argc!=3) {
		printf("usage : tagm <thread number> <buf size>\n");
		return 1;
	}
	char* thread_num_str = argv[1];
	int thread_num;
	sscanf(thread_num_str,"%d",&thread_num);

	int bufsize;
	sscanf(argv[2],"%d",&bufsize);

	int iterations;
	int gap;
	if(bufsize%sizeof(int) != 0) {
		printf("Error : invalid bufsize %d\n",bufsize);
	}
	if(bufsize<1024) {
		iterations =1024*1024;
	} else if(bufsize < 1024*32) {
		iterations =1024*32;
	} else if(bufsize < 1024*1024) {
		iterations =1024;
	} else if(bufsize < 1024*1024*32) {
		iterations =32;
	} else if(bufsize < 1024*1024*1024) {
		iterations =1;
	}


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
		void * pbufsend=malloc(bufsize);
		for(i=0;i<bufsize/sizeof(int);i++) ((int*)pbufsend)[i]=i;
		void * pbufrecv=malloc(bufsize);
		for( i=0;i<iterations;i++) {
			if( world_rank == 0) {
				//this is the root
				MPI_Send(pbufsend,    bufsize/sizeof(int),MPI_INT,1-world_rank,tid,MPI_COMM_WORLD);
	//			if((i%gap)==0)
	//				printf("rank %d tid %d send token %d\n",world_rank,tid,i);
				MPI_Recv(pbufrecv,bufsize/sizeof(int),MPI_INT,1-world_rank,tid,MPI_COMM_WORLD,MPI_STATUS_IGNORE);
				assert(((int*)pbufrecv)[0]==0);
				if(bufsize>4) {
					int j=bufsize/(2*sizeof(int));
					int v = ((int*)pbufrecv)[j];
					assert(v == j);
					j=bufsize/(sizeof(int))-1;
					v = ((int*)pbufrecv)[j];
					assert(v == j);
				}
//				assert(token==tid);
	//			if((i%gap)==0)
	//				printf("rank %d tid %d recv token %d\n",world_rank,tid,token);
			} else {
				assert(world_rank==1);
				MPI_Recv(pbufrecv,bufsize/sizeof(int),MPI_INT,1-world_rank,tid,MPI_COMM_WORLD,MPI_STATUS_IGNORE);
				assert(((int*)pbufrecv)[0]==0);
				if(bufsize>4) {
					int j=bufsize/(2*sizeof(int));
					int v = ((int*)pbufrecv)[j];
					assert(v == j);
					j=bufsize/(sizeof(int))-1;
					v = ((int*)pbufrecv)[j];
					assert(v == j);
				}
	//			if((i%gap)==0)
	//				printf("rank %d tid %d receive token %d\n",world_rank,tid,token);
				MPI_Send(pbufsend,    bufsize/sizeof(int),MPI_INT,1-world_rank,tid,MPI_COMM_WORLD);
	//			if((i%gap)==0)
	//				printf("rank %d tid %d send token %d\n",world_rank,tid,i);
			}
		}
		free(pbufsend);
		free(pbufrecv);
	}
	double end=MPI_Wtime();
	if(world_rank==0)
		printf("thread_num %d bufsize %d wall time %f us\n", thread_num,bufsize,(end-start)*1000*1000/iterations);
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

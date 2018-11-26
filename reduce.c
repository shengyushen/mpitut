// Author: Wes Kendall
// Copyright 2011 www.mpitutorial.com
// This code is provided freely with the tutorials on mpitutorial.com. Feel
// free to modify it for your own use. Any distribution of the code must
// either provide a link to www.mpitutorial.com or keep this header intact.
//
// An intro MPI hello world program that uses MPI_Init, MPI_Comm_size,
// MPI_Comm_rank, MPI_Finalize, and MPI_Get_processor_name.
//
#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>

#define SIZE 4

int main(int argc, char** argv) {
  // Initialize the MPI environment. The two arguments to MPI Init are not
  // currently used by MPI implementations, but are there in case future
  // implementations might need the arguments.
  MPI_Init(NULL, NULL);

  // Get the number of processes
  int world_size;
  MPI_Comm_size(MPI_COMM_WORLD, &world_size);
	//printf("process number %d\n",world_size);

  // Get the rank of the process
  int world_rank;
  MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);
	//printf("current process %d\n",world_rank);

  // Get the name of the processor
  char processor_name[MPI_MAX_PROCESSOR_NAME];
  int name_len;
  MPI_Get_processor_name(processor_name, &name_len);


	int root_rank=2;
	int  ptoken[SIZE];
	for(int i=0;i<SIZE;i++) {
		ptoken[i]=i*world_rank;
	}
	printf("rank %d is ",world_rank);
	for(int i=0;i<SIZE;i++) {
		printf("%d ",ptoken[i]);
	}
	printf("\n");
	int precevdata[SIZE];

	MPI_Reduce(&(ptoken[0]),&(precevdata[0]),SIZE,MPI_INT,MPI_SUM,root_rank,MPI_COMM_WORLD);

	if( world_rank == root_rank) {
		//this is the root
		printf("reduce result is ");
		for(int i=0;i<SIZE;i++) {
			printf("%d ",precevdata[i]);
		}
		printf("\n");
	} 
  // Finalize the MPI environment. No more MPI calls can be made after this
  MPI_Finalize();
}

mpirun --allow-run-as-root --oversubscribe --npernode 1 -report-bindings -bind-to numa -H gpu1,gpu3 mpiomp.exe 28 100000

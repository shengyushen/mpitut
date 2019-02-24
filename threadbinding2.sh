#!/bin/bash
cat threadbinding.txt|awk '{printf $0 " " ; getline;print $0}' > threadbinding2.txt

cat threadbinding2.txt|grep "cores close"|awk '{if($4!=last) {print ""} ; print $4 " " $6 " " $9 ; last=$4}' > "cores_close"
cat threadbinding2.txt|grep "threads close"|awk '{if($4!=last) {print ""} ; print $4 " " $6 " " $9 ; last=$4}' > "threads_close"
cat threadbinding2.txt|grep "sockets close"|awk '{if($4!=last) {print ""} ; print $4 " " $6 " " $9 ; last=$4}' > "sockets_close"

cat threadbinding2.txt|grep "cores spread"|awk '{if($4!=last) {print ""} ; print $4 " " $6 " " $9 ; last=$4}' > "cores_spread"
cat threadbinding2.txt|grep "threads spread"|awk '{if($4!=last) {print ""} ; print $4 " " $6 " " $9 ; last=$4}' > "threads_spread"
cat threadbinding2.txt|grep "sockets spread"|awk '{if($4!=last) {print ""} ; print $4 " " $6 " " $9 ; last=$4}' > "sockets_spread"

./threadbinding2.plt

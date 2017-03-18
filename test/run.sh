#!/bin/bash

for i in *.c
do
		name=$(echo $i|cut -f 1 -d .)
		clang -emit-llvm -S -o $name.ll $i
		clang -Xclang -load -Xclang ../build/skeleton/libSkeletonPass.so $i -o $name > $name.log 2>&1 
		rm -f $name
done

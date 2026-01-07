#!/bin/bash
source ./progress.sh 123

for i in $(seq 1 123)
do
    increment $i
    sleep 3
done

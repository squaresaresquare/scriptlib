#!/bin/bash
x=$1
for i in $(seq ${x:=10})
do
    echo -ne '\a'
    sleep .1
done

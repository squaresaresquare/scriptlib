#!/bin/bash
ls -lh tmp.txt 2>/dev/null| grep -q '1.0G .* tmp.txt'
if [ $? -ne 0 ];then
    gzip -dc /tmp/big_file.txt.gz > tmp.txt
fi

if [ -f tmp.txt ];then
    cp tmp.txt tmp2.txt
    for i in $(seq 1 9)
    do
        cat tmp.txt >> tmp2.txt
    done
    mv tmp2.txt tmp.txt
fi

mv tmp.txt big_file-10g.txt

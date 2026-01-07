#!/bin/bash
function increment ()
{
    curr=0
    num=$1
    #clear the line
    for j in $(seq 1 $(echo "$cols + 2"|bc))
    do
        printf "\b \b"
    done
    curr=$(echo "$num / $incremental"|bc)
    printf "["
    if [ $curr -gt 0 ];then
        for num in $(seq $curr)
        do
            printf "%s" $block_character
        done
    fi
    for num in $(seq $(echo "40 - $curr"|bc))
    do
       printf " "
    done
    printf "]" 
}
cols=$(tput cols)
if [ $cols -gt 42 ];then
    cols=40
fi
total=$1
block_character="▒"
incremental=$(echo "$total / $cols" | bc) 

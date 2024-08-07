#!/bin/bash

function draw_box {
   width=$1
   local chunk="${*:2}"
   local chunk_length=$(echo "$chunk" | awk ' { if ( length > x ) { x = length } }END{ print x }')
   IFS=$'\n'
   declare -a array=()
   array=($(echo "$chunk"))
   # print the top
   if [[ $(echo "$chunk" | awk ' { if ( length > x ) { x = length } }END{ print x }') < 3 && $width < 3 ]];then
      length=$(echo "$width - 1"|bc)
   else
      length=$width
   fi
   echo -n "┌──"

   v=$(printf "%-$(echo ${length})s" "─")
   
   #[ $length -gt 1 ] && v=$(printf "%-$([[ $chunk_length > 3 ]]  && echo "${length} - 1"|bc)s" "─") || v=""
  
   echo "${v// /─}──┐"

   for string in ${array[@]}
   do
       front=""
       # clean the string
       string="$(echo -n $string|expand -t4|tr -dc '[[:print:]]'| tr -d '\n')"
       front="$string"
       if [ ${#string} -gt $width ];then
           while [ ${#string} -gt 0 ]
           do  
               front="$string"
               echo -n "│ "
               echo "${#string} -gt $width"
               if [ ${#string} -gt $width ];then
                   echo "$front"
                   front="$(echo -n "$front"|cut -c 1-$width)"
                   echo "$front"
                   echo "$string"
                   string=$(echo "$string"|cut -c ${#front}-${#string})
                   echo "$string"
                   echo "$front │"
               else
                   let padding=$(echo "$width - ${#front}"|bc)
                   v=$(printf "%-${padding}s" " ")
                   front+="$(echo -n "${v// / }")"
                   echo "$front │"
                   string=""
               fi
               front=""
           done
       else
           echo -n "│ "
           let padding=$(echo "$width - ${#front}"|bc)
           v=$(printf "%-${padding}s" " ")
           front+="$(echo -n "${v// / }"|tr -d '\n')"
           echo "$front │"
       fi       
   done
   echo -n "└──"
   [ $length -gt 1 ] && v=$(printf "%-${length}s" "─") || v=""
   echo "${v// /─}──┘" 
}

piped_in=$(< /dev/stdin)
width_flag=false
COLS=0
terminal_width=$(tput cols)
while getopts 'w' OPTION; do
  case "$OPTION" in 
    w) 
      width_flag=true
      ;;
    *) 
      ;;
  esac
done
if [ $width_flag ];then
    shift $(($OPTIND - 1))
fi

nl=$'\n'

if [[ "$@" != "" && "$piped_in" == "" ]];then 
    chunk="$@"
elif [[ "$@" != "" && "$piped_in" != "" ]];then
    chunk="$piped_in$nl$@"
elif [[ "$@" == "" && "$piped_in" != "" ]];then
    chunk="$piped_in"
fi

if $width_flag ;then
    length=$(echo "$chunk" | awk ' { if ( length > x ) { x = length } }END{ print x }')
   
    if [ $length -gt $terminal_width ];then
        COLS=$(echo "$terminal_width - 5"|bc)
    else
        COLS=$(echo "${length} + 1"|bc)
    fi
else
    COLS=$(echo "$terminal_width - 5"|bc)
fi
draw_box ${COLS:=1} "$chunk"
